@echo off
echo [LYRICTERM] Installing dependencies...
pip install -r requirements.txt
pip install pyinstaller Pillow

echo [LYRICTERM] Generating icon...
python assets\make_icon.py

echo [LYRICTERM] Building executable...
if exist assets\icon.ico (
    pyinstaller --onefile --windowed --name lyricterm --icon assets\icon.ico --add-data "assets;assets" src\main.py
) else (
    pyinstaller --onefile --windowed --name lyricterm --add-data "assets;assets" src\main.py
)

echo.
echo [LYRICTERM] Done! Find your exe at: dist\lyricterm.exe
echo Remember to copy your .env file next to the exe before running it.
pause
