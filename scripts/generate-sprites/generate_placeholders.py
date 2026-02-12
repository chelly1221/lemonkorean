#!/usr/bin/env python3
"""
Generate placeholder spritesheets for character customization.

Layout per spritesheet: 160x192 px  (5 columns x 4 rows, 32x48 per frame)
  Row 0 (front):  idle + 4 walk frames
  Row 1 (back):   idle + 4 walk frames
  Row 2 (right):  idle + 4 walk frames  (left = horizontal flip)
  Row 3 (gestures): jump(4f) wave(4f) bow(3f) dance(6f) clap(4f) = 21 frames
    -> gestures row is wider: 21*32 = 672px, but we keep the PNG at 672x192
    -> Actually, to simplify, row 3 uses 21 columns total. We make the sheet
       wide enough: max(5, 21) = 21 cols -> 672 x 192

Usage:
    pip install Pillow
    python3 generate_placeholders.py
"""
import os
import sys

try:
    from PIL import Image, ImageDraw
except ImportError:
    print("Error: Pillow not installed. Run: pip install Pillow")
    sys.exit(1)

FRAME_W = 32
FRAME_H = 48
WALK_COLS = 5        # idle + 4 walk
GESTURE_FRAMES = 21  # jump(4) + wave(4) + bow(3) + dance(6) + clap(4)
TOTAL_COLS = max(WALK_COLS, GESTURE_FRAMES)
ROWS = 4
SHEET_W = TOTAL_COLS * FRAME_W  # 672
SHEET_H = ROWS * FRAME_H        # 192

# Skin palette reference colors (body spritesheet uses these)
SKIN_PALETTES = ['#FFF0DB', '#FFDBAC', '#D4A574', '#A67C52']

# Output base path (relative to repo root)
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT = os.path.abspath(os.path.join(SCRIPT_DIR, '..', '..'))
OUTPUT_BASE = os.path.join(REPO_ROOT, 'mobile', 'lemon_korean', 'assets', 'sprites', 'character')


def hex_to_rgb(h):
    h = h.lstrip('#')
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))


def _draw_body_frame(draw, ox, oy, facing, walk_phase, skin_rgb):
    """Draw a simple body: oval head + rectangular torso + legs."""
    # Torso
    tx, ty = ox + 8, oy + 20
    tw, th = 16, 16
    draw.rectangle([tx, ty, tx + tw, ty + th], fill=skin_rgb)

    # Head (oval)
    hx, hy = ox + 8, oy + 4
    hw, hh = 16, 16
    draw.ellipse([hx, hy, hx + hw, hy + hh], fill=skin_rgb)

    # Legs
    leg_offset = 0
    if walk_phase > 0:
        leg_offset = (walk_phase % 2) * 2 - 1  # alternating -1/+1
    lx1 = ox + 10 + leg_offset
    lx2 = ox + 18 - leg_offset
    ly = oy + 36
    draw.rectangle([lx1, ly, lx1 + 4, ly + 10], fill=skin_rgb)
    draw.rectangle([lx2, ly, lx2 + 4, ly + 10], fill=skin_rgb)


def _draw_hair_frame(draw, ox, oy, facing, walk_phase, color):
    """Draw simple short hair on top of head area."""
    # Hair cap on top of head
    hx, hy = ox + 7, oy + 2
    draw.ellipse([hx, hy, hx + 18, hy + 12], fill=color)
    # Side tufts
    draw.rectangle([ox + 6, oy + 8, ox + 9, oy + 16], fill=color)
    draw.rectangle([ox + 23, oy + 8, ox + 26, oy + 16], fill=color)


def _draw_eyes_frame(draw, ox, oy, facing, walk_phase, color):
    """Draw round eyes."""
    if facing == 'back':
        return
    ey = oy + 12
    if facing == 'right':
        draw.ellipse([ox + 16, ey, ox + 19, ey + 3], fill=color)
        draw.ellipse([ox + 22, ey, ox + 25, ey + 3], fill=color)
    else:  # front
        draw.ellipse([ox + 11, ey, ox + 14, ey + 3], fill=color)
        draw.ellipse([ox + 18, ey, ox + 21, ey + 3], fill=color)


def _draw_eyebrows_frame(draw, ox, oy, facing, walk_phase, color):
    """Draw natural eyebrows."""
    if facing == 'back':
        return
    ey = oy + 10
    if facing == 'right':
        draw.line([ox + 15, ey, ox + 20, ey], fill=color, width=1)
        draw.line([ox + 22, ey, ox + 26, ey], fill=color, width=1)
    else:
        draw.line([ox + 10, ey, ox + 14, ey], fill=color, width=1)
        draw.line([ox + 18, ey, ox + 22, ey], fill=color, width=1)


def _draw_nose_frame(draw, ox, oy, facing, walk_phase, color):
    """Draw button nose (small dot)."""
    if facing == 'back':
        return
    ny = oy + 15
    if facing == 'right':
        nx = ox + 21
    else:
        nx = ox + 15
    draw.ellipse([nx, ny, nx + 2, ny + 2], fill=color)


def _draw_mouth_frame(draw, ox, oy, facing, walk_phase, color):
    """Draw smile mouth (curved line)."""
    if facing == 'back':
        return
    my = oy + 18
    if facing == 'right':
        draw.arc([ox + 17, my, ox + 24, my + 4], 0, 180, fill=color, width=1)
    else:
        draw.arc([ox + 12, my, ox + 20, my + 4], 0, 180, fill=color, width=1)


def _draw_top_frame(draw, ox, oy, facing, walk_phase, color):
    """Draw t-shirt over torso area."""
    tx, ty = ox + 7, oy + 20
    tw, th = 18, 17
    draw.rectangle([tx, ty, tx + tw, ty + th], fill=color)
    # Sleeves
    draw.rectangle([ox + 3, oy + 20, ox + 8, oy + 28], fill=color)
    draw.rectangle([ox + 24, oy + 20, ox + 29, oy + 28], fill=color)


# Registry of spritesheet generators
SPRITES = {
    'body/body_default': {
        'draw': _draw_body_frame,
        'color': hex_to_rgb(SKIN_PALETTES[1]),  # default palette ref
        'desc': 'Default body (oval head + rectangular torso)',
    },
    'hair/hair_short': {
        'draw': _draw_hair_frame,
        'color': (101, 67, 33),  # brown
        'desc': 'Short brown hair',
    },
    'eyes/eyes_round': {
        'draw': _draw_eyes_frame,
        'color': (20, 20, 20),  # near-black
        'desc': 'Round black eyes',
    },
    'eyebrows/eyebrows_natural': {
        'draw': _draw_eyebrows_frame,
        'color': (80, 50, 20),  # dark brown
        'desc': 'Natural eyebrows',
    },
    'nose/nose_button': {
        'draw': _draw_nose_frame,
        'color': (180, 130, 90),  # skin-ish
        'desc': 'Button nose',
    },
    'mouth/mouth_smile': {
        'draw': _draw_mouth_frame,
        'color': (200, 80, 80),  # reddish
        'desc': 'Smile mouth',
    },
    'top/top_tshirt': {
        'draw': _draw_top_frame,
        'color': (60, 120, 200),  # blue
        'desc': 'Blue t-shirt',
    },
}

FACINGS = ['front', 'back', 'right']  # Row 0, 1, 2


def generate_spritesheet(key, spec):
    """Generate a single spritesheet PNG."""
    img = Image.new('RGBA', (SHEET_W, SHEET_H), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    draw_fn = spec['draw']
    color = spec['color']

    # Rows 0-2: directional idle + walk
    for row_idx, facing in enumerate(FACINGS):
        for col in range(WALK_COLS):
            ox = col * FRAME_W
            oy = row_idx * FRAME_H
            walk_phase = col  # 0 = idle, 1-4 = walk
            draw_fn(draw, ox, oy, facing, walk_phase, color)

    # Row 3: gestures (all use front facing with variations)
    gesture_col = 0

    # Jump: 4 frames
    for i in range(4):
        ox = gesture_col * FRAME_W
        oy = 3 * FRAME_H
        # Jump: shift upward progressively then back down
        y_shift = -int(8 * (1 - abs(i - 1.5) / 1.5))
        draw_fn(draw, ox, oy + y_shift, 'front', i, color)
        gesture_col += 1

    # Wave: 4 frames
    for i in range(4):
        ox = gesture_col * FRAME_W
        oy = 3 * FRAME_H
        draw_fn(draw, ox, oy, 'front', i, color)
        gesture_col += 1

    # Bow: 3 frames
    for i in range(3):
        ox = gesture_col * FRAME_W
        oy = 3 * FRAME_H
        draw_fn(draw, ox, oy, 'front', 0, color)
        gesture_col += 1

    # Dance: 6 frames
    for i in range(6):
        ox = gesture_col * FRAME_W
        oy = 3 * FRAME_H
        draw_fn(draw, ox, oy, 'front', i % 4, color)
        gesture_col += 1

    # Clap: 4 frames
    for i in range(4):
        ox = gesture_col * FRAME_W
        oy = 3 * FRAME_H
        draw_fn(draw, ox, oy, 'front', i, color)
        gesture_col += 1

    # Save
    out_dir = os.path.join(OUTPUT_BASE, os.path.dirname(key))
    os.makedirs(out_dir, exist_ok=True)
    out_path = os.path.join(OUTPUT_BASE, f'{key}.png')
    img.save(out_path, 'PNG')
    return out_path


def main():
    print(f"Generating {len(SPRITES)} placeholder spritesheets...")
    print(f"Frame size: {FRAME_W}x{FRAME_H}, Sheet: {SHEET_W}x{SHEET_H}")
    print(f"Output: {OUTPUT_BASE}\n")

    for key, spec in SPRITES.items():
        path = generate_spritesheet(key, spec)
        print(f"  {spec['desc']:40s} -> {os.path.relpath(path, REPO_ROOT)}")

    print(f"\nDone! {len(SPRITES)} spritesheets generated.")


if __name__ == '__main__':
    main()
