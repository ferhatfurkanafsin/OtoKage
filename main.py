import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.routes import router
from app.config import settings
import uvicorn

settings.validate()

app = FastAPI(
    title="Tunespot API",
    description="API for recognizing Video Game & Anime music from humming/singing",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins for now
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(router, prefix="/api", tags=["recognition"])

@app.on_event("startup")
async def startup_event():
    print("=" * 50)
    print("�� Tunespot API Starting...")
    print("=" * 50)
    print(f"✓ ACRCloud Host: {settings.ACRCLOUD_HOST}")
    print("=" * 50)

@app.on_event("shutdown")
async def shutdown_event():
    print("Shutting down Tunespot API...")

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run("main:app", host="0.0.0.0", port=port, reload=False)
