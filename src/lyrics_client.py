import hashlib
import pathlib
import re
import requests

LYRICS_OVH_URL  = "https://api.lyrics.ovh/v1/{artist}/{title}"
LRCLIB_URL      = "https://lrclib.net/api/get"
TIMEOUT         = 8

_CACHE_DIR = pathlib.Path.home() / ".lyricterm" / "cache"

_LRC_PATTERN = re.compile(r"\[(\d+):(\d+\.\d+)\](.*)")


# ------------------------------------------------------------------ cache

def _cache_path(artist: str, title: str, ext: str) -> pathlib.Path:
    key = hashlib.md5(f"{artist.lower()}|{title.lower()}".encode()).hexdigest()
    return _CACHE_DIR / f"{key}.{ext}"


def _write(path: pathlib.Path, text: str) -> None:
    _CACHE_DIR.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


# ------------------------------------------------------------------ LRC helpers

def _parse_lrc(lrc: str) -> list[tuple[int, str]] | None:
    lines = []
    for raw in lrc.split("\n"):
        m = _LRC_PATTERN.match(raw.strip())
        if m:
            ms = int((int(m.group(1)) * 60 + float(m.group(2))) * 1000)
            lines.append((ms, m.group(3).strip()))
    return lines or None


def _fetch_lrc(artist: str, title: str) -> str | None:
    try:
        resp = requests.get(
            LRCLIB_URL,
            params={"artist_name": artist, "track_name": title},
            timeout=TIMEOUT,
        )
        if resp.status_code == 200:
            return resp.json().get("syncedLyrics")  # may be None
    except requests.RequestException:
        pass
    return None


# ------------------------------------------------------------------ public API

def fetch_lyrics(artist: str, title: str) -> tuple:
    """
    Returns one of:
      ("synced",    [(ms, line), ...])   — timestamped lyrics from lrclib.net
      ("ok",        text)                — plain lyrics from lyrics.ovh
      ("not_found", None)
      ("error",     None)
    """
    clean_title  = re.sub(r"\(feat\..*?\)|\(ft\..*?\)", "", title, flags=re.IGNORECASE).strip()
    clean_artist = artist.split(",")[0].strip()

    # LRC cache hit
    lrc_cache = _cache_path(artist, title, "lrc")
    if lrc_cache.exists():
        parsed = _parse_lrc(lrc_cache.read_text(encoding="utf-8"))
        if parsed:
            return ("synced", parsed)

    # Plain lyrics cache hit
    txt_cache = _cache_path(artist, title, "txt")
    if txt_cache.exists():
        return ("ok", txt_cache.read_text(encoding="utf-8"))

    # Try timestamped lyrics first
    raw_lrc = _fetch_lrc(clean_artist, clean_title)
    if raw_lrc:
        _write(lrc_cache, raw_lrc)
        parsed = _parse_lrc(raw_lrc)
        if parsed:
            return ("synced", parsed)

    # Fall back to plain lyrics
    try:
        url  = LYRICS_OVH_URL.format(
            artist=requests.utils.quote(clean_artist),
            title=requests.utils.quote(clean_title),
        )
        resp = requests.get(url, timeout=TIMEOUT)
        if resp.status_code == 200:
            lyrics = resp.json().get("lyrics", "").strip()
            if lyrics:
                _write(txt_cache, lyrics)
                return ("ok", lyrics)
        return ("not_found", None)
    except requests.RequestException:
        return ("error", None)
