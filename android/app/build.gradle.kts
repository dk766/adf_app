plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "de.mpi.ds.adf_app"
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
        // Application ID - Update this to your own unique package name
        applicationId = "de.mpi.ds.adf_app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            // Release signing configuration
            // To create a keystore, run:
            // keytool -genkey -v -keystore adf_app-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias adf_app
            // Then update the values below and uncomment them

            // storeFile = file("path/to/your/keystore.jks")
            // storePassword = System.getenv("KEYSTORE_PASSWORD") ?: ""
            // keyAlias = "your-key-alias"
            // keyPassword = System.getenv("KEY_PASSWORD") ?: ""
        }
    }

    buildTypes {
        release {
            // Use release signing config when configured
            // For now, debug signing is used to allow testing release builds
            // IMPORTANT: Configure proper release signing before publishing to production
            signingConfig = signingConfigs.getByName("debug")
            // Uncomment the line below once you've configured release signing:
            // signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
