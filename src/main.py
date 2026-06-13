import os
import sys
import threading
from dotenv import load_dotenv

# Support running from the src/ dir or from the project root
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

    def on_track_change(artist, title, duration_ms, progress_ms):
        window.set_track(artist, title, duration_ms, progress_ms)
        window.set_lyrics(None)      # clear while fetching
        # Fetch lyrics off the main thread
        threading.Thread(
            target=_load_lyrics,
            args=(artist, title),
            daemon=True,
        ).start()

    def _load_lyrics(artist, title):
        lyrics = fetch_lyrics(artist, title)
        window.root.after(0, lambda: window.set_lyrics(lyrics))

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
