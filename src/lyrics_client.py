import hashlib
import pathlib
import re
import requests

LYRICS_OVH_URL = "https://api.lyrics.ovh/v1/{artist}/{title}"
TIMEOUT = 8

# F1: persistent cache at ~/.lyricterm/cache/
_CACHE_DIR = pathlib.Path.home() / ".lyricterm" / "cache"


def _cache_path(artist: str, title: str) -> pathlib.Path:
    key = hashlib.md5(f"{artist.lower()}|{title.lower()}".encode()).hexdigest()
    return _CACHE_DIR / f"{key}.txt"


def _read_cache(artist: str, title: str) -> str | None:
    path = _cache_path(artist, title)
    return path.read_text(encoding="utf-8") if path.exists() else None


def _write_cache(artist: str, title: str, lyrics: str) -> None:
    _CACHE_DIR.mkdir(parents=True, exist_ok=True)
    _cache_path(artist, title).write_text(lyrics, encoding="utf-8")


def fetch_lyrics(artist: str, title: str) -> tuple[str, str | None]:
    """
    Returns one of:
      ("ok",        lyrics_text)
      ("not_found", None)
      ("error",     None)
    """
    cached = _read_cache(artist, title)
    if cached:
        return ("ok", cached)

    # Strip feat. annotations only — keep [Remix] etc. in title
    clean_title  = re.sub(r"\(feat\..*?\)|\(ft\..*?\)", "", title, flags=re.IGNORECASE).strip()
    clean_artist = artist.split(",")[0].strip()

    try:
        url  = LYRICS_OVH_URL.format(
            artist=requests.utils.quote(clean_artist),
            title=requests.utils.quote(clean_title),
        )
        resp = requests.get(url, timeout=TIMEOUT)
        if resp.status_code == 200:
            lyrics = resp.json().get("lyrics", "").strip()
            if lyrics:
                _write_cache(artist, title, lyrics)
                return ("ok", lyrics)
        return ("not_found", None)
    except requests.RequestException:
        return ("error", None)
