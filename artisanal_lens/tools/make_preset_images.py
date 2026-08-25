"""Build preset reference thumbnails for The Artisanal Lens.

Two jobs:

1. Salvage the four saree photographs from the Figma image fills. Two of the
   uploaded assets are UI screenshots with the real photograph embedded inside
   them, so those get cropped down to just the photograph.

2. Draw reference cards for the twelve cushion cover / shawl / stole presets.
   Figma has no artwork for these, and cropping the category photograph would
   be actively misleading -- a "folded stack" card showing a draped shawl tells
   the artisan the wrong thing. A clean diagram of the arrangement is honest
   and legible at thumbnail size.
"""

from PIL import Image, ImageDraw, ImageFilter
import os

_HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.normpath(os.path.join(_HERE, os.pardir, "assets", "images", "presets"))
SRC = os.path.join(_HERE, "figma_src")

SIZE = 192          # final thumbnail size
SS = 4              # supersample factor
S = SIZE * SS       # working canvas

# Figma palette
SURFACE = (245, 236, 231)
BORDER = (221, 192, 186)
PRIMARY = (146, 51, 29)
TERRA = (178, 74, 50)
TERRA_HI = (201, 106, 82)
BODY = (87, 66, 61)
SAGE = (89, 98, 69)
LINEN = (232, 222, 212)
FORM = (208, 194, 186)        # mannequin / body form
FORM_EDGE = (184, 166, 157)
SEAT = (215, 202, 191)


# --------------------------------------------------------------- saree crops ---
def salvage_saree():
    """Crop the four saree photographs out of their Figma source assets."""
    # (file, crop box in source pixels or None for a centre crop)
    jobs = {
        "saree_pallu_drape": None,
        "saree_box_fold": None,
        "saree_hanger": (109, 17, 243, 173),      # photo inside a screenshot
        "saree_worn_drape": (74, 14, 282, 155),   # photo inside a screenshot
    }
    for name, box in jobs.items():
        im = Image.open(os.path.join(SRC, name + ".png")).convert("RGB")
        if box:
            im = im.crop(box)
        # centre square
        w, h = im.size
        side = min(w, h)
        im = im.crop(((w - side) // 2, (h - side) // 2,
                      (w - side) // 2 + side, (h - side) // 2 + side))
        im = im.resize((384, 384), Image.LANCZOS)
        im = im.filter(ImageFilter.UnsharpMask(radius=1.4, percent=90, threshold=3))
        im.save(os.path.join(OUT, name + ".png"))
        print(f"  saree  {name}")


# ------------------------------------------------------------------ drawing ---
def canvas():
    im = Image.new("RGB", (S, S), SURFACE)
    return im, ImageDraw.Draw(im, "RGBA")


def finish(im, name):
    im = im.resize((SIZE, SIZE), Image.LANCZOS)
    im.save(os.path.join(OUT, name + ".png"))
    print(f"  drawn  {name}")


def shadow(d, box, blur_col=(0, 0, 0, 26), off=10 * SS // 4):
    x0, y0, x1, y1 = box
    d.rounded_rectangle([x0 + off, y0 + off, x1 + off, y1 + off],
                        radius=6 * SS, fill=blur_col)


def fringe(d, x0, x1, y, count, length, col, width=2 * SS, vertical=True):
    step = (x1 - x0) / (count - 1) if count > 1 else 0
    for i in range(count):
        x = x0 + step * i
        if vertical:
            d.line([x, y, x, y + length], fill=col, width=width)
        else:
            d.line([y, x, y + length, x], fill=col, width=width)


def weave(d, box, col, gap=9 * SS, width=SS, horizontal=True):
    """Faint weave lines to read as woven cloth rather than flat colour."""
    x0, y0, x1, y1 = box
    if horizontal:
        y = y0 + gap
        while y < y1:
            d.line([x0, y, x1, y], fill=col, width=width)
            y += gap
    else:
        x = x0 + gap
        while x < x1:
            d.line([x, y0, x, y1], fill=col, width=width)
            x += gap


def torso(d, cx, top, scale=1.0):
    """Neutral shoulder/neck form, used as the body for worn presets.

    Deliberately darker than the surface -- an earlier pass used a near-linen
    tone that vanished into the background and left the cloth floating.
    """
    # fractions of the canvas -- an earlier pass scaled these by SS/4, which
    # left the form 150px wide on a 768px canvas and invisible at thumbnail size
    w = int(S * 0.74 * scale)
    neck_w = int(S * 0.19 * scale)
    neck_h = int(S * 0.15 * scale)
    body_top = top + neck_h - 4 * SS
    pts = [(cx - w // 2, S), (cx - w // 2 + 9 * SS, body_top + 11 * SS),
           (cx - neck_w // 2 - 5 * SS, body_top),
           (cx + neck_w // 2 + 5 * SS, body_top),
           (cx + w // 2 - 9 * SS, body_top + 11 * SS), (cx + w // 2, S)]
    d.polygon(pts, fill=FORM, outline=FORM_EDGE, width=SS)
    d.rounded_rectangle([cx - neck_w // 2, top, cx + neck_w // 2, top + neck_h],
                        radius=8 * SS // 2, fill=FORM, outline=FORM_EDGE, width=SS)
    d.ellipse([cx - neck_w // 2 - 3 * SS, top - 8 * SS,
               cx + neck_w // 2 + 3 * SS, top + 11 * SS],
              fill=FORM, outline=FORM_EDGE, width=SS)
    return body_top


def folded_corner(d, tip, a, b, base_col, fold_col):
    """A corner of cloth lifted and folded back, with a readable crease."""
    d.polygon([tip, a, b], fill=fold_col)
    d.line([a, b], fill=(255, 255, 255, 150), width=3 * SS)
    d.line([tip, a], fill=(0, 0, 0, 40), width=SS)


# ------------------------------------------------------------ cushion cover ---
def cushion_flat_lay():
    im, d = canvas()
    m = 44 * SS // 2
    box = (m, m, S - m, S - m)
    shadow(d, box)
    d.rounded_rectangle(box, radius=8 * SS, fill=TERRA)
    weave(d, box, (255, 255, 255, 26))
    # seam inset
    d.rounded_rectangle([box[0] + 9 * SS, box[1] + 9 * SS,
                         box[2] - 9 * SS, box[3] - 9 * SS],
                        radius=5 * SS, outline=(255, 255, 255, 60), width=SS)
    # corner tassels
    for cx, cy in [(box[0], box[1]), (box[2], box[1]),
                   (box[0], box[3]), (box[2], box[3])]:
        d.ellipse([cx - 4 * SS, cy - 4 * SS, cx + 4 * SS, cy + 4 * SS], fill=PRIMARY)
    finish(im, "cushion_flat_lay")


def cushion_stacked_pair():
    im, d = canvas()
    back = (30 * SS // 2, 26 * SS // 2, S - 62 * SS // 2, S - 66 * SS // 2)
    front = (56 * SS // 2, 58 * SS // 2, S - 30 * SS // 2, S - 30 * SS // 2)
    shadow(d, back)
    d.rounded_rectangle(back, radius=8 * SS, fill=TERRA_HI)
    weave(d, back, (255, 255, 255, 24))
    shadow(d, front)
    d.rounded_rectangle(front, radius=8 * SS, fill=TERRA)
    weave(d, front, (255, 255, 255, 26))
    d.rounded_rectangle([front[0] + 9 * SS, front[1] + 9 * SS,
                         front[2] - 9 * SS, front[3] - 9 * SS],
                        radius=5 * SS, outline=(255, 255, 255, 60), width=SS)
    finish(im, "cushion_stacked_pair")


def cushion_propped():
    im, d = canvas()
    # seat it is leaning against
    seat_y = S - 52 * SS // 2
    d.rectangle([0, seat_y, S, S], fill=SEAT)
    d.line([0, seat_y, S, seat_y], fill=FORM_EDGE, width=2 * SS)
    d.rectangle([0, 0, S, seat_y], fill=SURFACE)
    # rotated cushion drawn on its own layer
    pad = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    pd = ImageDraw.Draw(pad, "RGBA")
    m = 52 * SS // 2
    box = (m, m, S - m, S - m)
    pd.rounded_rectangle(box, radius=9 * SS, fill=TERRA + (255,))
    weave(pd, box, (255, 255, 255, 18), gap=16 * SS)
    pd.rounded_rectangle([box[0] + 10 * SS, box[1] + 10 * SS,
                          box[2] - 10 * SS, box[3] - 10 * SS],
                         radius=5 * SS, outline=(255, 255, 255, 70), width=SS)
    pad = pad.rotate(-13, resample=Image.BICUBIC, center=(S // 2, S // 2))
    pad = pad.transform(pad.size, Image.AFFINE, (1, 0, 0, 0, 1, -16 * SS // 2),
                        resample=Image.BICUBIC)
    im.paste(pad, (0, 0), pad)
    finish(im, "cushion_propped")


def cushion_corner_tuck():
    im, d = canvas()
    # cloth fills the frame; its corner is lifted and folded back so the
    # reverse face and the stitched seam both read at thumbnail size
    d.polygon([(0, 0), (S, 0), (S, S * 0.55), (S * 0.52, S), (0, S)], fill=TERRA)
    weave(d, (0, 0, S, S), (255, 255, 255, 24), gap=14 * SS)
    folded_corner(d, (S, S), (S * 0.52, S), (S, S * 0.55), TERRA, TERRA_HI)
    weave(d, (int(S * 0.52), int(S * 0.55), S, S),
          (255, 255, 255, 30), gap=12 * SS, horizontal=False)
    # stitched seam running along the crease
    for t in range(24):
        p = t / 23
        x = S * 0.52 + (S - S * 0.52) * p
        y = S - (S - S * 0.55) * p
        d.ellipse([x - 1.6 * SS, y - 1.6 * SS, x + 1.6 * SS, y + 1.6 * SS],
                  fill=(255, 255, 255, 200))
    finish(im, "cushion_corner_tuck")


# -------------------------------------------------------------------- shawl ---
def shawl_draped_shoulder():
    im, d = canvas()
    cx = S // 2
    body_top = torso(d, cx, 26 * SS // 2)
    left = int(cx - S * 0.30)
    right = int(cx + S * 0.17)
    # cloth over the near shoulder, falling across the body
    d.polygon([(left, body_top - 2 * SS), (right, body_top + 6 * SS),
               (right + 5 * SS, S), (left - 2 * SS, S)], fill=TERRA)
    # lit edge along the shoulder line
    d.polygon([(left, body_top - 2 * SS), (left + int(S * 0.10), body_top + 2 * SS),
               (left + int(S * 0.08), S), (left - 2 * SS, S)], fill=TERRA_HI)
    weave(d, (left - 2 * SS, body_top, right + 5 * SS, S),
          (255, 255, 255, 24), gap=13 * SS)
    d.line([(left, body_top - 2 * SS), (right, body_top + 6 * SS)],
           fill=(255, 255, 255, 90), width=2 * SS)
    fringe(d, left + 2 * SS, right + 3 * SS, S - 11 * SS, 8, 11 * SS, PRIMARY)
    finish(im, "shawl_draped_shoulder")


def shawl_folded_stack():
    im, d = canvas()
    cols = [TERRA_HI, TERRA, PRIMARY, TERRA]
    n = 4
    h = 26 * SS // 2
    gap = 6 * SS // 2
    total = n * h + (n - 1) * gap
    y = (S - total) // 2
    for i in range(n):
        inset = 12 * SS // 2 * abs(i - (n - 1) / 2) / ((n - 1) / 2)
        box = (30 * SS // 2 + inset, y, S - 30 * SS // 2 - inset, y + h)
        shadow(d, box, off=4 * SS // 2)
        d.rounded_rectangle(box, radius=4 * SS, fill=cols[i % len(cols)])
        # visible folded edge along the front
        d.line([box[0] + 3 * SS, box[3] - 3 * SS, box[2] - 3 * SS, box[3] - 3 * SS],
               fill=(255, 255, 255, 70), width=SS)
        y += h + gap
    finish(im, "shawl_folded_stack")


def shawl_hung_flat():
    im, d = canvas()
    rod_y = 34 * SS // 2
    d.line([14 * SS // 2, rod_y, S - 14 * SS // 2, rod_y], fill=BODY, width=3 * SS)
    d.ellipse([10 * SS // 2, rod_y - 4 * SS, 20 * SS // 2, rod_y + 4 * SS], fill=BODY)
    d.ellipse([S - 20 * SS // 2, rod_y - 4 * SS, S - 10 * SS // 2, rod_y + 4 * SS],
              fill=BODY)
    box = (44 * SS // 2, rod_y, S - 44 * SS // 2, S - 34 * SS // 2)
    shadow(d, box, off=5 * SS // 2)
    d.rectangle(box, fill=TERRA)
    weave(d, box, (255, 255, 255, 26))
    # border bands top and bottom
    d.rectangle([box[0], box[1] + 8 * SS, box[2], box[1] + 13 * SS], fill=PRIMARY)
    d.rectangle([box[0], box[3] - 13 * SS, box[2], box[3] - 8 * SS], fill=PRIMARY)
    fringe(d, box[0] + 3 * SS, box[2] - 3 * SS, box[3], 11, 11 * SS, PRIMARY)
    finish(im, "shawl_hung_flat")


def shawl_corner_tuck():
    im, d = canvas()
    d.rectangle([0, 0, S, S], fill=TERRA)
    weave(d, (0, 0, S, S), (255, 255, 255, 24), gap=14 * SS)
    # corner turned back to expose the reverse face and the fringed edge
    folded_corner(d, (S, S), (S * 0.26, S), (S, S * 0.22), TERRA, TERRA_HI)
    weave(d, (int(S * 0.26), int(S * 0.22), S, S),
          (255, 255, 255, 30), gap=12 * SS, horizontal=False)
    # fringe running along the exposed edge
    for t in range(9):
        p = t / 8
        x = S * 0.30 + (S * 0.66) * p
        y = S - 4 * SS - (S * 0.60) * p
        d.line([x, y, x + 9 * SS, y + 9 * SS], fill=PRIMARY, width=2 * SS)
    finish(im, "shawl_corner_tuck")


# -------------------------------------------------------------------- stole ---
def stole_neck_wrap():
    im, d = canvas()
    cx = S // 2
    body_top = torso(d, cx, 34 * SS // 2)
    tw = int(S * 0.13)          # tail width
    gap = int(S * 0.02)
    # tails first, so the neck loop overlaps them
    d.polygon([(cx - gap - tw, body_top + 4 * SS), (cx - gap, body_top + 6 * SS),
               (cx - gap, S), (cx - gap - tw - 3 * SS, S)], fill=TERRA)
    d.polygon([(cx + gap, body_top + 6 * SS), (cx + gap + tw, body_top + 4 * SS),
               (cx + gap + tw + 3 * SS, S), (cx + gap, S)], fill=TERRA_HI)
    fringe(d, cx - gap - tw, cx - gap, S - 11 * SS, 4, 11 * SS, PRIMARY)
    fringe(d, cx + gap, cx + gap + tw, S - 11 * SS, 4, 11 * SS, PRIMARY)
    # loop around the neck
    lr = int(S * 0.20)
    d.ellipse([cx - lr, body_top - int(S * 0.13), cx + lr, body_top + int(S * 0.09)],
              outline=TERRA, width=int(S * 0.055))
    d.arc([cx - lr, body_top - int(S * 0.13), cx + lr, body_top + int(S * 0.09)],
          200, 340, fill=(255, 255, 255, 70), width=2 * SS)
    finish(im, "stole_neck_wrap")


def stole_flat_spread():
    im, d = canvas()
    box = (18 * SS // 2, 72 * SS // 2, S - 18 * SS // 2, S - 72 * SS // 2)
    shadow(d, box, off=5 * SS // 2)
    d.rectangle(box, fill=TERRA)
    weave(d, box, (255, 255, 255, 26))
    d.rectangle([box[0], box[1] + 6 * SS, box[2], box[1] + 10 * SS], fill=PRIMARY)
    d.rectangle([box[0], box[3] - 10 * SS, box[2], box[3] - 6 * SS], fill=PRIMARY)
    # fringe at both ends, drawn horizontally
    fringe(d, box[1] + 2 * SS, box[3] - 2 * SS, box[0] - 11 * SS, 7, 11 * SS,
           PRIMARY, vertical=False)
    fringe(d, box[1] + 2 * SS, box[3] - 2 * SS, box[2], 7, 11 * SS,
           PRIMARY, vertical=False)
    finish(im, "stole_flat_spread")


def stole_loose_knot():
    im, d = canvas()
    cx, cy = S // 2, S // 2 - 8 * SS
    # the two tails first, so the knot sits over them
    d.polygon([(cx - 16 * SS, cy + 6 * SS), (cx - 2 * SS, cy + 8 * SS),
               (cx - 6 * SS, S - 6 * SS), (cx - 24 * SS, S - 6 * SS)], fill=TERRA_HI)
    d.polygon([(cx + 2 * SS, cy + 8 * SS), (cx + 16 * SS, cy + 6 * SS),
               (cx + 24 * SS, S - 6 * SS), (cx + 6 * SS, S - 6 * SS)], fill=TERRA)
    fringe(d, cx - 22 * SS, cx - 8 * SS, S - 10 * SS, 4, 9 * SS, PRIMARY)
    fringe(d, cx + 8 * SS, cx + 22 * SS, S - 10 * SS, 4, 9 * SS, PRIMARY)
    # loop and knot
    d.ellipse([cx - 30 * SS, cy - 30 * SS, cx + 30 * SS, cy + 14 * SS],
              outline=TERRA, width=10 * SS)
    d.rounded_rectangle([cx - 15 * SS, cy - 6 * SS, cx + 15 * SS, cy + 14 * SS],
                        radius=7 * SS, fill=PRIMARY)
    d.line([cx - 10 * SS, cy + 2 * SS, cx + 10 * SS, cy + 6 * SS],
           fill=(255, 255, 255, 70), width=SS)
    finish(im, "stole_loose_knot")


def stole_rolled_coil():
    im, d = canvas()
    # a bolt of cloth lying on its side: cylinder body with a spiral end face,
    # rather than a flat set of rings (which read as a target, not fabric)
    cy = S // 2
    left, right = 30 * SS, S - 46 * SS
    ry = 40 * SS
    rx = 15 * SS
    # loose end unrolling to the right
    d.polygon([(right - 2 * SS, cy - 26 * SS), (S - 6 * SS, cy - 6 * SS),
               (S - 6 * SS, cy + 16 * SS), (right - 2 * SS, cy + 4 * SS)],
              fill=TERRA_HI)
    fringe(d, cy - 4 * SS, cy + 14 * SS, S - 6 * SS, 4, 8 * SS, PRIMARY,
           vertical=False)
    # cylinder body
    d.rectangle([left, cy - ry, right, cy + ry], fill=TERRA)
    weave(d, (left, cy - ry, right, cy + ry), (255, 255, 255, 22),
          gap=14 * SS, horizontal=False)
    d.ellipse([left - rx, cy - ry, left + rx, cy + ry], fill=TERRA_HI)
    # spiral on the visible end face
    r = ry - 5 * SS
    i = 0
    while r > 4 * SS:
        d.arc([left - rx * r / ry, cy - r, left + rx * r / ry, cy + r],
              0, 360, fill=PRIMARY if i % 2 else TERRA, width=3 * SS)
        r -= 8 * SS
        i += 1
    d.line([right, cy - ry, right, cy + ry], fill=(0, 0, 0, 30), width=2 * SS)
    finish(im, "stole_rolled_coil")


if __name__ == "__main__":
    os.makedirs(OUT, exist_ok=True)
    print("saree photographs:")
    salvage_saree()
    print("generated reference cards:")
    for fn in (cushion_flat_lay, cushion_stacked_pair, cushion_propped,
               cushion_corner_tuck,
               shawl_draped_shoulder, shawl_folded_stack, shawl_hung_flat,
               shawl_corner_tuck,
               stole_neck_wrap, stole_flat_spread, stole_loose_knot,
               stole_rolled_coil):
        fn()
    print("done")
