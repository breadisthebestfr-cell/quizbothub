import os
import tkinter as tk
import time

# Colour palette — F3: overridable via .env
BG           = "#0A0A0A"
GREEN_BRIGHT = os.getenv("GREEN_COLOR",  "#00FF41")
GREEN_DIM    = "#004D14"
GREEN_GLOW   = "#003D10"
SCANLINE     = "#0D0D0D"
AMBER        = "#FFB000"

FONT_FAMILY  = "Courier New"
FONT_SIZE_LG = 14
FONT_SIZE_MD = 12
FONT_SIZE_SM = 10

# F3: configurable via .env
SCANLINE_GAP  = int(os.getenv("SCANLINE_GAP",   "3"))
FPS           = 20
FRAME_MS      = 1000 // FPS
CHAR_DELAY_MS = int(os.getenv("CHAR_DELAY_MS",  "15"))
NEWLINE_PAUSE = int(os.getenv("NEWLINE_PAUSE_MS","80"))


class CRTCanvas(tk.Canvas):
    """Full-window canvas that renders the retro terminal UI."""

    def __init__(self, master, **kwargs):
        super().__init__(master, bg=BG, highlightthickness=0, **kwargs)

        # Playback state
        self.artist      = ""
        self.title       = ""
        self.status      = "CONNECTING..."
        self.progress_ms = 0
        self.duration_ms = 0

        # Lyrics state
        self._full_lyrics   = ""
        self._typed_chars   = 0
        self._typing_active = False
        self._typing_job    = None
        self._fetching      = False   # U1: True while waiting for API response

        # Scroll
        self._scroll_offset = 0
        self._lines_cache   = []

        # Cursor blink
        self._cursor_visible = True
        self._last_blink     = time.time()
        self.BLINK_INTERVAL  = 0.5

        self.bind("<MouseWheel>", self._on_mousewheel)
        self.bind("<Button-4>",   self._on_mousewheel)   # Linux scroll up
        self.bind("<Button-5>",   self._on_mousewheel)   # Linux scroll down
        self.bind("<Up>",         lambda e: self._scroll(-1))
        self.bind("<Down>",       lambda e: self._scroll(1))
        self.bind("<space>",      self._skip_typewriter)  # U2
        self.focus_set()

        self._schedule_redraw()

    # ------------------------------------------------------------------ Public

    def set_track(self, artist: str, title: str):
        self.artist = artist
        self.title  = title
        self._scroll_offset = 0

    def set_fetching(self):
        """U1: Called immediately when a new track is detected, before lyrics arrive."""
        self._cancel_typing()
        self._fetching    = True
        self._full_lyrics = ""
        self._lines_cache = []

    def set_lyrics(self, result: tuple):
        """
        U4: Accepts a typed result tuple from lyrics_client:
          ("ok",        text)
          ("not_found", None)
          ("error",     None)
        """
        self._fetching = False
        self._cancel_typing()

        kind, text = result
        if kind == "ok" and text:
            self._full_lyrics = text
        elif kind == "error":
            self._full_lyrics = "[ NETWORK ERROR ]\n\nCould not reach the lyrics server.\nCheck your internet connection."
        else:
            self._full_lyrics = "[ LYRICS NOT FOUND ]\n\nThis track has no lyrics\nin the database."

        self._typed_chars   = 0
        self._lines_cache   = []
        self._typing_active = True
        self._schedule_next_char()

    def set_status(self, status: str):
        if status.startswith("PLAYING|"):
            parts = status.split("|")
            try:
                self.progress_ms = int(parts[1])
                self.duration_ms = int(parts[2])
                self.status = "PLAYING"
            except (IndexError, ValueError):
                pass
        else:
            self.status = status

    def set_progress(self, progress_ms: int, duration_ms: int):
        self.progress_ms = progress_ms
        self.duration_ms = duration_ms

    # ----------------------------------------------------------- Typewriter

    def _cancel_typing(self):
        self._typing_active = False
        if self._typing_job:
            self.after_cancel(self._typing_job)
            self._typing_job = None

    def _skip_typewriter(self, event=None):
        """U2: Space instantly completes the typewriter animation."""
        if self._typing_active:
            self._cancel_typing()
            self._typed_chars = len(self._full_lyrics)
            self._rebuild_lines()

    def _schedule_next_char(self):
        if not self._typing_active:
            return
        if self._typed_chars >= len(self._full_lyrics):
            self._typing_active = False
            self._rebuild_lines()
            return

        ch = self._full_lyrics[self._typed_chars]
        self._typed_chars += 1
        self._rebuild_lines()

        delay = NEWLINE_PAUSE if ch == "\n" else CHAR_DELAY_MS
        self._typing_job = self.after(delay, self._schedule_next_char)

    def _rebuild_lines(self):
        text = self._full_lyrics[:self._typed_chars]
        self._lines_cache = text.split("\n")

    # ----------------------------------------------------------- Scroll

    def _on_mousewheel(self, event):
        if hasattr(event, "delta"):
            self._scroll(-1 if event.delta > 0 else 1)
        elif event.num == 4:
            self._scroll(-1)
        elif event.num == 5:
            self._scroll(1)

    def _scroll(self, direction: int):
        # B4: clamp both ends — no blank screen past the last line
        max_offset = max(0, len(self._lines_cache) - 1)
        self._scroll_offset = max(0, min(self._scroll_offset + direction * 3, max_offset))

    # ----------------------------------------------------------- Draw loop

    def _schedule_redraw(self):
        self._redraw()
        self.after(FRAME_MS, self._schedule_redraw)

    def _redraw(self):
        self.delete("all")
        w = self.winfo_width()
        h = self.winfo_height()
        if w < 10 or h < 10:
            return

        self._draw_background(w, h)
        self._draw_scanlines(w, h)
        self._draw_ui(w, h)

    def _draw_background(self, w, h):
        self.create_rectangle(0, 0, w, h, fill=BG, outline="")

    def _draw_scanlines(self, w, h):
        y = 0
        while y < h:
            self.create_line(0, y, w, y, fill=SCANLINE, width=1)
            y += SCANLINE_GAP

    def _draw_ui(self, w, h):
        pad_x = 24
        y = 16

        # Header — blinking cursor
        now = time.time()
        if now - self._last_blink > self.BLINK_INTERVAL:
            self._cursor_visible = not self._cursor_visible
            self._last_blink = now
        cursor = "█" if self._cursor_visible else " "
        self._glow_text(pad_x, y, f"LYRICTERM v1.0  >_ {cursor}",
                        size=FONT_SIZE_LG, anchor="nw", bold=True)
        y += 28

        self._glow_text(pad_x, y, "─" * 60, size=FONT_SIZE_SM, anchor="nw")
        y += 20

        # Now Playing
        if self.artist or self.title:
            self._glow_text(pad_x, y, f"♫  {self.artist.upper()}  —  {self.title}",
                            size=FONT_SIZE_MD, anchor="nw", bold=True)
        else:
            self._glow_text(pad_x, y, "♫  WAITING FOR PLAYBACK...", size=FONT_SIZE_MD, anchor="nw")
        y += 26

        # Progress bar
        if self.duration_ms > 0:
            self._glow_text(pad_x, y, self._build_progress_bar(40), size=FONT_SIZE_SM, anchor="nw")
        y += 22

        self._glow_text(pad_x, y, "─" * 60, size=FONT_SIZE_SM, anchor="nw")
        y += 16

        # Lyrics / fetching area
        lyrics_top    = y
        status_height = 28
        lyrics_bottom = h - status_height

        if self._fetching:
            self._draw_fetching(pad_x, lyrics_top)
        else:
            self._draw_lyrics(pad_x, lyrics_top, lyrics_bottom)

        # Status bar
        is_warning = self.status not in ("PLAYING", "CONNECTING...")
        self._glow_text(
            pad_x, h - 18,
            f"[ {self.status} ]",
            size=FONT_SIZE_SM, anchor="sw",
            override_color=AMBER if is_warning else None,
        )

    def _draw_fetching(self, x: int, y: int):
        """U1: Animated 'FETCHING LYRICS...' with a scrolling dot."""
        dots = "." * (int(time.time() * 2) % 4)
        self._glow_text(x, y, f"FETCHING LYRICS{dots:<3}", size=FONT_SIZE_MD, anchor="nw")

    def _draw_lyrics(self, x: int, top: int, bottom: int):
        if not self._lines_cache:
            return

        line_height   = FONT_SIZE_MD + 6
        visible_lines = max(1, (bottom - top) // line_height)

        lines  = self._lines_cache
        offset = min(self._scroll_offset, max(0, len(lines) - visible_lines))
        visible = lines[offset : offset + visible_lines]

        for i, line in enumerate(visible):
            ly = top + i * line_height
            is_last = (offset + i == len(lines) - 1)
            suffix = ("█" if self._cursor_visible else " ") if (self._typing_active and is_last) else ""
            self._glow_text(x, ly, line + suffix, size=FONT_SIZE_MD, anchor="nw")

    def _build_progress_bar(self, width: int = 40) -> str:
        # B3: guard against division by zero
        if self.duration_ms == 0:
            return "[ -- ]"
        filled = int((self.progress_ms / self.duration_ms) * width)
        filled = max(0, min(filled, width))
        bar    = "█" * filled + "░" * (width - filled)
        return f"[{bar}] {self._fmt_time(self.progress_ms)} / {self._fmt_time(self.duration_ms)}"

    @staticmethod
    def _fmt_time(ms: int) -> str:
        s  = ms // 1000
        m  = s // 60
        s %= 60
        return f"{m}:{s:02d}"

    def _glow_text(self, x, y, text, size=FONT_SIZE_MD, anchor="nw", bold=False,
                   override_color=None):
        weight = "bold" if bold else "normal"
        font   = (FONT_FAMILY, size, weight)
        bright = override_color or GREEN_BRIGHT

        for dx, dy in ((-1, -1), (1, -1), (-1, 1), (1, 1)):
            self.create_text(x + dx, y + dy, text=text, fill=GREEN_GLOW,
                             font=font, anchor=anchor)
        self.create_text(x, y, text=text, fill=GREEN_DIM,  font=font, anchor=anchor)
        self.create_text(x, y, text=text, fill=bright,     font=font, anchor=anchor)
