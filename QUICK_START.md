# OtoKage - Quick Start Guide

Your anime/VGM music recognition app is now ready for deployment! 🎵

---

## What Was Changed

### ✅ Project Restructured for Render.com
- Backend converted from git submodule to regular folder
- Fixed deployment configuration in [render.yaml](render.yaml)
- Backend rebranded from "Tunespot" to "OtoKage"

### ✅ Authentication Added
- **Sign-In Screen**: Users must authenticate before using the app
  - Google Sign-In support
  - Email/Password login
- **Sign-Out**: Logout button in top-right of home screen
- **Auth Flow**: App checks authentication on startup via AuthGate

### ✅ Backend API Updates
- Service name: `otokage-backend`
- Health check endpoint: `/api/health`
- Root endpoint updated with OtoKage branding
- Currently deployed at: https://otokage-backend.onrender.com

---

## How to Deploy to Render.com

### Step 1: Prepare ACRCloud Credentials
1. Go to [ACRCloud Console](https://console.acrcloud.com/)
2. Get your credentials:
   - Access Key
   - Access Secret
   - Host (e.g., `identify-ap-southeast-1.acrcloud.com`)

### Step 2: Deploy on Render

1. **Go to Render Dashboard**: https://dashboard.render.com/
2. **Create New Web Service**:
   - Click "New +" → "Web Service"
   - Connect to GitHub: `ferhatfurkanafsin/OtoKage`
   - Branch: `main`

3. **Configure Service**:
   ```
   Name: otokage-backend
   Region: Choose closest to your users
   Root Directory: backend
   Runtime: Python 3
   Build Command: pip install -r requirements.txt
   Start Command: uvicorn main:app --host 0.0.0.0 --port $PORT
   Instance Type: Free
   ```

4. **Add Environment Variables**:
   - `PYTHON_VERSION` = `3.11.0`
   - `ACRCLOUD_ACCESS_KEY` = `<your_access_key>`
   - `ACRCLOUD_ACCESS_SECRET` = `<your_secret>`
   - `ACRCLOUD_HOST` = `identify-ap-southeast-1.acrcloud.com`

5. **Click "Create Web Service"**

### Step 3: Wait for Deployment
- Build takes ~2-5 minutes
- Status will change to "Live" when ready
- Your backend URL: `https://otokage-backend.onrender.com`

### Step 4: Test Deployment

```bash
# Test health endpoint
curl https://otokage-backend.onrender.com/api/health

# Expected response:
{
  "status": "healthy",
  "service": "otokage-backend",
  "version": "1.0.0",
  "api": "running"
}
```

---

## Current Project Structure

```
OtoKage/
├── frontend/                      # Flutter mobile app
│   ├── lib/
│   │   ├── main.dart             # App entry with AuthGate
│   │   ├── screens/
│   │   │   ├── sign_in_screen.dart    # Login/Signup
│   │   │   ├── home_screen.dart       # Main app (auth required)
│   │   │   └── result_screen.dart     # Song results
│   │   └── services/
│   │       ├── auth_service.dart      # Authentication
│   │       ├── api_service.dart       # Backend API calls
│   │       └── audio_service.dart     # Audio recording
│   └── pubspec.yaml
│
├── backend/                       # Python FastAPI backend
│   ├── app/
│   │   ├── api/
│   │   │   └── routes.py         # /api endpoints + /health
│   │   ├── services/
│   │   │   └── acrcloud_service.py    # Music recognition
│   │   └── config.py             # Environment config
│   ├── main.py                   # FastAPI app
│   ├── requirements.txt          # Python dependencies
│   ├── runtime.txt               # Python 3.11.0
│   └── render.yaml              # Backend config
│
├── render.yaml                   # Root deployment config (USE THIS)
├── DEPLOYMENT_GUIDE.md           # Detailed deployment walkthrough
└── QUICK_START.md               # This file
```

---

## App Features

### Authentication
- **Google Sign-In**: One-tap authentication
- **Email/Password**: Traditional login (currently local storage)
- **Auto Sign-In Check**: App remembers logged-in users
- **Sign Out**: Available in top-right of home screen

### Music Recognition
- **Record Audio**: Sing, hum, or play music
- **ACRCloud Recognition**: Identifies anime/VGM tracks
- **Song Details**: Title, artist, album, release date
- **Multi-Language**: English, Turkish, Japanese support

### UI/UX
- **Dark Theme**: Neon Cyan (#00E5FF) + Sakura Pink (#FF6B9D)
- **Language Switcher**: Top-right of home screen
- **Retro Aesthetic**: Scanline effects and anime-inspired design

---

## API Endpoints

**Base URL**: `https://otokage-backend.onrender.com/api`

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | API status check |
| GET | `/health` | Health check for monitoring |
| POST | `/recognize` | Music recognition (requires audio file) |
| POST | `/test` | Test ACRCloud credentials |

---

## Testing Your App

### 1. Test Backend Health
```bash
curl https://otokage-backend.onrender.com/api/health
```

### 2. Test ACRCloud Connection
```bash
curl -X POST https://otokage-backend.onrender.com/api/test
```

### 3. Run Flutter App
```bash
cd frontend
flutter run
```

**Expected Flow**:
1. App opens → Shows SignInScreen
2. User signs in (Google or Email)
3. Redirects to HomeScreen
4. User can record and recognize music
5. Sign out button available (top-right)

---

## Important Notes

### ⚠️ Free Tier Limitations
- Render free tier spins down after 15 minutes of inactivity
- First request after sleep takes ~30 seconds (cold start)
- Consider paid tier for production use

### ⚠️ Current Authentication
- Google Sign-In: Functional
- Email/Password: Uses local storage (NOT secure for production)
- **For Production**: Implement proper backend authentication with JWT tokens and database

### 🔐 Security Reminders
- Never commit `.env` files
- Keep ACRCloud credentials secret
- Use environment variables in Render
- Backend `.env` is in `.gitignore`

---

## Next Steps

### For Production Deployment:

1. **Add Real Authentication Backend**:
   - Implement user registration endpoint
   - Add JWT token authentication
   - Connect to PostgreSQL database
   - Secure password hashing

2. **Database Setup**:
   - Add PostgreSQL on Render (free tier available)
   - Store user accounts
   - Track music recognition history

3. **Testing**:
   - Test Google Sign-In on real device
   - Test music recognition with various audio samples
   - Test cold start behavior on Render

4. **App Store Preparation**:
   - Build production APK/IPA
   - Add privacy policy
   - Configure OAuth consent screen for Google Sign-In
   - Test on multiple devices

---

## Troubleshooting

### Backend not responding?
- Check Render deployment logs
- Verify environment variables are set
- Check if service is "Live" in Render dashboard
- Cold start? Wait 30 seconds for free tier wake-up

### Flutter app can't connect?
- Verify backend URL in [frontend/lib/services/api_service.dart](frontend/lib/services/api_service.dart#L5)
- Should be: `https://otokage-backend.onrender.com/api`
- Check network connection
- Try health check endpoint first

### Authentication not working?
- Google Sign-In requires proper OAuth setup
- Email/password accepts any non-empty credentials
- Check if auth service is initialized

---

## Resources

- **Render Docs**: https://render.com/docs
- **FastAPI Docs**: https://fastapi.tiangolo.com/
- **ACRCloud Docs**: https://docs.acrcloud.com/
- **Flutter Docs**: https://flutter.dev/docs
- **GitHub Repo**: https://github.com/ferhatfurkanafsin/OtoKage

---

## Support

For detailed deployment instructions, see [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)

**Your app is ready to deploy!** 🚀

Backend is configured at: https://otokage-backend.onrender.com
Just add your ACRCloud credentials on Render and you're live!
