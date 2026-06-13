import re
import requests

LYRICS_OVH_URL = "https://api.lyrics.ovh/v1/{artist}/{title}"
TIMEOUT = 8


def fetch_lyrics(artist: str, title: str) -> str:
    # Strip featured artists and other noise from title for better API match
    clean_title = re.sub(r"\(feat\..*?\)|\(ft\..*?\)|\[.*?\]", "", title, flags=re.IGNORECASE).strip()
    clean_artist = artist.split(",")[0].strip()

    try:
        url = LYRICS_OVH_URL.format(
            artist=requests.utils.quote(clean_artist),
            title=requests.utils.quote(clean_title),
        )
        resp = requests.get(url, timeout=TIMEOUT)
        if resp.status_code == 200:
            data = resp.json()
            lyrics = data.get("lyrics", "").strip()
            if lyrics:
                return lyrics
        return None
    except requests.RequestException:
        return None
