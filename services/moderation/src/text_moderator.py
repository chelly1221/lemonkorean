import os
import re
import time
import threading
import unicodedata
import numpy as np
import onnxruntime as ort
from transformers import AutoTokenizer
from config import (
    MODEL_PATH, LABELS, REJECT_THRESHOLD, FLAG_THRESHOLD,
    INTRA_OP_THREADS, USE_QUANTIZED,
)


class TextModerator:
    def __init__(self):
        self.session = None
        self.tokenizer = None
        self._lock = threading.Lock()
        self._num_labels = len(LABELS)
        self._model_info = {}

    def load(self):
        """Load ONNX model with AVX2/AVX-VNNI optimized CPU session."""
        model_file = self._find_model_file()

        # Session options for AVX2 CPU optimization
        sess_options = ort.SessionOptions()
        sess_options.graph_optimization_level = ort.GraphOptimizationLevel.ORT_ENABLE_ALL
        sess_options.execution_mode = ort.ExecutionMode.ORT_SEQUENTIAL

        if INTRA_OP_THREADS > 0:
            sess_options.intra_op_num_threads = INTRA_OP_THREADS

        self.session = ort.InferenceSession(
            model_file,
            sess_options=sess_options,
            providers=["CPUExecutionProvider"],
        )
        self.tokenizer = AutoTokenizer.from_pretrained(MODEL_PATH)

        # Verify model output dimension
        output_shape = self.session.get_outputs()[0].shape
        if len(output_shape) == 2 and output_shape[1] is not None:
            if output_shape[1] != self._num_labels:
                print(f"[Moderation] WARNING: Model outputs {output_shape[1]} labels, expected {self._num_labels}")
                self._num_labels = output_shape[1]

        # Detect CPU features
        model_basename = os.path.basename(model_file)
        self._model_info = {
            "model_file": model_basename,
            "quantized": "quantized" in model_basename,
            "graph_optimization": "ORT_ENABLE_ALL",
            "intra_threads": sess_options.intra_op_num_threads,
        }

        # Warmup inference (triggers JIT optimization for AVX2 paths)
        for _ in range(3):
            self._predict("warmup")

        print(f"[Moderation] Model loaded: {model_file}")
        print(f"[Moderation] Quantized: {self._model_info['quantized']}")
        print(f"[Moderation] Threads: intra={self._model_info['intra_threads']}")

    def get_info(self):
        """Return model and optimization info."""
        return self._model_info

    def _find_model_file(self):
        """Find the best ONNX model file (prefer quantized if enabled)."""
        onnx_files = [f for f in os.listdir(MODEL_PATH) if f.endswith(".onnx")]
        if not onnx_files:
            raise FileNotFoundError(f"No ONNX model found in {MODEL_PATH}")

        if USE_QUANTIZED:
            quantized = [f for f in onnx_files if "quantized" in f]
            if quantized:
                return os.path.join(MODEL_PATH, quantized[0])
            print(f"[Moderation] WARNING: USE_QUANTIZED=true but no quantized model found, falling back to FP32")

        # Fall back to non-quantized model
        non_quantized = [f for f in onnx_files if "quantized" not in f]
        return os.path.join(MODEL_PATH, non_quantized[0] if non_quantized else onnx_files[0])

    @staticmethod
    def _normalize_text(text):
        """Normalize unicode and strip zero-width characters."""
        text = unicodedata.normalize("NFC", text)
        text = re.sub(r"[\u200b-\u200f\u2028-\u202f\u2060\ufeff]", "", text)
        return text.strip()

    def _predict(self, text):
        """Run ONNX inference on text, returns sigmoid scores. Thread-safe."""
        inputs = self.tokenizer(
            text,
            return_tensors="np",
            padding=True,
            truncation=True,
            max_length=512,
        )

        input_names = [inp.name for inp in self.session.get_inputs()]
        feed = {}
        if "input_ids" in input_names:
            feed["input_ids"] = inputs["input_ids"].astype(np.int64)
        if "attention_mask" in input_names:
            feed["attention_mask"] = inputs["attention_mask"].astype(np.int64)
        if "token_type_ids" in input_names:
            if "token_type_ids" in inputs:
                feed["token_type_ids"] = inputs["token_type_ids"].astype(np.int64)
            else:
                feed["token_type_ids"] = np.zeros_like(inputs["input_ids"], dtype=np.int64)

        with self._lock:
            outputs = self.session.run(None, feed)

        logits = outputs[0]

        # Ensure 2D shape (batch, num_labels)
        if logits.ndim == 1:
            logits = logits.reshape(1, -1)

        # Sigmoid activation for multi-label classification
        scores = 1.0 / (1.0 + np.exp(-logits))
        return scores[0]

    def moderate(self, text, context="post"):
        """
        Moderate text content.

        Returns dict with:
          - safe: bool
          - action: "allow" | "flag" | "reject"
          - max_score: float (highest toxicity score)
          - categories: dict of label -> score
          - context: str
          - processing_time_ms: float
        """
        start = time.time()

        normalized = self._normalize_text(text)

        # Whitespace-only or empty after normalization
        if not normalized:
            elapsed_ms = (time.time() - start) * 1000
            return {
                "safe": True,
                "action": "allow",
                "max_score": 0.0,
                "categories": {label: 0.0 for label in LABELS},
                "context": context or "post",
                "processing_time_ms": round(elapsed_ms, 1),
            }

        scores = self._predict(normalized)

        # Build categories dict, handling model output size vs LABELS mismatch
        categories = {}
        for i, score in enumerate(scores):
            label = LABELS[i] if i < len(LABELS) else f"label_{i}"
            categories[label] = round(float(score), 4)

        max_score = float(np.max(scores))

        if max_score >= REJECT_THRESHOLD:
            action = "reject"
            safe = False
        elif max_score >= FLAG_THRESHOLD:
            action = "flag"
            safe = False
        else:
            action = "allow"
            safe = True

        elapsed_ms = (time.time() - start) * 1000

        return {
            "safe": safe,
            "action": action,
            "max_score": round(max_score, 4),
            "categories": categories,
            "context": context or "post",
            "processing_time_ms": round(elapsed_ms, 1),
        }
