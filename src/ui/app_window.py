import tkinter as tk
from .crt_canvas import CRTCanvas


class AppWindow:
    WIDTH  = 820
    HEIGHT = 620
    TITLE  = "LYRICTERM"

    def __init__(self):
        self.root = tk.Tk()
        self.root.title(self.TITLE)
        self.root.geometry(f"{self.WIDTH}x{self.HEIGHT}")
        self.root.configure(bg="#0A0A0A")
        self.root.resizable(True, True)
        self.root.minsize(600, 420)

        try:
            self.root.iconbitmap("assets/icon.ico")
        except Exception:
            pass

        self.canvas = CRTCanvas(self.root)
        self.canvas.pack(fill="both", expand=True)

    def set_track(self, artist, title, duration_ms, progress_ms):
        # U3: reflect track in window title so it's visible in the taskbar
        self.root.title(f"LYRICTERM  —  {artist}  —  {title}")
        self.canvas.set_track(artist, title)
        self.canvas.set_progress(progress_ms, duration_ms)

    def set_fetching(self):
        self.canvas.set_fetching()

    def set_lyrics(self, result: tuple):
        self.canvas.set_lyrics(result)

    def set_status(self, status):
        self.canvas.set_status(status)

    def run(self):
        self.root.mainloop()
