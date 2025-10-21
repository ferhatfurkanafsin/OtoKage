# OtoKage Deployment Guide

Complete guide for deploying OtoKage backend to Render.com

---

## Table of Contents
1. [Project Structure](#project-structure)
2. [Prerequisites](#prerequisites)
3. [Render.com Deployment](#rendercom-deployment)
4. [Environment Variables](#environment-variables)
5. [Testing Deployment](#testing-deployment)
6. [Troubleshooting](#troubleshooting)

---

## Project Structure

```
Otokage/
├── frontend/                   # Flutter mobile app
│   ├── lib/
│   │   └── services/
│   │       └── api_service.dart  # Points to: https://otokage-backend.onrender.com
│   └── pubspec.yaml
├── backend/                    # Python FastAPI backend
│   ├── app/
│   │   ├── api/
│   │   │   └── routes.py       # API endpoints
│   │   ├── services/
│   │   │   └── acrcloud_service.py
│   │   └── config.py           # Environment configuration
│   ├── main.py                 # FastAPI app entry point
│   ├── requirements.txt        # Python dependencies
│   ├── runtime.txt             # Python version (3.11.0)
│   └── render.yaml            # Render service config
├── render.yaml                 # Root Render config (used for deployment)
└── DEPLOYMENT_GUIDE.md        # This file
```

---

## Prerequisites

### 1. ACRCloud Account
- Sign up at [ACRCloud Console](https://console.acrcloud.com/)
- Create a new project with **Audio & Video Recognition**
- Note down:
  - Access Key
  - Access Secret
  - Host (e.g., `identify-ap-southeast-1.acrcloud.com`)

### 2. Render.com Account
- Sign up at [Render.com](https://render.com)
- Free tier is sufficient for testing

### 3. GitHub Repository
- Your code is at: https://github.com/ferhatfurkanafsin/OtoKage
- Ensure all changes are committed and pushed

---

## Render.com Deployment

### Step 1: Connect GitHub Repository

1. Log in to [Render Dashboard](https://dashboard.render.com/)
2. Click **"New +"** → **"Web Service"**
3. Connect your GitHub account (if not already connected)
4. Select repository: **ferhatfurkanafsin/OtoKage**
5. Click **"Connect"**

### Step 2: Configure Web Service

Use these exact settings:

| Setting | Value |
|---------|-------|
| **Name** | `otokage-backend` |
| **Region** | Choose closest to your users (e.g., Singapore, Oregon) |
| **Branch** | `main` |
| **Root Directory** | `backend` |
| **Runtime** | `Python 3` |
| **Build Command** | `pip install -r requirements.txt` |
| **Start Command** | `uvicorn main:app --host 0.0.0.0 --port $PORT` |
| **Instance Type** | `Free` |

### Step 3: Add Environment Variables

Click **"Advanced"** → **"Add Environment Variable"** and add these:

| Key | Value | Notes |
|-----|-------|-------|
| `PYTHON_VERSION` | `3.11.0` | Python runtime version |
| `ACRCLOUD_ACCESS_KEY` | `your_access_key` | From ACRCloud Console |
| `ACRCLOUD_ACCESS_SECRET` | `your_access_secret` | From ACRCloud Console |
| `ACRCLOUD_HOST` | `identify-ap-southeast-1.acrcloud.com` | Your ACRCloud host |

⚠️ **IMPORTANT**: Keep `ACRCLOUD_ACCESS_SECRET` confidential!

### Step 4: Deploy

1. Click **"Create Web Service"**
2. Render will automatically:
   - Clone your repository
   - Install dependencies from `requirements.txt`
   - Start the FastAPI server with Uvicorn
3. Monitor deployment logs in real-time
4. Wait for status to show **"Live"** (usually 2-5 minutes)

### Step 5: Get Your Backend URL

Once deployed, you'll see:
```
Your service is live at https://otokage-backend.onrender.com
```

This is your backend API URL! ✅

---

## Environment Variables

### Required Variables

```bash
# ACRCloud Configuration (REQUIRED)
ACRCLOUD_ACCESS_KEY=your_access_key_here
ACRCLOUD_ACCESS_SECRET=your_access_secret_here
ACRCLOUD_HOST=identify-ap-southeast-1.acrcloud.com

# Python Version (REQUIRED for Render)
PYTHON_VERSION=3.11.0
```

### Optional Variables

```bash
# API Configuration (defaults shown)
API_HOST=0.0.0.0
API_PORT=8000

# Database (if using PostgreSQL in future)
DATABASE_URL=postgresql://localhost/vgm_music_db
```

---

## Testing Deployment

### 1. Test API Health

```bash
curl https://otokage-backend.onrender.com/api/health
```

Expected response:
```json
{
  "status": "healthy",
  "service": "otokage-backend",
  "version": "1.0.0",
  "api": "running"
}
```

### 2. Test Root Endpoint

```bash
curl https://otokage-backend.onrender.com/api/
```

Expected response:
```json
{
  "status": "ok",
  "message": "OtoKage Music Recognition API is running",
  "version": "1.0.0"
}
```

### 3. Test ACRCloud Connection

```bash
curl -X POST https://otokage-backend.onrender.com/api/test
```

Expected response (if credentials are valid):
```json
{
  "success": true,
  "message": "ACRCloud credentials are valid and working!"
}
```

### 4. Test from Flutter App

Your Flutter app ([api_service.dart:5](frontend/lib/services/api_service.dart#L5)) is already configured:
```dart
static const String baseUrl = 'https://otokage-backend.onrender.com/api';
```

Just rebuild and run your app!

---

## API Endpoints

### Base URL
```
https://otokage-backend.onrender.com/api
```

### Available Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Root endpoint - API status |
| GET | `/health` | Health check for monitoring |
| POST | `/recognize` | Music recognition from audio file |
| POST | `/test` | Test ACRCloud credentials |

### Example: Recognize Music

```bash
curl -X POST https://otokage-backend.onrender.com/api/recognize \
  -F "audio=@recording.m4a"
```

Response (success):
```json
{
  "success": true,
  "message": "Song recognized successfully!",
  "song": {
    "title": "Gurenge",
    "artist": "LiSA",
    "album": "Demon Slayer OST",
    "release_date": "2019-07-03",
    "duration_ms": 239000,
    "score": 95
  }
}
```

Response (no match):
```json
{
  "success": false,
  "message": "No matching song found. Try humming/singing more clearly or for a longer duration."
}
```

---

## Troubleshooting

### Issue 1: Build Failed

**Symptom**: Deployment fails during build phase

**Solutions**:
1. Check `requirements.txt` has all dependencies
2. Verify Python version in environment variables: `PYTHON_VERSION=3.11.0`
3. Check Render logs for specific error messages
4. Ensure `rootDir: backend` is set correctly

### Issue 2: Application Failed to Start

**Symptom**: Build succeeds but app crashes on startup

**Solutions**:
1. Check environment variables are set correctly
2. Verify ACRCloud credentials are valid
3. Check logs for `ACRCLOUD_ACCESS_KEY is not set` error
4. Ensure start command is: `uvicorn main:app --host 0.0.0.0 --port $PORT`

### Issue 3: ACRCloud Connection Failed

**Symptom**: `/test` endpoint returns failure

**Solutions**:
1. Verify ACRCloud credentials in Render environment variables
2. Check ACRCloud host matches your region
3. Ensure ACRCloud project has **Audio & Video Recognition** enabled
4. Test credentials locally first

### Issue 4: CORS Errors from Flutter App

**Symptom**: Flutter app can't connect to backend

**Solutions**:
1. Backend already has CORS enabled for all origins ([main.py:16-22](backend/main.py#L16-L22))
2. Verify Flutter app uses correct URL: `https://otokage-backend.onrender.com/api`
3. Check network connectivity
4. Test API endpoints directly with curl first

### Issue 5: Free Tier Sleeps After 15 Minutes

**Symptom**: First request takes 30+ seconds

**Solution**:
- Free tier services spin down after 15 minutes of inactivity
- First request wakes the service (cold start)
- Consider upgrading to paid tier for always-on service
- Or implement a keep-alive ping service

---

## Deployment Checklist

- [ ] ACRCloud account created with credentials ready
- [ ] GitHub repository pushed with latest changes
- [ ] Render account created
- [ ] Web service created on Render
- [ ] Environment variables configured
- [ ] Deployment successful (status: Live)
- [ ] Health check endpoint returns "healthy"
- [ ] Root endpoint returns API running message
- [ ] ACRCloud test endpoint returns success
- [ ] Flutter app connects successfully
- [ ] Music recognition works from app

---

## Updating the Deployment

### For Code Changes:

1. Make changes locally
2. Commit and push to GitHub:
   ```bash
   git add .
   git commit -m "your message"
   git push origin main
   ```
3. Render automatically detects changes and redeploys

### For Environment Variable Changes:

1. Go to Render Dashboard
2. Select your service: **otokage-backend**
3. Navigate to **Environment** tab
4. Update variables
5. Click **Save Changes**
6. Service will restart automatically

---

## Support and Resources

- **Render Documentation**: https://render.com/docs
- **FastAPI Documentation**: https://fastapi.tiangolo.com/
- **ACRCloud API Docs**: https://docs.acrcloud.com/
- **GitHub Repository**: https://github.com/ferhatfurkanafsin/OtoKage

---

## Quick Reference Commands

```bash
# Test health endpoint
curl https://otokage-backend.onrender.com/api/health

# Test API status
curl https://otokage-backend.onrender.com/api/

# Test ACRCloud credentials
curl -X POST https://otokage-backend.onrender.com/api/test

# Test music recognition
curl -X POST https://otokage-backend.onrender.com/api/recognize \
  -F "audio=@your_audio_file.m4a"

# Check Render deployment logs
# Visit: https://dashboard.render.com → Select service → Logs tab
```

---

**Last Updated**: 2025-10-21
**Version**: 1.0.0
**Backend URL**: https://otokage-backend.onrender.com
