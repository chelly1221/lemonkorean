#!/usr/bin/env python3
"""
Convert a full character image into spritesheets for the Flame game engine.

Takes a single character PNG and generates:
  - body_default.png: Full character spritesheet (672x192, 21 cols x 4 rows of 32x48)
  - Transparent spritesheets for other default layers (hair, eyes, etc.)

Spritesheet layout:
  Row 0 (front):  idle + 4 walk frames
  Row 1 (back):   idle + 4 walk frames
  Row 2 (right):  idle + 4 walk frames  (left = horizontal flip at runtime)
  Row 3 (gestures): jump(4f) wave(4f) bow(3f) dance(6f) clap(4f) = 21 frames

Usage:
    python3 convert_default_character.py <input_image.png>
"""
import os
import sys

try:
    from PIL import Image, ImageEnhance, ImageFilter
except ImportError:
    print("Error: Pillow not installed. Run: pip install Pillow")
    sys.exit(1)

FRAME_W = 32
FRAME_H = 48
WALK_COLS = 5
GESTURE_FRAMES = 21
TOTAL_COLS = max(WALK_COLS, GESTURE_FRAMES)
ROWS = 4
SHEET_W = TOTAL_COLS * FRAME_W  # 672
SHEET_H = ROWS * FRAME_H        # 192

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.abspath(os.path.join(SCRIPT_DIR, '..', '..'))
OUTPUT_BASE = os.path.join(REPO_ROOT, 'mobile', 'lemon_korean', 'assets', 'sprites', 'character')

# Other default layers to make transparent
OTHER_DEFAULTS = [
    'hair/hair_short.png',
    'eyes/eyes_round.png',
    'eyebrows/eyebrows_natural.png',
    'nose/nose_button.png',
    'mouth/mouth_smile.png',
    'top/top_tshirt.png',
]


def trim_transparent(img):
    """Crop image to non-transparent bounding box."""
    bbox = img.getbbox()
    if bbox:
        return img.crop(bbox)
    return img


def fit_to_frame(img, fw=FRAME_W, fh=FRAME_H, padding=1):
    """Resize image to fit within frame, preserving aspect ratio, with padding."""
    target_w = fw - padding * 2
    target_h = fh - padding * 2

    w, h = img.size
    ratio = min(target_w / w, target_h / h)
    new_w = max(1, int(w * ratio))
    new_h = max(1, int(h * ratio))

    resized = img.resize((new_w, new_h), Image.LANCZOS)

    # Center in frame
    frame = Image.new('RGBA', (fw, fh), (0, 0, 0, 0))
    x = (fw - new_w) // 2
    y = fh - new_h - padding  # align to bottom with padding
    frame.paste(resized, (x, y), resized)
    return frame


def create_back_view(front_frame):
    """Create a back view: darken and desaturate to create silhouette-like appearance."""
    # Create a darkened version
    darkened = ImageEnhance.Brightness(front_frame).enhance(0.35)
    # Shift to a blue-ish tint for "back" feel
    pixels = darkened.load()
    w, h = darkened.size
    result = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    rp = result.load()
    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            if a > 0:
                # Slight blue tint
                rp[x, y] = (max(0, r - 20), max(0, g - 10), min(255, b + 15), a)
            else:
                rp[x, y] = (0, 0, 0, 0)
    return result


def create_right_view(front_frame):
    """Create a right-facing view: shift image and slightly narrow it."""
    w, h = front_frame.size
    # Squish horizontally to give a side-view feel
    narrowed = front_frame.resize((int(w * 0.8), h), Image.LANCZOS)
    frame = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    # Offset to the right slightly
    x_off = (w - narrowed.size[0]) // 2 + 1
    frame.paste(narrowed, (x_off, 0), narrowed)
    return frame


def apply_bob(frame, dy):
    """Shift frame vertically by dy pixels for walking bob."""
    w, h = frame.size
    result = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    paste_y = max(0, dy)
    crop_y = max(0, -dy)
    # Crop from source, paste into result
    cropped = frame.crop((0, crop_y, w, h - max(0, dy)))
    result.paste(cropped, (0, paste_y), cropped)
    return result


def apply_shift(frame, dx, dy):
    """Shift frame by (dx, dy) pixels."""
    w, h = frame.size
    result = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    src_x = max(0, -dx)
    src_y = max(0, -dy)
    dst_x = max(0, dx)
    dst_y = max(0, dy)
    crop_w = w - abs(dx)
    crop_h = h - abs(dy)
    if crop_w <= 0 or crop_h <= 0:
        return result
    cropped = frame.crop((src_x, src_y, src_x + crop_w, src_y + crop_h))
    result.paste(cropped, (dst_x, dst_y), cropped)
    return result


def create_spritesheet(front_idle, back_idle, right_idle):
    """Build the full 672x192 spritesheet from the three view frames."""
    sheet = Image.new('RGBA', (SHEET_W, SHEET_H), (0, 0, 0, 0))

    # Walk bob pattern: idle, down, neutral, up, neutral
    walk_bobs = [0, 1, 0, -1, 0]

    # Row 0: Front (idle + 4 walk)
    for col in range(WALK_COLS):
        frame = apply_bob(front_idle, walk_bobs[col])
        sheet.paste(frame, (col * FRAME_W, 0 * FRAME_H), frame)

    # Row 1: Back (idle + 4 walk)
    for col in range(WALK_COLS):
        frame = apply_bob(back_idle, walk_bobs[col])
        sheet.paste(frame, (col * FRAME_W, 1 * FRAME_H), frame)

    # Row 2: Right (idle + 4 walk)
    for col in range(WALK_COLS):
        frame = apply_bob(right_idle, walk_bobs[col])
        sheet.paste(frame, (col * FRAME_W, 2 * FRAME_H), frame)

    # Row 3: Gestures (using front view with variations)
    gesture_col = 0

    # Jump: 4 frames (move up progressively, then back down)
    jump_dy = [0, -2, -3, -1]
    for i in range(4):
        frame = apply_bob(front_idle, jump_dy[i])
        sheet.paste(frame, (gesture_col * FRAME_W, 3 * FRAME_H), frame)
        gesture_col += 1

    # Wave: 4 frames (slight side-to-side)
    wave_dx = [0, 1, 0, -1]
    for i in range(4):
        frame = apply_shift(front_idle, wave_dx[i], 0)
        sheet.paste(frame, (gesture_col * FRAME_W, 3 * FRAME_H), frame)
        gesture_col += 1

    # Bow: 3 frames (slight downward motion)
    bow_dy = [0, 1, 2]
    for i in range(3):
        frame = apply_bob(front_idle, bow_dy[i])
        sheet.paste(frame, (gesture_col * FRAME_W, 3 * FRAME_H), frame)
        gesture_col += 1

    # Dance: 6 frames (alternating bob and shift)
    dance_moves = [(0, 0), (1, -1), (-1, 0), (0, -1), (1, 0), (-1, -1)]
    for dx, dy in dance_moves:
        frame = apply_shift(front_idle, dx, dy)
        sheet.paste(frame, (gesture_col * FRAME_W, 3 * FRAME_H), frame)
        gesture_col += 1

    # Clap: 4 frames (slight bob)
    clap_dy = [0, -1, 0, -1]
    for i in range(4):
        frame = apply_bob(front_idle, clap_dy[i])
        sheet.paste(frame, (gesture_col * FRAME_W, 3 * FRAME_H), frame)
        gesture_col += 1

    return sheet


def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <input_image.png>")
        sys.exit(1)

    input_path = sys.argv[1]
    if not os.path.exists(input_path):
        print(f"Error: File not found: {input_path}")
        sys.exit(1)

    print(f"Loading: {input_path}")
    source = Image.open(input_path).convert('RGBA')
    print(f"  Source size: {source.size}")

    # Trim transparent edges
    trimmed = trim_transparent(source)
    print(f"  Trimmed size: {trimmed.size}")

    # Create front idle frame (fit to 32x48)
    front_idle = fit_to_frame(trimmed)
    print(f"  Front idle frame: {front_idle.size}")

    # Create directional views
    back_idle = create_back_view(front_idle)
    right_idle = create_right_view(front_idle)

    # Build spritesheet
    sheet = create_spritesheet(front_idle, back_idle, right_idle)

    # Save body_default.png
    body_path = os.path.join(OUTPUT_BASE, 'body', 'body_default.png')
    os.makedirs(os.path.dirname(body_path), exist_ok=True)
    sheet.save(body_path, 'PNG')
    print(f"\n  Saved: {os.path.relpath(body_path, REPO_ROOT)}")

    # Create transparent spritesheets for other default layers
    # (so they don't overlay geometric shapes on the full character)
    transparent = Image.new('RGBA', (SHEET_W, SHEET_H), (0, 0, 0, 0))
    for rel_path in OTHER_DEFAULTS:
        out_path = os.path.join(OUTPUT_BASE, rel_path)
        os.makedirs(os.path.dirname(out_path), exist_ok=True)
        transparent.save(out_path, 'PNG')
        print(f"  Saved (transparent): {os.path.relpath(out_path, REPO_ROOT)}")

    print(f"\nDone! Default character spritesheets generated.")


if __name__ == '__main__':
    main()
