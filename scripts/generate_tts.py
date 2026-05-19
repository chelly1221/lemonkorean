#!/usr/bin/env python3
"""
Google Cloud TTS Audio Generator for Lemon Korean App.
Generates MP3 pronunciation files for all Korean text in the curriculum.
"""

import json
import os
import sys
import base64
import urllib.request
import urllib.error
from concurrent.futures import ThreadPoolExecutor, as_completed

API_KEY = sys.argv[1] if len(sys.argv) > 1 else os.environ.get('GOOGLE_TTS_API_KEY', '')
TTS_URL = f"https://texttospeech.googleapis.com/v1/text:synthesize?key={API_KEY}"
OUTPUT_DIR = os.path.join(os.path.dirname(__file__),
    '..', 'mobile', 'lemon_korean', 'assets', 'audio', 'ko')
VOICE_NAME = "ko-KR-Wavenet-A"
SPEAKING_RATE = 0.9

# ─── Individual Hangul Jamo ───
CONSONANTS = [
    'ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅅ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ',
    'ㄲ', 'ㄸ', 'ㅃ', 'ㅆ', 'ㅉ',
]
VOWELS = [
    'ㅏ', 'ㅑ', 'ㅓ', 'ㅕ', 'ㅗ', 'ㅛ', 'ㅜ', 'ㅠ', 'ㅡ', 'ㅣ',
    'ㅐ', 'ㅒ', 'ㅔ', 'ㅖ', 'ㅘ', 'ㅙ', 'ㅚ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅢ',
]

# ─── Syllables from all stages ───
STAGE_0 = ['가', '나', '다', '고', '노']
STAGE_1 = [
    '아', '가', '나', '어', '거', '너', '오', '고', '노', '우', '구', '누',
    '으', '그', '느', '이', '기', '니',
    '아이', '우유', '오이', '아우', '이유', '우이',
]
STAGE_2 = ['야', '갸', '냐', '여', '겨', '녀', '요', '교', '뇨', '유', '규', '뉴']
STAGE_3 = ['애', '개', '내', '에', '게', '네', '얘', '걔', '냬', '예', '계', '녜']
STAGE_4 = [
    '가', '고', '구', '나', '노', '누', '다', '도', '두',
    '라', '로', '루', '마', '모', '무', '바', '보', '부', '사', '소', '수',
    '나무', '바다', '나비', '모자', '가구', '두부',
]
STAGE_5 = [
    '아', '오', '우', '자', '조', '주', '차', '초', '추',
    '카', '코', '쿠', '타', '토', '투', '파', '포', '푸', '하', '호', '후',
]
STAGE_6 = [
    '가', '거', '고', '구', '그', '기', '나', '너', '노', '누', '느', '니',
    '다', '라', '로', '루', '두', '디', '리', '미', '머', '모',
    '바', '서', '저', '더', '호', '주', '수', '부',
    '와', '워', '과', '권', '웨', '왜', '외', '위', '의', '긔', '귀',
    '화', '휘', '비', '뵈', '뷔', '줘', '쥐',
]
STAGE_7 = [
    '가', '카', '까', '다', '타', '따', '바', '파', '빠',
    '사', '싸', '자', '차', '짜',
]
STAGE_8 = [
    '간', '난', '단', '말', '갈', '물', '만', '맛',
    '감', '밤', '숨', '갓',
    '방', '공', '종', '반', '곰',
    '박', '각', '국', '군', '굴',
    '밥', '집', '숲', '짐', '질',
    '옷', '빛', '온', '옹', '빈', '빔',
    '문', '묵', '곱', '곤', '발', '린', '진',
]
STAGE_9 = [
    '닫', '곧', '묻', '단', '달', '낮', '잊', '젖', '전', '절',
    '꽃', '꼰', '꼴', '닻', '빚', '부엌', '밭', '앞', '암', '안',
    '좋', '놓', '않', '존', '졸', '논', '놀', '붙', '분', '불',
]
STAGE_10 = [
    '몫', '넋', '목', '몬', '넌', '널',
    '앉다', '많다', '안다', '않다', '맑다', '읽다',
    '삶', '삼', '살',
    '넓다', '핥다', '읊다', '싫다', '없다', '없어',
]
STAGE_11 = [
    '바나나', '나비', '하마', '모자',
    '학교', '친구', '한국', '공부', '읽기',
    '김치', '라면', '시장', '학생', '선생님',
    '아메리카노', '카페라떼', '녹차', '케이크',
    '서울역', '강남', '홍대입구', '명동',
    '안녕하세요', '감사합니다', '네', '아니요',
    '하교', '학구', '한구', '친국', '공부해', '콩부', '학고',
    '모차', '모사', '하누', '하국', '마다',
]
BATCHIM_EXAMPLES = [
    '악', '학', '밖', '껍', '산', '굳', '받', '같',
    '있', '했', '낳', '길', '봄', '잎', '강',
]
# Double final consonant clusters (겹받침) for syllable combination screen
DOUBLE_FINALS = [
    'ㄳ', 'ㄵ', 'ㄶ', 'ㄺ', 'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅄ',
]
VOCABULARY = ['안녕하세요', '감사합니다', '학생']

# Extra syllables that appear in quiz choices across stages
EXTRA = [
    '허', '헤', '히', '후', '흐', '희',
    '시', '지', '치', '키', '티', '피',
    '새', '세', '셰', '쉐',
    '봐', '뭐', '궈', '쉬', '쉐',
    '빠', '까', '따', '싸', '짜',
    '업다', '엇다', '익기', '일기',
    '만다', '말다', '일다', '익다',
    '업어', '엇어',
]


# ─── All possible Korean syllables (초성 × 중성 × 종성) ───
def generate_all_syllables():
    """Generate all 11,172 Korean syllable characters.

    Korean syllable Unicode block: U+AC00 ~ U+D7A3
    Formula: code = 0xAC00 + (initial * 588) + (medial * 28) + final
      - 19 initials  (초성, indices 0-18)
      - 21 medials   (중성, indices 0-20)
      - 28 finals    (종성, indices 0-27, where 0 = no final consonant)
    Total: 19 × 21 × 28 = 11,172 syllables
    """
    syllables = []
    for initial in range(19):
        for medial in range(21):
            for final in range(28):
                code = 0xAC00 + (initial * 588) + (medial * 28) + final
                syllables.append(chr(code))
    return syllables


ALL_SYLLABLES = generate_all_syllables()


def get_all_texts():
    all_texts = set()
    for lst in [CONSONANTS, VOWELS, STAGE_0, STAGE_1, STAGE_2, STAGE_3,
                STAGE_4, STAGE_5, STAGE_6, STAGE_7, STAGE_8, STAGE_9,
                STAGE_10, STAGE_11, BATCHIM_EXAMPLES, DOUBLE_FINALS,
                VOCABULARY, EXTRA, ALL_SYLLABLES]:
        all_texts.update(lst)
    return sorted(all_texts)


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
                import time
                time.sleep(2 ** attempt + 1)
                continue
            print(f"  ERROR '{text}': {e.code} {err[:200]}", flush=True)
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
    if not API_KEY:
        print("Usage: python3 generate_tts.py <API_KEY>")
        sys.exit(1)

    os.makedirs(OUTPUT_DIR, exist_ok=True)
    texts = get_all_texts()
    total = len(texts)
    print(f"Generating {total} audio files...", flush=True)
    print(f"Voice: {VOICE_NAME}, Rate: {SPEAKING_RATE}", flush=True)
    print(f"Output: {os.path.abspath(OUTPUT_DIR)}/", flush=True)
    print(flush=True)

    success = failed = skipped = 0

    with ThreadPoolExecutor(max_workers=15) as executor:
        futures = {executor.submit(process, t): t for t in texts}
        for i, future in enumerate(as_completed(futures), 1):
            status, text = future.result()
            if status == 'ok':
                success += 1
                print(f"  [{i}/{total}] OK {text}", flush=True)
            elif status == 'skip':
                skipped += 1
                print(f"  [{i}/{total}] -- {text} (exists)", flush=True)
            else:
                failed += 1
                print(f"  [{i}/{total}] FAIL {text}", flush=True)

    print(flush=True)
    print(f"Done! Success={success} Skipped={skipped} Failed={failed}", flush=True)
    print(f"Total files: {success + skipped}", flush=True)


if __name__ == '__main__':
    main()
