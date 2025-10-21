from fastapi import APIRouter, UploadFile, File, HTTPException
from fastapi.responses import JSONResponse
from app.services.acrcloud_service import acrcloud_service
from typing import Dict

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