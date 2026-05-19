# ==============================================================
# Stage 1: Export HuggingFace model to ONNX + INT8 quantization
# This stage includes PyTorch (CPU-only) for model conversion.
# ==============================================================
FROM python:3.11-slim AS model-exporter

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc g++ \
    && rm -rf /var/lib/apt/lists/*

# Install export dependencies (includes torch CPU-only)
COPY requirements-export.txt .
RUN pip install --no-cache-dir -r requirements-export.txt \
    && pip install --no-cache-dir torch --index-url https://download.pytorch.org/whl/cpu

# Export model to ONNX + INT8 quantization
COPY scripts/export_model.py .
ARG MODEL_NAME=unitary/multilingual-toxic-xlm-roberta
ENV MODEL_NAME=${MODEL_NAME}
ENV MODEL_PATH=/app/models/text-toxicity
RUN python export_model.py

# ==============================================================
# Stage 2: Lightweight AVX2-optimized runtime (no PyTorch)
# ==============================================================
FROM python:3.11-slim

WORKDIR /app

# Install runtime dependencies only
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy exported ONNX models (FP32 + INT8 quantized) from build stage
COPY --from=model-exporter /app/models /app/models

# Copy application source
COPY src/ /app/src/

WORKDIR /app/src

EXPOSE 3008

CMD ["python", "main.py"]
