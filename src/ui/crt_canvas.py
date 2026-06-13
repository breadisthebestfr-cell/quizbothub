import tkinter as tk
import time

# Colour palette
BG           = "#0A0A0A"
GREEN_BRIGHT = "#00FF41"
GREEN_MID    = "#00CC33"
GREEN_DIM    = "#004D14"
GREEN_GLOW   = "#003D10"
SCANLINE     = "#0D0D0D"
AMBER        = "#FFB000"   # used for status warnings

FONT_FAMILY  = "Courier New"
FONT_SIZE_LG = 14
FONT_SIZE_MD = 12
FONT_SIZE_SM = 10

SCANLINE_GAP  = 3   # pixels between scanlines
FPS           = 20
FRAME_MS      = 1000 // FPS

CHAR_DELAY_MS = 15   # ms per character when typing
NEWLINE_PAUSE = 80   # extra ms on newline


class CRTCanvas(tk.Canvas):
    """Full-window canvas that renders the retro terminal UI."""

    def __init__(self, master, **kwargs):
        super().__init__(master, bg=BG, highlightthickness=0, **kwargs)

        # State
        self.artist      = ""
        self.title       = ""
        self.status      = "CONNECTING..."
        self.progress_ms = 0
        self.duration_ms = 0

        # Lyrics typewriter state
        self._full_lyrics   = ""
        self._typed_chars   = 0
        self._typing_active = False
        self._typing_job    = None

        # Scroll
        self._scroll_offset = 0
        self._lines_cache   = []

        # Cursor blink
        self._cursor_visible = True
        self._last_blink     = time.time()
        self.BLINK_INTERVAL  = 0.5

        self.bind("<MouseWheel>",  self._on_mousewheel)
        self.bind("<Button-4>",    self._on_mousewheel)  # Linux scroll up
        self.bind("<Button-5>",    self._on_mousewheel)  # Linux scroll down
        self.bind("<Up>",          lambda e: self._scroll(-1))
        self.bind("<Down>",        lambda e: self._scroll(1))
        self.focus_set()

        self._schedule_redraw()

    # ------------------------------------------------------------------ Public

    def set_track(self, artist: str, title: str):
        self.artist = artist
        self.title  = title
        self._scroll_offset = 0

    def set_lyrics(self, lyrics):
        self._cancel_typing()
        if lyrics:
            self._full_lyrics = lyrics
        else:
            self._full_lyrics = "[ LYRICS NOT FOUND ]\n\nThis track has no lyrics\nin the database."
        self._typed_chars = 0
        self._lines_cache = []
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
        self._scroll_offset = max(0, self._scroll_offset + direction * 3)

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

        # --- Header ---
        now = time.time()
        if now - self._last_blink > self.BLINK_INTERVAL:
            self._cursor_visible = not self._cursor_visible
            self._last_blink = now
        cursor = "█" if self._cursor_visible else " "
        header = f"LYRICTERM v1.0  >_ {cursor}"
        self._glow_text(pad_x, y, header, size=FONT_SIZE_LG, anchor="nw", bold=True)
        y += 28

        # Divider
        self._glow_text(pad_x, y, "─" * 60, size=FONT_SIZE_SM, anchor="nw")
        y += 20

        # --- Now Playing ---
        if self.artist or self.title:
            np_text = f"♫  {self.artist.upper()}  —  {self.title}"
            self._glow_text(pad_x, y, np_text, size=FONT_SIZE_MD, anchor="nw", bold=True)
        else:
            self._glow_text(pad_x, y, "♫  WAITING FOR PLAYBACK...", size=FONT_SIZE_MD, anchor="nw")
        y += 26

        # --- Progress bar ---
        if self.duration_ms > 0:
            bar = self._build_progress_bar(40)
            self._glow_text(pad_x, y, bar, size=FONT_SIZE_SM, anchor="nw")
        y += 22

        # Divider
        self._glow_text(pad_x, y, "─" * 60, size=FONT_SIZE_SM, anchor="nw")
        y += 16

        # --- Lyrics area ---
        lyrics_top    = y
        status_height = 28
        lyrics_bottom = h - status_height

        self._draw_lyrics(pad_x, lyrics_top, lyrics_bottom)

        # --- Status bar ---
        status_color = AMBER if self.status not in ("PLAYING", "CONNECTING...") else GREEN_BRIGHT
        self._glow_text(
            pad_x, h - 18,
            f"[ {self.status} ]",
            size=FONT_SIZE_SM, anchor="sw",
            override_color=status_color if status_color != GREEN_BRIGHT else None,
        )

    def _draw_lyrics(self, x: int, top: int, bottom: int):
        if not self._lines_cache:
            return

        line_height   = FONT_SIZE_MD + 6
        visible_lines = (bottom - top) // line_height

        lines  = self._lines_cache
        offset = min(self._scroll_offset, max(0, len(lines) - visible_lines))
        visible = lines[offset : offset + visible_lines]

        for i, line in enumerate(visible):
            ly = top + i * line_height
            is_last = (offset + i == len(lines) - 1)
            suffix = ("█" if self._cursor_visible else " ") if (self._typing_active and is_last) else ""
            self._glow_text(x, ly, line + suffix, size=FONT_SIZE_MD, anchor="nw")

    def _build_progress_bar(self, width: int = 40) -> str:
        filled = int((self.progress_ms / self.duration_ms) * width)
        filled = max(0, min(filled, width))
        bar    = "█" * filled + "░" * (width - filled)
        elapsed = self._fmt_time(self.progress_ms)
        total   = self._fmt_time(self.duration_ms)
        return f"[{bar}] {elapsed} / {total}"

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

        # Shadow layers (glow effect)
        for dx, dy in ((-1, -1), (1, -1), (-1, 1), (1, 1)):
            self.create_text(x + dx, y + dy, text=text, fill=GREEN_GLOW,
                             font=font, anchor=anchor)
        # Mid glow
        self.create_text(x, y, text=text, fill=GREEN_DIM, font=font, anchor=anchor)
        # Bright top layer
        self.create_text(x, y, text=text, fill=bright, font=font, anchor=anchor)
