# OtoKage Project Structure

**Last Updated:** 2025-10-21
**Version:** 1.0.0

---

## Project Overview

OtoKage is an anime/VGM music recognition app with authentication, built with Flutter (frontend) and FastAPI (backend).

---

## Directory Structure

```
OtoKage/
├── .git/                          # Main git repository
├── .gitignore                     # Root gitignore
├── render.yaml                    # Render.com deployment config (MAIN FILE)
│
├── frontend/                      # Flutter mobile app
│   ├── android/                  # Android platform files
│   ├── ios/                      # iOS platform files
│   ├── lib/
│   │   ├── main.dart            # App entry point with AuthGate
│   │   ├── l10n/                # Localization (EN/TR/JP)
│   │   ├── models/
│   │   │   └── song_model.dart  # Song data model
│   │   ├── screens/
│   │   │   ├── sign_in_screen.dart    # Login/Register screen
│   │   │   ├── home_screen.dart       # Main app (requires auth)
│   │   │   ├── recording_screen.dart  # Recording UI
│   │   │   └── result_screen.dart     # Recognition results
│   │   ├── services/
│   │   │   ├── auth_service.dart      # Google/Email authentication
│   │   │   ├── api_service.dart       # Backend API calls
│   │   │   ├── audio_service.dart     # Audio recording
│   │   │   └── language_service.dart  # Multi-language support
│   │   └── widgets/
│   │       ├── song_card.dart         # Song display card
│   │       └── record_button.dart     # Recording button
│   ├── assets/
│   │   └── otokage_icon.png     # App icon
│   ├── pubspec.yaml             # Flutter dependencies
│   └── README.md
│
├── backend/                       # Python FastAPI backend
│   ├── app/
│   │   ├── __init__.py
│   │   ├── config.py            # Environment configuration
│   │   ├── database.py          # Database setup (future use)
│   │   ├── api/
│   │   │   ├── __init__.py
│   │   │   ├── routes.py        # API endpoints (/health, /recognize, etc)
│   │   │   └── recognition.py   # Recognition logic (deprecated)
│   │   ├── models/
│   │   │   ├── __init__.py
│   │   │   └── song.py          # Song model (future use)
│   │   └── services/
│   │       ├── __init__.py
│   │       └── acrcloud_service.py  # ACRCloud integration
│   ├── venv/                    # Python virtual environment (DO NOT COMMIT)
│   ├── .env                     # Environment variables (DO NOT COMMIT)
│   ├── .gitignore              # Backend-specific gitignore
│   ├── main.py                 # FastAPI application entry
│   ├── requirements.txt        # Python dependencies
│   └── runtime.txt             # Python version (3.11.10)
│
└── Documentation/
    ├── DEPLOYMENT_GUIDE.md      # Complete deployment walkthrough
    ├── QUICK_START.md           # Fast setup guide
    ├── PROJECT_STRUCTURE.md     # This file
    ├── CURRENT_STATE.md         # Project state snapshot
    ├── TRANSFORMATION_SUMMARY.md # Change history
    ├── CLEANUP_BACKUP_INFO.md   # Cleanup documentation
    ├── ICON_DESIGN_GUIDE.md     # Icon design specs
    └── OTOKAGE_README.md        # User-facing README
```

---

## Key Files & Their Purpose

### Root Level

| File | Purpose |
|------|---------|
| **render.yaml** | **MAIN** deployment config for Render.com. Points to `backend/` folder. |
| .gitignore | Prevents committing secrets, build files, etc. |

### Frontend (`frontend/`)

| File/Folder | Purpose |
|-------------|---------|
| **lib/main.dart** | App entry point. Initializes LanguageService, sets up MaterialApp with AuthGate |
| **lib/screens/sign_in_screen.dart** | User authentication (Google + Email/Password) |
| **lib/screens/home_screen.dart** | Main app screen (requires authentication). Music recording UI |
| **lib/services/auth_service.dart** | Handles Google Sign-In and local email/password auth |
| **lib/services/api_service.dart** | HTTP client for backend API (`https://otokage-backend.onrender.com/api`) |
| **lib/services/audio_service.dart** | Records audio using `record` package |
| **lib/l10n/** | Localization files for EN/TR/JP languages |
| **pubspec.yaml** | Flutter project config and dependencies |

### Backend (`backend/`)

| File/Folder | Purpose |
|-------------|---------|
| **main.py** | FastAPI application. Serves API at `/api` prefix |
| **app/api/routes.py** | API endpoints: `/`, `/health`, `/recognize`, `/test` |
| **app/services/acrcloud_service.py** | ACRCloud music recognition integration |
| **app/config.py** | Loads environment variables (ACRCloud credentials, etc.) |
| **requirements.txt** | Python package dependencies |
| **runtime.txt** | Specifies Python 3.11.10 for Render |
| **.env** | **NEVER COMMIT!** Contains ACRCloud API keys |

---

##Configuration Files

### Root `render.yaml`

```yaml
services:
  - type: web
    name: otokage-backend
    env: python
    plan: free
    rootDir: backend              # Points to backend folder
    runtime: python
    buildCommand: pip install -r requirements.txt
    startCommand: uvicorn main:app --host 0.0.0.0 --port $PORT
    envVars:
      - key: PYTHON_VERSION
        value: 3.11.10
      - key: ACRCLOUD_ACCESS_KEY
        sync: false
      - key: ACRCLOUD_ACCESS_SECRET
        sync: false
      - key: ACRCLOUD_HOST
        sync: false
```

**Important:** This is the **ONLY** render.yaml file. There is no duplicate in `backend/`.

### Backend `.env` (NOT in git)

```bash
ACRCLOUD_ACCESS_KEY=your_key_here
ACRCLOUD_ACCESS_SECRET=your_secret_here
ACRCLOUD_HOST=identify-ap-southeast-1.acrcloud.com
```

### Frontend API Configuration

Located in `frontend/lib/services/api_service.dart`:
```dart
static const String baseUrl = 'https://otokage-backend.onrender.com/api';
```

---

## Important Folders (DO NOT COMMIT)

These are automatically ignored by `.gitignore`:

- `backend/venv/` - Python virtual environment
- `backend/.env` - Contains secrets
- `backend/__pycache__/` - Python compiled files
- `frontend/build/` - Flutter build output
- `frontend/.dart_tool/` - Dart tool cache
- `.DS_Store` - macOS system files

---

## API Endpoints

**Base URL:** `https://otokage-backend.onrender.com/api`

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Root endpoint - API status |
| GET | `/health` | Health check for monitoring |
| POST | `/recognize` | Music recognition from audio file |
| POST | `/test` | Test ACRCloud credentials |

---

## Authentication Flow

```
1. App starts
2. AuthGate checks if user is signed in (SharedPreferences)
3. If NOT signed in → Show SignInScreen
   - Options: Google Sign-In or Email/Password
4. If signed in → Show HomeScreen
5. User can sign out via logout icon (top-right)
```

---

## Development Workflow

### Frontend Development

```bash
cd frontend
flutter pub get
flutter run
```

### Backend Development

```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
uvicorn main:app --reload
```

### Building Production APK/AAB

```bash
cd frontend
flutter clean
flutter pub get
flutter build apk --release       # Android APK
flutter build appbundle --release # Android App Bundle
```

---

## Deployment

### Render.com Backend

1. Push code to GitHub
2. Render auto-deploys from `main` branch
3. Uses root `render.yaml` config
4. Builds from `backend/` folder (`rootDir: backend`)
5. Sets environment variables in Render dashboard

### Frontend (Mobile App)

- APK: Direct install on Android devices
- AAB: Upload to Google Play Store

---

## Version Control

### What to Commit

✅ Source code (`lib/`, `app/`, etc.)
✅ Configuration files (`pubspec.yaml`, `requirements.txt`)
✅ Documentation (`*.md` files)
✅ `render.yaml` (root level only)

### What NOT to Commit

❌ `.env` files (contain secrets)
❌ `venv/` (Python virtual environment)
❌ `build/` (Flutter build output)
❌ `__pycache__/` (Python compiled files)
❌ `.DS_Store` (macOS system files)

---

## Dependencies

### Frontend (Flutter)

- `dio` - HTTP client
- `provider` - State management
- `google_sign_in` - Google authentication
- `record` - Audio recording
- `google_fonts` - Typography
- `shared_preferences` - Local storage

### Backend (Python)

- `fastapi` - Web framework
- `uvicorn` - ASGI server
- `pyacrcloud` - Music recognition
- `python-dotenv` - Environment variables
- `requests` - HTTP client

---

## Secrets Management

**NEVER commit secrets!** All secrets are stored in:

1. **Local Development:** `backend/.env`
2. **Production (Render):** Environment Variables dashboard

Required secrets:
- `ACRCLOUD_ACCESS_KEY`
- `ACRCLOUD_ACCESS_SECRET`
- `ACRCLOUD_HOST`

---

## Build Outputs

### APK Location
```
frontend/build/app/outputs/flutter-apk/app-release.apk
```

### AAB Location
```
frontend/build/app/outputs/bundle/release/app-release.aab
```

---

## Troubleshooting

### Backend deployment fails
- Check `render.yaml` is at root (not in `backend/`)
- Verify `rootDir: backend` is set
- Check environment variables in Render dashboard

### Frontend can't connect to backend
- Verify backend URL in `frontend/lib/services/api_service.dart`
- Test backend health: `curl https://otokage-backend.onrender.com/api/health`

### Build fails
- Run `flutter clean` before building
- Check Flutter version: `flutter --version`
- Ensure all dependencies are installed: `flutter pub get`

---

**For detailed deployment instructions, see [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)**
**For quick setup, see [QUICK_START.md](QUICK_START.md)**
