"""Run this once to generate assets/icon.ico before building the exe."""
try:
    from PIL import Image, ImageDraw, ImageFont
except ImportError:
    print("Pillow not installed. Run: pip install Pillow")
    raise SystemExit(1)

import pathlib

SIZE = 256
OUT  = pathlib.Path(__file__).parent / "icon.ico"

img  = Image.new("RGBA", (SIZE, SIZE), (10, 10, 10, 255))
draw = ImageDraw.Draw(img)

# CRT phosphor green block cursor in the centre
margin = SIZE // 8
draw.rectangle([margin, margin, SIZE - margin, SIZE - margin],
               outline=(0, 255, 65, 200), width=6)

# "LT" monogram
try:
    font = ImageFont.truetype("cour.ttf", 96)   # Courier on Windows
except OSError:
    font = ImageFont.load_default()

draw.text((SIZE // 2, SIZE // 2), "LT", fill=(0, 255, 65, 255),
          font=font, anchor="mm")

# Save as multi-size ICO
img.save(OUT, format="ICO", sizes=[(16, 16), (32, 32), (48, 48), (256, 256)])
print(f"Icon saved to {OUT}")
