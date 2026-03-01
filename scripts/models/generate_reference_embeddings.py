#!/usr/bin/env python3
"""
Generate reference embeddings for pronunciation scoring.

For each practice character/word in the Hangul curriculum (Stage 0-11):
1. Generate TTS audio using edge-tts (ko-KR-SunHiNeural)
2. Run through trimmed wav2vec2 model to extract hidden state embeddings
3. Mean pool across time → L2 normalize → 1024-dim vector
4. Write output as a Dart const Map file

Prerequisites:
    pip install edge-tts onnxruntime numpy soundfile

Usage:
    python3 scripts/models/generate_reference_embeddings.py

    # Custom model path:
    python3 scripts/models/generate_reference_embeddings.py \
        --model mobile/lemon_korean/assets/models/gop/wav2vec2_korean_emb_q8.onnx
"""

import argparse
import asyncio
import math
import os
import struct
import sys
import tempfile

import edge_tts
import numpy as np
import onnxruntime as ort
import soundfile as sf

# All unique characters/words used in speech practice across Stage 0-11
PRACTICE_CHARS = [
    # Stage 1: Basic vowels
    "아", "가", "나", "어", "거", "너", "오", "고", "노",
    "우", "구", "누", "으", "그", "느", "이", "기", "니",
    "아이", "우유", "오이",
    # Stage 2: Y-vowels
    "야", "갸", "냐", "여", "겨", "녀", "요", "교", "뇨",
    "유", "규", "뉴",
    # Stage 3: ㅐ/ㅔ series
    "애", "개", "내", "에", "게", "네", "얘", "걔", "냬",
    "예", "계", "녜",
    # Stage 4: Basic consonants 1
    "다", "도", "두", "라", "로", "루", "마", "모", "무",
    "바", "보", "부", "사", "소", "수",
    "나무", "바다", "나비",
    # Stage 5: Basic consonants 2
    "자", "조", "주", "차", "초", "추", "카", "코", "쿠",
    "타", "토", "투", "파", "포", "푸", "하", "호", "후",
    # Stage 6: Combinations
    "와", "워", "과",
    # Stage 7: Tense/aspirated
    "까", "따", "빠", "싸", "짜",
    # Stage 8: Final consonants
    "간", "난", "단", "말", "갈", "물", "감", "밤", "숨",
    "방", "공", "종", "박", "각", "국", "밥", "집", "숲",
    "옷", "맛", "빛",
    # Stage 9: Final consonants expansion
    "닫", "곧", "묻", "낮", "잊", "젖", "꽃", "닻", "빚",
    "부엌", "밭", "앞", "좋", "놓", "않",
    # Stage 10: Complex finals
    "몫", "넋", "앉다", "많다", "읽다", "삶",
    "넓다", "핥다", "읊다", "싫다", "없다", "없어",
    # Stage 11: Words and phrases
    "바나나", "하마", "모자", "학교", "친구", "한국", "공부",
    "김치", "라면", "시장", "학생", "선생님",
    "안녕하세요", "감사합니다", "아니요",
]


async def generate_tts_audio(text: str, output_path: str, voice: str = "ko-KR-SunHiNeural") -> bool:
    """Generate TTS audio for a given text using edge-tts."""
    try:
        communicate = edge_tts.Communicate(text, voice)
        await communicate.save(output_path)
        return True
    except Exception as e:
        print(f"  TTS failed for '{text}': {e}")
        return False


def convert_mp3_to_wav16k(mp3_path: str, wav_path: str) -> bool:
    """Convert MP3 to 16kHz mono WAV using soundfile."""
    try:
        data, sr = sf.read(mp3_path)
        # Convert to mono if stereo
        if len(data.shape) > 1:
            data = data.mean(axis=1)
        # Resample to 16kHz if needed
        if sr != 16000:
            # Simple resampling via linear interpolation
            duration = len(data) / sr
            target_len = int(duration * 16000)
            indices = np.linspace(0, len(data) - 1, target_len)
            data = np.interp(indices, np.arange(len(data)), data)
        # Write as WAV
        sf.write(wav_path, data.astype(np.float32), 16000, subtype="FLOAT")
        return True
    except Exception as e:
        print(f"  Audio conversion failed: {e}")
        return False


def extract_embedding(session: ort.InferenceSession, wav_path: str) -> np.ndarray | None:
    """Extract mean-pooled L2-normalized embedding from a WAV file."""
    try:
        data, sr = sf.read(wav_path, dtype="float32")
        if len(data.shape) > 1:
            data = data.mean(axis=1)
        if sr != 16000:
            duration = len(data) / sr
            target_len = int(duration * 16000)
            indices = np.linspace(0, len(data) - 1, target_len)
            data = np.interp(indices, np.arange(len(data)), data).astype(np.float32)

        # Shape: [1, num_samples]
        input_data = data.reshape(1, -1)

        input_name = session.get_inputs()[0].name
        output_name = session.get_outputs()[0].name

        result = session.run([output_name], {input_name: input_data})
        hidden_states = result[0]  # [1, T, 1024]

        # Mean pool across time dimension
        embedding = hidden_states[0].mean(axis=0)  # [1024]

        # L2 normalize
        norm = np.linalg.norm(embedding)
        if norm > 1e-8:
            embedding = embedding / norm

        return embedding
    except Exception as e:
        print(f"  Embedding extraction failed: {e}")
        return None


def format_embedding_dart(embedding: np.ndarray, indent: str = "    ") -> str:
    """Format a 1024-dim embedding as a Dart list literal, 8 values per line."""
    values = embedding.tolist()
    lines = []
    for i in range(0, len(values), 8):
        chunk = values[i:i+8]
        formatted = ", ".join(f"{v:.6f}" for v in chunk)
        lines.append(f"{indent}  {formatted},")
    return f"[\n{chr(10).join(lines)}\n{indent}]"


def write_dart_file(embeddings: dict[str, np.ndarray], output_path: str) -> None:
    """Write embeddings as a Dart const Map file."""
    lines = [
        "// GENERATED FILE — DO NOT EDIT BY HAND",
        "// Generated by scripts/models/generate_reference_embeddings.py",
        "//",
        f"// Total: {len(embeddings)} reference embeddings (1024-dim each)",
        "// Voice: ko-KR-SunHiNeural (edge-tts)",
        "// Model: wav2vec2_korean_emb_q8.onnx (trimmed, hidden state output)",
        "",
        "/// Pre-computed reference embeddings for pronunciation scoring.",
        "///",
        "/// Each key is a Korean character/word used in speech practice.",
        "/// Each value is a 1024-dimensional L2-normalized embedding vector",
        "/// extracted from TTS audio through the wav2vec2 encoder.",
        "///",
        "/// At runtime, user audio is processed through the same encoder,",
        "/// and cosine similarity with these references determines the score.",
        "class ReferenceEmbeddings {",
        "  ReferenceEmbeddings._();",
        "",
        "  static const int embeddingDim = 1024;",
        "",
        "  /// Look up reference embedding for a character/word.",
        "  /// Returns null if no reference exists.",
        "  static List<double>? get(String text) => _embeddings[text];",
        "",
        "  /// Check if a reference embedding exists.",
        "  static bool has(String text) => _embeddings.containsKey(text);",
        "",
        "  /// All available reference texts.",
        "  static Iterable<String> get availableTexts => _embeddings.keys;",
        "",
        "  static const Map<String, List<double>> _embeddings = {",
    ]

    for text, emb in sorted(embeddings.items()):
        lines.append(f"    '{text}': {format_embedding_dart(emb)},")

    lines.extend([
        "  };",
        "}",
        "",
    ])

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))

    size_kb = os.path.getsize(output_path) / 1024
    print(f"\nDart file written: {output_path} ({size_kb:.0f} KB)")


async def main():
    parser = argparse.ArgumentParser(
        description="Generate reference embeddings for pronunciation scoring"
    )
    parser.add_argument(
        "--model",
        default="mobile/lemon_korean/assets/models/gop/wav2vec2_korean_emb_q8.onnx",
        help="Trimmed ONNX model path",
    )
    parser.add_argument(
        "--output",
        default="mobile/lemon_korean/lib/core/data/reference_embeddings.dart",
        help="Output Dart file path",
    )
    parser.add_argument(
        "--voice",
        default="ko-KR-SunHiNeural",
        help="Edge-TTS voice name",
    )
    args = parser.parse_args()

    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.abspath(os.path.join(script_dir, "..", ".."))

    model_path = (
        args.model if os.path.isabs(args.model)
        else os.path.join(project_root, args.model)
    )
    output_path = (
        args.output if os.path.isabs(args.output)
        else os.path.join(project_root, args.output)
    )

    if not os.path.exists(model_path):
        print(f"ERROR: Model not found: {model_path}")
        sys.exit(1)

    # Deduplicate
    chars = list(dict.fromkeys(PRACTICE_CHARS))
    print(f"Characters to process: {len(chars)}")
    print(f"Model: {model_path}")
    print(f"Voice: {args.voice}")
    print()

    # Load ONNX model
    print("Loading ONNX model...")
    session = ort.InferenceSession(
        model_path,
        providers=["CPUExecutionProvider"],
    )
    print(f"  Input: {session.get_inputs()[0].name}, Output: {session.get_outputs()[0].name}")
    print()

    embeddings: dict[str, np.ndarray] = {}
    failed: list[str] = []

    with tempfile.TemporaryDirectory() as tmpdir:
        for i, text in enumerate(chars):
            print(f"[{i+1}/{len(chars)}] '{text}'...", end=" ", flush=True)

            mp3_path = os.path.join(tmpdir, f"{i}.mp3")
            wav_path = os.path.join(tmpdir, f"{i}.wav")

            # Step 1: TTS
            ok = await generate_tts_audio(text, mp3_path, args.voice)
            if not ok:
                failed.append(text)
                print("FAILED (TTS)")
                continue

            # Step 2: Convert to WAV 16kHz
            ok = convert_mp3_to_wav16k(mp3_path, wav_path)
            if not ok:
                failed.append(text)
                print("FAILED (convert)")
                continue

            # Step 3: Extract embedding
            emb = extract_embedding(session, wav_path)
            if emb is None:
                failed.append(text)
                print("FAILED (embedding)")
                continue

            embeddings[text] = emb
            print(f"OK (norm={np.linalg.norm(emb):.4f})")

            # Cleanup temp files
            try:
                os.remove(mp3_path)
                os.remove(wav_path)
            except OSError:
                pass

    print(f"\nResults: {len(embeddings)}/{len(chars)} succeeded")
    if failed:
        print(f"Failed: {failed}")

    if not embeddings:
        print("ERROR: No embeddings generated!")
        sys.exit(1)

    # Write Dart file
    write_dart_file(embeddings, output_path)
    print("Done.")


if __name__ == "__main__":
    asyncio.run(main())
