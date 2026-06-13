# LYRICTERM

> Retro CRT terminal that shows your Spotify lyrics in real-time.

Green phosphor text. Scanlines. Character-by-character typewriter reveal. Built with Python + Tkinter.

---

## Setup

### 1. Create a Spotify Developer App

1. Go to [developer.spotify.com/dashboard](https://developer.spotify.com/dashboard) and log in.
2. Click **Create App**.
3. Fill in any name/description (e.g. "lyricterm").
4. Set **Redirect URI** to exactly: `http://localhost:8888/callback`
5. Click **Save**, then open your app and copy the **Client ID** and **Client Secret**.

### 2. Configure credentials

Copy the example env file and fill it in:

```bash
cp .env.example .env
```

Edit `.env`:

```
SPOTIPY_CLIENT_ID=paste_your_client_id
SPOTIPY_CLIENT_SECRET=paste_your_client_secret
SPOTIPY_REDIRECT_URI=http://localhost:8888/callback
```

### 3. Install & run (Python)

```bash
pip install -r requirements.txt
python src/main.py
```

On the first run a browser window opens for Spotify login — authorize the app, then return to the terminal. The UI window will appear automatically.

### 4. Build a standalone .exe (Windows)

```bat
build.bat
```

The executable is written to `dist\lyricterm.exe`. **Copy your `.env` file into the same folder as the `.exe` before running it.**

---

## Usage

| Action | Control |
|---|---|
| Scroll lyrics | Mouse wheel or ↑ / ↓ |
| Resize window | Drag any edge |

The app polls Spotify every 3 seconds. When it detects a new song it fetches lyrics and types them out character-by-character.

---

## Lyrics source

Lyrics come from [lyrics.ovh](https://api.lyrics.ovh) — free, no API key required. Not every song is available; uncommon tracks may show **LYRICS NOT FOUND**.

---

## Requirements

- Python 3.10+
- Windows (for `.exe`; the Python script runs on any OS)
- An active Spotify account (free or Premium)
