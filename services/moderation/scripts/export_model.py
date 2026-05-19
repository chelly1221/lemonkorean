"""
Export HuggingFace model to ONNX format + INT8 dynamic quantization.
Used during Docker build (stage 1) only - not needed at runtime.

INT8 quantization leverages AVX2/AVX-VNNI instructions for faster inference.
"""
import os
import sys


def export():
    model_name = os.getenv("MODEL_NAME", "unitary/multilingual-toxic-xlm-roberta")
    output_dir = os.getenv("MODEL_PATH", "/app/models/text-toxicity")

    print(f"[Export] Model: {model_name}")
    print(f"[Export] Output: {output_dir}")

    from optimum.onnxruntime import ORTModelForSequenceClassification
    from transformers import AutoTokenizer

    # Step 1: Export to ONNX (FP32)
    print("[Export] Downloading and converting to ONNX (FP32)...")
    model = ORTModelForSequenceClassification.from_pretrained(
        model_name, export=True
    )
    tokenizer = AutoTokenizer.from_pretrained(model_name)

    os.makedirs(output_dir, exist_ok=True)
    model.save_pretrained(output_dir)
    tokenizer.save_pretrained(output_dir)

    # Find the exported ONNX file (optimum produces "model.onnx" for encoder-only models)
    fp32_name = "model.onnx"
    fp32_model = os.path.join(output_dir, fp32_name)
    if not os.path.exists(fp32_model):
        # Fallback: find any .onnx file
        onnx_files = sorted(f for f in os.listdir(output_dir) if f.endswith(".onnx"))
        if not onnx_files:
            print("[Export] ERROR: No ONNX files found after export!")
            sys.exit(1)
        fp32_name = onnx_files[0]
        fp32_model = os.path.join(output_dir, fp32_name)

    fp32_size = os.path.getsize(fp32_model) / 1024 / 1024
    print(f"[Export] FP32 model: {fp32_name} ({fp32_size:.1f} MB)")

    # Step 2: INT8 Dynamic Quantization (for AVX2/AVX-VNNI acceleration)
    # QInt8 (signed) is correct for transformer weights which are centered around zero
    print("[Export] Applying INT8 dynamic quantization...")
    try:
        from onnxruntime.quantization import quantize_dynamic, QuantType

        quantized_model = os.path.join(output_dir, "model_quantized.onnx")
        quantize_dynamic(
            model_input=fp32_model,
            model_output=quantized_model,
            weight_type=QuantType.QInt8,
        )

        int8_size = os.path.getsize(quantized_model) / 1024 / 1024
        ratio = fp32_size / int8_size if int8_size > 0 else 0
        print(f"[Export] INT8 model: model_quantized.onnx ({int8_size:.1f} MB, {ratio:.1f}x smaller)")
    except Exception as e:
        print(f"[Export] WARNING: Quantization failed: {e}")
        print("[Export] Continuing with FP32 model only")

    # Summary
    all_files = os.listdir(output_dir)
    total_size = sum(os.path.getsize(os.path.join(output_dir, f)) for f in all_files)
    print(f"[Export] Done! Total: {total_size / 1024 / 1024:.1f} MB, Files: {all_files}")


if __name__ == "__main__":
    export()
