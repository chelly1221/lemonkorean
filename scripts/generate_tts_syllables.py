#!/usr/bin/env python3
"""
Generate ALL Korean syllable audio (19 초성 × 21 중성 × 28 종성 = 11,172 combinations).
For the syllable combination screen - covers every possible Korean syllable.

Usage:
    python3 generate_tts_syllables.py <API_KEY> [--workers N]
"""

import json
import os
import sys
import base64
import time
import urllib.request
import urllib.error
from concurrent.futures import ThreadPoolExecutor, as_completed

API_KEY = ''
TTS_URL = ''
OUTPUT_DIR = os.path.join(os.path.dirname(__file__),
    '..', 'mobile', 'lemon_korean', 'assets', 'audio', 'ko')
VOICE_NAME = "ko-KR-Wavenet-A"
SPEAKING_RATE = 0.9

# 19 initial consonants (초성)
INITIALS = [
    'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ',
    'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'
]

# 21 medial vowels (중성)
MEDIALS = [
    'ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ',
    'ㅙ', 'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ', 'ㅣ'
]

# 28 final consonants (종성) - index 0 = no final
FINALS = [
    '', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ', 'ㄺ',
    'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ', 'ㅄ', 'ㅅ',
    'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'
]


def combine(initial_idx, medial_idx, final_idx=0):
    """Combine initial, medial, and final into a syllable."""
    code = 0xAC00 + (initial_idx * 588) + (medial_idx * 28) + final_idx
    return chr(code)


def get_all_syllables():
    """Generate all 11,172 Korean syllables (with and without final consonant)."""
    syllables = []
    for i in range(len(INITIALS)):
        for j in range(len(MEDIALS)):
            for k in range(len(FINALS)):
                syllables.append(combine(i, j, k))
    return syllables


def synthesize(text, retries=3):
    body = json.dumps({
        "input": {"text": text},
        "voice": {"languageCode": "ko-KR", "name": VOICE_NAME},
        "audioConfig": {
            "audioEncoding": "MP3",
            "speakingRate": SPEAKING_RATE,
            "pitch": 0,
            "sampleRateHertz": 24000,
        },
    }).encode('utf-8')

    for attempt in range(retries):
        req = urllib.request.Request(TTS_URL, data=body,
                                    headers={"Content-Type": "application/json"})
        try:
            with urllib.request.urlopen(req) as resp:
                result = json.loads(resp.read().decode('utf-8'))
                return base64.b64decode(result['audioContent'])
        except urllib.error.HTTPError as e:
            err = e.read().decode('utf-8')
            if e.code == 429 and attempt < retries - 1:
                wait = 2 ** (attempt + 1)
                time.sleep(wait)
                continue
            print(f"  ERROR '{text}': {e.code} {err[:200]}", flush=True)
            return None
        except Exception as e:
            if attempt < retries - 1:
                time.sleep(1)
                continue
            print(f"  ERROR '{text}': {e}", flush=True)
            return None
    return None


def process(text):
    filepath = os.path.join(OUTPUT_DIR, f"{text}.mp3")
    if os.path.exists(filepath) and os.path.getsize(filepath) > 0:
        return ('skip', text)
    audio = synthesize(text)
    if audio:
        with open(filepath, 'wb') as f:
            f.write(audio)
        return ('ok', text)
    return ('fail', text)


def main():
    global API_KEY, TTS_URL

    # Parse arguments
    workers = 50
    args = sys.argv[1:]
    i = 0
    while i < len(args):
        if args[i] == '--workers' and i + 1 < len(args):
            workers = int(args[i + 1])
            i += 2
        elif not API_KEY:
            API_KEY = args[i]
            i += 1
        else:
            i += 1

    if not API_KEY:
        print("Usage: python3 generate_tts_syllables.py <API_KEY> [--workers N]")
        sys.exit(1)

    TTS_URL = f"https://texttospeech.googleapis.com/v1/text:synthesize?key={API_KEY}"

    os.makedirs(OUTPUT_DIR, exist_ok=True)
    syllables = get_all_syllables()
    total = len(syllables)

    # Count existing
    existing = sum(1 for s in syllables
                   if os.path.exists(os.path.join(OUTPUT_DIR, f"{s}.mp3"))
                   and os.path.getsize(os.path.join(OUTPUT_DIR, f"{s}.mp3")) > 0)

    print(f"Total syllables: {total}", flush=True)
    print(f"Already exists: {existing}", flush=True)
    print(f"To generate: {total - existing}", flush=True)
    print(f"Workers: {workers}", flush=True)
    print(f"Voice: {VOICE_NAME}, Rate: {SPEAKING_RATE}", flush=True)
    print("", flush=True)

    success = failed = skipped = 0

    with ThreadPoolExecutor(max_workers=workers) as executor:
        futures = {executor.submit(process, t): t for t in syllables}
        for i, future in enumerate(as_completed(futures), 1):
            status, text = future.result()
            if status == 'ok':
                success += 1
            elif status == 'skip':
                skipped += 1
            else:
                failed += 1
            if i % 200 == 0 or i == total:
                print(f"  Progress: {i}/{total} (new={success} skip={skipped} fail={failed})", flush=True)

    print(f"\nDone! New={success} Skipped={skipped} Failed={failed}", flush=True)
    if failed > 0:
        print(f"WARNING: {failed} files failed. Re-run the script to retry.", flush=True)


if __name__ == '__main__':
    main()
