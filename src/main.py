import os
import sys
import threading

# B1: ensure src/ is on the path regardless of working directory
sys.path.insert(0, os.path.dirname(__file__))

from dotenv import load_dotenv

# When frozen by PyInstaller, .env must sit next to the .exe
if getattr(sys, "frozen", False):
    BASE_DIR = os.path.dirname(sys.executable)
else:
    BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
load_dotenv(os.path.join(BASE_DIR, ".env"))

from spotify_client import SpotifyClient
from lyrics_client  import fetch_lyrics
from ui.app_window  import AppWindow


def main():
    client_id     = os.getenv("SPOTIPY_CLIENT_ID")
    client_secret = os.getenv("SPOTIPY_CLIENT_SECRET")
    redirect_uri  = os.getenv("SPOTIPY_REDIRECT_URI", "http://localhost:8888/callback")

    if not client_id or not client_secret:
        print(
            "ERROR: Missing Spotify credentials.\n"
            "Copy .env.example to .env and fill in your Client ID and Secret.\n"
            "See README.md for setup instructions."
        )
        sys.exit(1)

    window = AppWindow()

    # B2: generation counter — incremented on every track change so stale
    # lyric fetches (from rapid skipping) don't overwrite newer results.
    _generation = [0]

    def on_track_change(artist, title, duration_ms, progress_ms):
        _generation[0] += 1
        gen = _generation[0]
        window.set_track(artist, title, duration_ms, progress_ms)
        window.set_fetching()
        threading.Thread(
            target=_load_lyrics,
            args=(artist, title, gen),
            daemon=True,
        ).start()

    def _load_lyrics(artist, title, gen):
        result = fetch_lyrics(artist, title)
        if gen == _generation[0]:
            window.root.after(0, lambda: window.set_lyrics(result))

    def on_status_change(status):
        window.root.after(0, lambda: window.set_status(status))

    spotify = SpotifyClient(
        client_id=client_id,
        client_secret=client_secret,
        redirect_uri=redirect_uri,
        on_track_change=on_track_change,
        on_status_change=on_status_change,
    )
    spotify.start()

    window.run()
    spotify.stop()


if __name__ == "__main__":
    main()
