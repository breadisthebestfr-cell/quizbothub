@echo off
echo ============================================
echo   LYRICTERM - First Time Setup
echo ============================================
echo.
echo You need your Spotify Developer credentials.
echo Get them at: https://developer.spotify.com/dashboard
echo  - Create an app
echo  - Add redirect URI: http://127.0.0.1:8888/callback
echo  - Copy your Client ID and Client Secret
echo.
set /p CLIENT_ID=Paste your Client ID:
set /p CLIENT_SECRET=Paste your Client Secret:
echo.
(
    echo SPOTIPY_CLIENT_ID=%CLIENT_ID%
    echo SPOTIPY_CLIENT_SECRET=%CLIENT_SECRET%
    echo SPOTIPY_REDIRECT_URI=http://127.0.0.1:8888/callback
) > lyricterm.env

echo.
echo Credentials saved to lyricterm.env
echo You can now run: python src\main.py
echo Or build the exe with: build.bat
echo.
pause
