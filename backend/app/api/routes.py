from fastapi import APIRouter, UploadFile, File, HTTPException
from fastapi.responses import JSONResponse
from app.services.acrcloud_service import acrcloud_service
from typing import Dict, List
from pydantic import BaseModel
import json
import os
from pathlib import Path

router = APIRouter()

@router.get("/")
async def root():
    return {"status": "ok", "message": "OtoKage Music Recognition API is running", "version": "1.0.0"}

@router.get("/health")
async def health_check():
    """Health check endpoint for monitoring services"""
    return {
        "status": "healthy",
        "service": "otokage-backend",
        "version": "1.0.0",
        "api": "running"
    }

@router.post("/recognize")
async def recognize_music(audio: UploadFile = File(...)) -> Dict:
    try:
        allowed_types = ["audio/mpeg", "audio/wav", "audio/x-wav", "audio/mp4", "audio/x-m4a", "audio/ogg"]
        if audio.content_type not in allowed_types:
            raise HTTPException(status_code=400, detail=f"Invalid file type. Allowed types: {', '.join(allowed_types)}")
        
        audio_data = await audio.read()
        max_size = 10 * 1024 * 1024
        if len(audio_data) > max_size:
            raise HTTPException(status_code=400, detail="File too large. Maximum size is 10MB")
        
        raw_response = acrcloud_service.recognize_audio(audio_data)
        parsed_result = acrcloud_service.parse_response(raw_response)
        
        if parsed_result is None:
            return JSONResponse(
                status_code=404,
                content={
                    "success": False,
                    "message": "No matching song found. Try humming/singing more clearly or for a longer duration.",
                    "raw_status": raw_response.get("status", {})
                }
            )
        
        return {"success": True, "message": "Song recognized successfully!", "song": parsed_result}
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}")

@router.post("/test")
async def test_recognition():
    try:
        test_response = acrcloud_service.recognize_audio(b"")
        if test_response.get("status", {}).get("code") == 1001:
            return {"success": True, "message": "ACRCloud credentials are valid and working!"}
        return {"success": False, "message": "ACRCloud credentials might be invalid", "response": test_response}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Test failed: {str(e)}")

# History models
class SearchHistoryItem(BaseModel):
    songTitle: str
    artist: str
    album: str
    searchedAt: str
    spotifyUrl: str | None = None
    youtubeUrl: str | None = None
    score: int
    durationMs: int

# History storage path
HISTORY_DIR = Path("data/history")
HISTORY_DIR.mkdir(parents=True, exist_ok=True)

def get_history_file(email: str) -> Path:
    """Get the history file path for a user"""
    # Use email hash as filename for privacy
    safe_email = email.replace("@", "_at_").replace(".", "_")
    return HISTORY_DIR / f"{safe_email}.json"

@router.post("/history")
async def save_history(email: str, history: SearchHistoryItem):
    """Save a search history item for a user"""
    try:
        history_file = get_history_file(email)

        # Read existing history
        existing_history = []
        if history_file.exists():
            with open(history_file, 'r') as f:
                existing_history = json.load(f)

        # Add new item at the beginning
        existing_history.insert(0, history.model_dump())

        # Keep only last 100 items
        existing_history = existing_history[:100]

        # Save back to file
        with open(history_file, 'w') as f:
            json.dump(existing_history, f, indent=2)

        return {"success": True, "message": "History saved successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to save history: {str(e)}")

@router.get("/history/{email}")
async def get_history(email: str) -> List[Dict]:
    """Get search history for a user"""
    try:
        history_file = get_history_file(email)

        if not history_file.exists():
            return []

        with open(history_file, 'r') as f:
            return json.load(f)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to retrieve history: {str(e)}")

@router.delete("/history/{email}")
async def clear_history(email: str):
    """Clear all search history for a user"""
    try:
        history_file = get_history_file(email)

        if history_file.exists():
            history_file.unlink()

        return {"success": True, "message": "History cleared successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to clear history: {str(e)}")

@router.delete("/account/{email}")
async def delete_account(email: str):
    """Delete user account and all associated data"""
    try:
        history_file = get_history_file(email)

        # Delete history file if exists
        if history_file.exists():
            history_file.unlink()

        # In future: delete other user data (auth tokens, preferences, etc.)
        # For now, only history is stored in backend

        return {
            "success": True,
            "message": "Account and all associated data deleted successfully"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to delete account: {str(e)}")