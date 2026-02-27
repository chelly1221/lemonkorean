#!/bin/bash
# Speech Recognition Model Preparation Script
# Run this ONCE on the server to prepare models for on-premise deployment.
# Models are then served via the media server (MinIO) to mobile clients.

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/output"
mkdir -p "$OUTPUT_DIR/whisper" "$OUTPUT_DIR/gop"

echo "=== Step 1: Download Whisper base model ==="
# Download from HuggingFace (server-side only, never from app)
curl -L "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin" \
  -o "$OUTPUT_DIR/whisper/ggml-base.bin"
echo "Whisper model downloaded: $(du -h $OUTPUT_DIR/whisper/ggml-base.bin | cut -f1)"

echo "=== Step 2: Convert wav2vec2 to ONNX ==="
# Requires Python with transformers and onnxruntime
pip install transformers torch onnx onnxruntime 2>/dev/null || true

python3 - << 'PYTHON_SCRIPT'
import os, sys
output_dir = os.environ.get('OUTPUT_DIR', './output')

try:
    from transformers import Wav2Vec2ForCTC
    import torch

    print("Loading wav2vec2-large-xlsr-korean...")
    model = Wav2Vec2ForCTC.from_pretrained("kresnik/wav2vec2-large-xlsr-korean")
    model.eval()

    dummy_input = torch.randn(1, 16000)  # 1 second of audio

    onnx_path = os.path.join(output_dir, "gop", "wav2vec2_korean.onnx")
    print(f"Exporting ONNX to {onnx_path}...")
    torch.onnx.export(
        model, dummy_input, onnx_path,
        input_names=["input_values"],
        output_names=["logits"],
        dynamic_axes={
            "input_values": {1: "audio_length"},
            "logits": {1: "time_steps"},
        },
        opset_version=14,
    )
    print(f"ONNX export done: {os.path.getsize(onnx_path) / 1024 / 1024:.0f} MB")

    # Quantize to int8
    from onnxruntime.quantization import quantize_dynamic, QuantType
    q8_path = os.path.join(output_dir, "gop", "wav2vec2_korean_q8.onnx")
    print(f"Quantizing to int8 at {q8_path}...")
    quantize_dynamic(onnx_path, q8_path, weight_type=QuantType.QInt8)
    print(f"Quantized model: {os.path.getsize(q8_path) / 1024 / 1024:.0f} MB")

    # Clean up full-size model
    os.remove(onnx_path)
    print("Cleanup done.")

except ImportError as e:
    print(f"ERROR: Missing dependency: {e}")
    print("Install: pip install transformers torch onnx onnxruntime")
    sys.exit(1)
except Exception as e:
    print(f"ERROR: {e}")
    sys.exit(1)
PYTHON_SCRIPT

echo ""
echo "=== Step 3: Upload to media server ==="
echo "Models ready in: $OUTPUT_DIR/"
echo ""
echo "Upload to MinIO media server:"
echo "  mc cp $OUTPUT_DIR/whisper/ggml-base.bin minio/media/models/whisper/"
echo "  mc cp $OUTPUT_DIR/gop/wav2vec2_korean_q8.onnx minio/media/models/gop/"
echo ""
echo "Or copy to media service volume:"
echo "  docker cp $OUTPUT_DIR/whisper/ggml-base.bin media-service:/data/models/whisper/"
echo "  docker cp $OUTPUT_DIR/gop/wav2vec2_korean_q8.onnx media-service:/data/models/gop/"
echo ""
echo "Verify accessible at:"
echo "  curl -I https://your-server/media/models/whisper/ggml-base.bin"
echo "  curl -I https://your-server/media/models/gop/wav2vec2_korean_q8.onnx"
echo ""
ls -lh "$OUTPUT_DIR/whisper/" "$OUTPUT_DIR/gop/" 2>/dev/null
echo "Done!"
