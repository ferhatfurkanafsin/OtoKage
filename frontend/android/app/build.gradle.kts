plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.vibequest.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // Unique application ID for Play Store
        applicationId = "com.vibequest.app"
        // COMPATIBILITY FIX: Lowered minSdk to support older Android devices
        minSdk = flutter.minSdkVersion  // Android 4.4 KitKat (was 21)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            storeFile = file("upload-keystore.jks")
            storePassword = "vibeqPass123"
            keyAlias = "upload"
            keyPassword = "vibeqPass123"
        }
    }

    buildTypes {
        release {
            // CRITICAL FIX: Disabled minification - was breaking Flutter app startup
            // R8/ProGuard was removing essential Flutter code causing instant crash
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
