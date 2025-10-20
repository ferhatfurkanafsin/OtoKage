# Current State Documentation - Before OtoKage Transformation

**Generated:** 2025-10-20
**Purpose:** Reference document for current app configuration before transformation to OtoKage

---

## App Identity

- **Current Name:** VibeQuest
- **Package ID:** com.vibequest.app
- **Display Name:** VibeQuest
- **Description:** VibeQuest: Anime & Game OST Finder
- **Version:** 1.0.0+1
- **Tagline (EN):** Anime • Game OST Finder

## Architecture

### Technology Stack

**Frontend:**
- Framework: Flutter 3.0.0+
- Language: Dart
- UI Framework: Material Design 3
- State Management: Provider 6.1.1

**Backend:**
- Framework: FastAPI 0.104.1
- Server: Uvicorn ASGI
- Recognition Engine: ACRCloud (pyacrcloud 1.0.10)
- Database: PostgreSQL
- Deployment: Render.com (https://vgm-music-recognition.onrender.com)

### Key Dependencies

```yaml
dependencies:
  dio: ^5.4.0                    # HTTP client
  record: ^5.1.0                 # Audio recording
  path_provider: ^2.1.1          # File paths
  permission_handler: ^11.1.0    # Runtime permissions
  audioplayers: ^5.2.1           # Audio playback
  provider: ^6.1.1               # State management
  url_launcher: ^6.2.2           # External URLs
  google_fonts: ^6.1.0           # Typography
  google_sign_in: ^6.2.1         # Authentication
  shared_preferences: ^2.2.2     # Local storage
```

## Theme Configuration

### Color Palette

```dart
Primary Color:    #00E5FF  // Neon Cyan
Secondary Color:  #FF2FB9  // Neon Pink/Magenta
Background:       #0B0D14  // Deep Dark Space
Scaffold BG:      #0B0D14  // Deep Dark Space
```

### Typography

- **Font Family:** Google Fonts - Plus Jakarta Sans
- **Material Design:** Version 3 (useMaterial3: true)

### Visual Elements

- **Scanlines Overlay:** White 2% opacity, 3px gap
- **Animated Equalizer:** 7 bars, 1200ms animation cycle
- **Concentric Circles:** 3 rings (320px, 240px, 160px)
- **Gradient:** Cyan to Pink gradient on center button
- **Glow Effects:** Cyan and Pink shadows with blur

## File Structure

### Frontend Structure

```
frontend/
├── lib/
│   ├── main.dart                           # App entry point
│   ├── generated/
│   │   └── app_localizations.dart          # Generated i18n
│   ├── l10n/
│   │   ├── app_en.arb                      # English strings
│   │   └── app_tr.arb                      # Turkish strings
│   ├── models/
│   │   └── song_model.dart                 # Song data model
│   ├── screens/
│   │   ├── home_screen.dart                # Main screen with recording
│   │   ├── recording_screen.dart           # Recording interface
│   │   ├── result_screen.dart              # Results display
│   │   └── sign_in_screen.dart             # Authentication
│   └── services/
│       ├── api_service.dart                # Backend API client
│       ├── audio_service.dart              # Audio recording
│       └── auth_service.dart               # Google Sign-In
├── android/
│   └── app/
│       ├── build.gradle.kts                # Android build config
│       └── src/main/
│           ├── AndroidManifest.xml         # App manifest
│           ├── kotlin/.../MainActivity.kt  # Main activity
│           └── res/
│               ├── mipmap-*/ic_launcher.*  # App icons
│               ├── values/colors.xml       # Color resources
│               └── drawable-*/            # Launch screen
├── ios/
│   └── Runner/
│       ├── Info.plist                      # iOS config
│       └── Assets.xcassets/
│           └── AppIcon.appiconset/         # iOS icons
└── assets/
    └── vibequest_icon.png                  # Source icon (1024x1024)
```

### Backend Structure

```
backend/
├── app/
│   ├── api/
│   │   └── routes.py                       # API endpoints
│   ├── services/
│   │   └── acrcloud_service.py             # ACRCloud integration
│   └── config.py                           # Configuration
├── main.py                                 # FastAPI entry
└── requirements.txt                        # Python dependencies
```

## Platform Configurations

### Android Configuration

**File:** `frontend/android/app/build.gradle.kts`

```kotlin
namespace = "com.vibequest.app"
applicationId = "com.vibequest.app"
compileSdk = flutter.compileSdkVersion
minSdk = flutter.minSdkVersion
targetSdk = flutter.targetSdkVersion
versionCode = flutter.versionCode
versionName = flutter.versionName

// Signing
signingConfigs {
    create("release") {
        storeFile = file("upload-keystore.jks")
        storePassword = "vibeqPass123"
        keyAlias = "upload"
        keyPassword = "vibeqPass123"
    }
}

// Release optimization
buildTypes {
    release {
        isMinifyEnabled = true
        isShrinkResources = true
        signingConfig = signingConfigs.getByName("release")
    }
}
```

**Permissions (AndroidManifest.xml):**
- RECORD_AUDIO
- INTERNET
- WRITE_EXTERNAL_STORAGE
- READ_EXTERNAL_STORAGE

### iOS Configuration

**File:** `frontend/ios/Runner/Info.plist`

```xml
<key>CFBundleDisplayName</key>
<string>VibeQuest</string>
<key>CFBundleName</key>
<string>VibeQuest</string>
```

### Icon Configuration

**File:** `frontend/pubspec.yaml`

```yaml
flutter_icons:
  android: true
  ios: true
  adaptive_icon_background: "#00E5FF"
  adaptive_icon_foreground: "assets/vibequest_icon.png"
  background_color_ios: "#0B0D14"
  image_path: "assets/vibequest_icon.png"
  min_sdk_android: 21
```

### Splash Screen Configuration

```yaml
flutter_native_splash:
  color: "#0B0D14"
  color_dark: "#0B0D14"
  android_12:
    color: "#0B0D14"
    icon_background_color: "#0B0D14"
  android: true
  ios: true
  web: true
```

## Localization (i18n)

### Supported Locales
- English (en)
- Turkish (tr)

### Current Strings (English)

```json
{
  "appTitle": "VibeQuest: Anime & Game OST",
  "homeTitleShort": "VibeQuest",
  "homeTagline": "Anime • Game OST Finder",
  "homeTapToIdentify": "Tap to identify OP/ED or Game OST",
  "cannotConnect": "Cannot connect to server",
  "retry": "Retry",
  "recordHeader": "Record your OP/OST",
  "recognizing": "Recognizing...",
  "recognizingHint": "Please wait while we identify your song",
  "recording": "Recording… aim for 10–15 seconds",
  "tapToStart": "Tap to start; hum OP/ED or game theme",
  "minRecordingHint": "Hum or sing the melody for at least 10 seconds",
  "resultHeader": "Match",
  "songFound": "OST Found!",
  "listenOn": "Listen on:",
  "tryAnotherSong": "Try Another Song",
  "noMatchFound": "No Match Found",
  "tipsHeader": "Tips for better results:",
  "tip1": "Hum or sing for at least 10–15 seconds",
  "tip2": "Try to match the melody as closely as possible",
  "tip3": "Record in a quiet environment",
  "tip4": "Try a popular anime OP/ED or game theme",
  "tryAgain": "Try Again"
}
```

## API Configuration

### Backend API

**Base URL:** `https://vgm-music-recognition.onrender.com/api`

**Endpoints:**
- `GET /api/` - Health check
- `POST /api/recognize` - Audio recognition (max 10MB)
- `POST /api/test` - ACRCloud credential validation

**Timeout:** 60 seconds (connect + receive)

### Audio Recording Settings

```dart
Encoder: AAC-LC
Bitrate: 128 kbps
Sample Rate: 44.1 kHz
Format: .m4a
Storage: Application documents directory
Naming: audio_<timestamp>.m4a
```

## Known Issues

### Critical Issues

1. **App Crash on Launch (APK):**
   - Location: `home_screen.dart:91`
   - Issue: Uses `Navigator.pushReplacementNamed(context, '/result')` but no route defined
   - Impact: App opens and immediately closes
   - Fix Required: Add route definitions in main.dart

### Security Concerns

1. **Hardcoded Keystore Password:**
   - Location: `android/app/build.gradle.kts:36-38`
   - Issue: Passwords stored in plain text
   - Recommendation: Use environment variables or secure storage

2. **Backend CORS:**
   - Location: Backend CORS set to "*" (allow all origins)
   - Recommendation: Restrict to specific domains in production

## Git Status (Snapshot)

**Current Branch:** main

**Modified Files:**
- frontend/android/app/build.gradle.kts
- frontend/lib/screens/home_screen.dart
- frontend/macos/Flutter/GeneratedPluginRegistrant.swift
- frontend/pubspec.lock
- frontend/pubspec.yaml

**Untracked Files:**
- frontend/android/app/src/main/res/drawable-*/
- frontend/android/app/src/main/res/mipmap-anydpi-v26/
- frontend/android/app/src/main/res/values/colors.xml
- frontend/lib/screens/sign_in_screen.dart
- frontend/lib/services/auth_service.dart

**Recent Commits:**
1. `2a2fe0c` - Generate professional neon launcher icon
2. `09810d1` - Remove top-right close button on HomeScreen
3. `4eaf5a2` - Add neon splash and launcher icons config
4. `bd5dc5b` - Set app display name to VibeQuest
5. `cb0d292` - Rebrand to VibeQuest with EN/TR localization

## Navigation Flow

```
HomeScreen (default)
  ├─> Recording starts on tap
  ├─> Shows timer during recording
  ├─> Sends audio to backend
  └─> Navigates to ResultScreen (BROKEN - no route!)
      ├─> Shows song details
      ├─> Links to YouTube/Spotify
      └─> "Try Another Song" button
```

## Build Commands

### Generate Localization
```bash
flutter gen-l10n
```

### Generate Icons
```bash
flutter pub run flutter_launcher_icons:main
```

### Generate Splash Screen
```bash
flutter pub run flutter_native_splash:create
```

### Build APK
```bash
flutter build apk --release
```

### Build App Bundle
```bash
flutter build appbundle --release
```

## Backend Environment Variables

Required in production:
- `ACRCLOUD_HOST` - ACRCloud API host
- `ACRCLOUD_ACCESS_KEY` - ACRCloud access key
- `ACRCLOUD_ACCESS_SECRET` - ACRCloud secret key
- `DATABASE_URL` - PostgreSQL connection string
- `API_HOST` - API server host
- `API_PORT` - API server port

---

## Rollback Instructions

To restore this state after OtoKage transformation:

1. **Restore Git State:**
   ```bash
   git checkout main
   git reset --hard <commit-hash>
   ```

2. **Restore Package Name:**
   - Revert `android/app/build.gradle.kts`
   - Revert `AndroidManifest.xml`
   - Revert `ios/Runner/Info.plist`

3. **Restore Assets:**
   - Replace icon with `assets/vibequest_icon.png`
   - Regenerate platform icons

4. **Restore Localization:**
   - Keep only `app_en.arb` and `app_tr.arb`
   - Remove `app_ja.arb` if added
   - Revert string changes

5. **Clean Build:**
   ```bash
   flutter clean
   flutter pub get
   flutter build apk --release
   ```

---

**End of Current State Documentation**
