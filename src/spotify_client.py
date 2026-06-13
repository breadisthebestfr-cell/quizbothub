import threading
import time
import spotipy
from spotipy.oauth2 import SpotifyOAuth


SCOPES = "user-read-currently-playing user-read-playback-state"
POLL_INTERVAL = 3  # seconds


class SpotifyClient:
    def __init__(self, client_id, client_secret, redirect_uri, on_track_change, on_status_change):
        self._sp = spotipy.Spotify(
            auth_manager=SpotifyOAuth(
                client_id=client_id,
                client_secret=client_secret,
                redirect_uri=redirect_uri,
                scope=SCOPES,
                open_browser=True,
            )
        )
        self._on_track_change = on_track_change
        self._on_status_change = on_status_change
        self._current_track_id = None
        self._running = False
        self._thread = None

    def start(self):
        self._running = True
        self._thread = threading.Thread(target=self._poll_loop, daemon=True)
        self._thread.start()

    def stop(self):
        self._running = False

    def _poll_loop(self):
        while self._running:
            try:
                self._check_playback()
            except Exception as e:
                self._on_status_change(f"ERROR: {e}")
            time.sleep(POLL_INTERVAL)

    def _check_playback(self):
        result = self._sp.current_playback()

        if not result or not result.get("is_playing"):
            self._on_status_change("PAUSED" if result else "NO DEVICE")
            return

        item = result.get("item")
        if not item:
            return

        track_id = item["id"]
        artist = item["artists"][0]["name"]
        title = item["name"]
        duration_ms = item["duration_ms"]
        progress_ms = result.get("progress_ms", 0)

        self._on_status_change("PLAYING")

        if track_id != self._current_track_id:
            self._current_track_id = track_id
            self._on_track_change(artist, title, duration_ms, progress_ms)
        else:
            self._on_status_change(f"PLAYING|{progress_ms}|{duration_ms}")
