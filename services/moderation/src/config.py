import os

# Server
PORT = int(os.getenv("MODERATION_PORT", "3008"))

# Model
MODEL_NAME = os.getenv("MODEL_NAME", "unitary/multilingual-toxic-xlm-roberta")
MODEL_PATH = os.getenv("MODEL_PATH", "/app/models/text-toxicity")

# Thresholds (max toxicity score)
REJECT_THRESHOLD = float(os.getenv("TEXT_REJECT_THRESHOLD", "0.7"))
FLAG_THRESHOLD = float(os.getenv("TEXT_FLAG_THRESHOLD", "0.3"))

# CPU optimization
# 0 = auto-detect (ONNX Runtime uses all available cores)
# Controls parallelism within each operator (GEMM, convolution, etc.)
INTRA_OP_THREADS = int(os.getenv("INTRA_OP_THREADS", "0"))

# INT8 quantization: uses AVX-VNNI for faster integer GEMM
USE_QUANTIZED = os.getenv("USE_QUANTIZED", "true").lower() == "true"

# Toxicity labels from Jigsaw Multilingual dataset
LABELS = ["toxic", "severe_toxic", "obscene", "threat", "insult", "identity_hate"]
