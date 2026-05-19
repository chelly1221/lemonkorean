from fastapi import FastAPI
from contextlib import asynccontextmanager

from text_moderator import TextModerator
from config import PORT
import routes


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Load model on startup."""
    moderator = TextModerator()
    moderator.load()
    routes.moderator = moderator
    print(f"[Moderation] Service ready on port {PORT}")
    yield


app = FastAPI(
    title="Lemon Korean Moderation Service",
    description="NPU-accelerated content moderation via ONNX Runtime",
    lifespan=lifespan,
)

app.include_router(routes.router)


@app.get("/health")
async def root_health():
    return {"status": "ok", "service": "moderation"}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=PORT)
