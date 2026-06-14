@echo off
echo [LYRICTERM] Installing dependencies...
pip install -r requirements.txt
pip install pyinstaller Pillow
if errorlevel 1 (
    echo ERROR: pip install failed. Is Python in your PATH?
    pause & exit /b 1
)

echo [LYRICTERM] Generating icon...
python assets\make_icon.py

echo [LYRICTERM] Building executable...
if exist assets\icon.ico (
    set ICON_FLAG=--icon assets\icon.ico
) else (
    set ICON_FLAG=
)

python -m PyInstaller ^
    --onefile ^
    --windowed ^
    --name lyricterm ^
    --paths src ^
    --hidden-import spotipy ^
    --hidden-import spotipy.oauth2 ^
    --hidden-import dotenv ^
    --collect-all spotipy ^
    --add-data "assets;assets" ^
    %ICON_FLAG% ^
    src\main.py

if exist dist\lyricterm.exe (
    echo.
    echo [LYRICTERM] Build successful! Exe is at: dist\lyricterm.exe
    echo.
    echo Copying your credentials into dist\ ...
    if exist .env copy .env dist\.env >nul
    if exist lyricterm.env copy lyricterm.env dist\lyricterm.env >nul
    echo Done. Run dist\lyricterm.exe to launch.
) else (
    echo.
    echo [LYRICTERM] Build FAILED - dist\lyricterm.exe was not created.
    echo Scroll up to find the error.
)
pause
