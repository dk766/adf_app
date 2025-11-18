# ADF App

A cross-platform Flutter application for Android, iOS, Linux, macOS, and Windows.

## Project Information

- **Package ID**: `de.mpi.ds.adf_app`
- **Version**: 1.0.0+1
- **Dart SDK**: ^3.7.0
- **Flutter**: Latest stable

## Supported Platforms

- Android
- iOS
- Linux (GTK)
- macOS
- Windows (Win32)

## Getting Started

### Prerequisites

- Flutter SDK (>=3.18.0-18.0.pre.54)
- Dart SDK (^3.7.0)
- Platform-specific requirements:
  - **Android**: Android Studio, Gradle 8.7.0+
  - **iOS/macOS**: Xcode, CocoaPods
  - **Linux**: GTK+ 3.0, CMake 3.14+
  - **Windows**: Visual Studio, CMake 3.14+

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd adf_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Building for Release

#### Android
Before building for production, configure release signing:

1. Generate a keystore:
```bash
keytool -genkey -v -keystore adf_app-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias adf_app
```

2. Update `android/app/build.gradle.kts` with your keystore details

3. Build the release APK:
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

#### Linux
```bash
flutter build linux --release
```

#### macOS
```bash
flutter build macos --release
```

#### Windows
```bash
flutter build windows --release
```

## Testing

Run tests with:
```bash
flutter test
```

## Code Quality

This project uses `flutter_lints` for code quality analysis. Run the analyzer with:
```bash
flutter analyze
```

## Project Structure

```
lib/
  main.dart         # Application entry point
test/
  widget_test.dart  # Widget tests
android/            # Android-specific code
ios/                # iOS-specific code
linux/              # Linux-specific code
macos/              # macOS-specific code
windows/            # Windows-specific code
```

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
