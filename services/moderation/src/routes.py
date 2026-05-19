import asyncio
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, Field
from typing import Dict

router = APIRouter(prefix="/api/moderation")

# Will be set by main.py on startup
moderator = None


class TextRequest(BaseModel):
    text: str = Field(..., min_length=1, max_length=5000)
    context: str = Field("post", pattern="^(post|comment|bio|dm)$")


class ModerationResponse(BaseModel):
    safe: bool
    action: str
    max_score: float
    categories: Dict[str, float]
    context: str
    processing_time_ms: float


@router.post("/text", response_model=ModerationResponse)
async def moderate_text(request: TextRequest):
    if moderator is None or moderator.session is None:
        raise HTTPException(status_code=503, detail="Model not loaded")

    # Offload CPU-bound ONNX inference to thread pool
    result = await asyncio.to_thread(moderator.moderate, request.text, request.context)
    return result


@router.get("/health")
async def moderation_health():
    loaded = moderator is not None and moderator.session is not None
    return {
        "status": "ok",
        "models_loaded": loaded,
        "optimization": moderator.get_info() if loaded else None,
    }
