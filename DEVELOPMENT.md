# ADF App - Development Guide

## Project Overview

ADF App is a Flutter-based mobile application for managing company information, invoices, documents, and financial statistics. It connects to a backend REST API for data management.

## Features

### Implemented
- ✅ Token-based authentication
- ✅ Secure local storage for credentials
- ✅ Multi-company management
- ✅ Dashboard with statistics and charts
- ✅ Monthly sales, expenses, and profit visualization
- ✅ Settings management (API endpoint, user logo, personal info)
- ✅ Responsive Material Design 3 UI
- ✅ State management with Provider
- ✅ Error handling and loading states

### Coming Soon
- 📋 Invoice list and management
- 📁 Document upload and management
- 🔍 Search functionality (OpenSearch integration)
- 📊 Advanced analytics
- 📱 Offline mode

## Architecture

```
lib/
├── config/          # App configuration and constants
├── models/          # Data models
├── providers/       # State management (Provider pattern)
├── screens/         # UI screens
├── services/        # API and storage services
├── widgets/         # Reusable UI components
└── main.dart        # App entry point
```

## Key Dependencies

- **dio**: HTTP client for REST API calls
- **provider**: State management
- **flutter_secure_storage**: Secure token storage
- **shared_preferences**: Local settings storage
- **fl_chart**: Charts and data visualization
- **image_picker**: Logo upload functionality
- **file_picker**: Document upload functionality

## API Integration

### Authentication
The app uses token-based authentication:
```
POST /api/token-auth/
Body: {"username": "user", "password": "pass"}
Response: {"token": "..."}
```

### Key Endpoints
- `/api/dashboard/company-stats/` - Company dashboard statistics
- `/api/dashboard/monthly-expenses/` - Monthly expenses data
- `/api/dashboard/monthly-sales/` - Monthly sales data
- `/api/dashboard/monthly-profit/` - Monthly profit data
- `/api/documents/` - Document management
- `/data/company_roles_backend/` - Company list
- `/data/invoice_backend/` - Invoice management

### Configuration
Users can configure the backend API URL in Settings. Default: `http://localhost:8000`

## Development Setup

### Prerequisites
- Flutter SDK (>=3.18.0)
- Dart SDK (^3.7.0)
- Android Studio / Xcode for platform-specific builds
- Backend API running and accessible

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Run on device/emulator:
```bash
flutter run
```

3. Build for specific platforms:
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Linux
flutter build linux --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release
```

## State Management

The app uses the Provider pattern for state management:

- **AuthProvider**: Authentication state, login/logout
- **CompanyProvider**: Company list and selection
- **DashboardProvider**: Dashboard data and statistics
- **SettingsProvider**: App settings and configuration

## Data Flow

1. User logs in → Token stored securely
2. Companies loaded → User selects company
3. Dashboard data fetched for selected company
4. Data displayed with charts and statistics
5. User can switch companies or navigate to other screens

## Security Features

- Tokens stored in Flutter Secure Storage (encrypted)
- HTTPS support for API communication
- Environment variable support for credentials
- Secure password fields with visibility toggle

## UI/UX Features

- Material Design 3 theme
- Responsive layouts for different screen sizes
- Pull-to-refresh on dashboard
- Loading indicators
- Error handling with retry options
- Smooth navigation transitions

## Testing

Run tests with:
```bash
flutter test
```

Run analysis:
```bash
flutter analyze
```

## Platform Support

### Android
- Minimum SDK: 21 (Android 5.0)
- Package: `de.mpi.ds.adf_app`

### iOS
- Minimum version: Defined in Flutter SDK
- Bundle ID: `de.mpi.ds.adfApp`

### Desktop
- Linux: GTK+ 3.0
- Windows: Win32 API
- macOS: Native macOS APIs

## Extending the App

### Adding New API Endpoints

1. Update `lib/config/app_config.dart` with new endpoint
2. Add method in `lib/services/api_service.dart`
3. Create/update model in `lib/models/`
4. Create/update provider in `lib/providers/`
5. Create/update UI screen in `lib/screens/`

### Adding New Screens

1. Create screen in `lib/screens/`
2. Add route in `lib/main.dart`
3. Navigate using `Navigator.pushNamed(context, '/route-name')`

### Adding Charts

Use the `MonthlyChart` widget or create custom charts using `fl_chart`:
```dart
MonthlyChart(
  data: monthlyData,
  title: 'My Chart',
  color: Colors.blue,
)
```

## Troubleshooting

### Common Issues

**Dependencies not found:**
```bash
flutter pub get
flutter pub upgrade
```

**Build errors:**
```bash
flutter clean
flutter pub get
flutter run
```

**API connection issues:**
- Check Settings → Server Configuration
- Ensure backend is running and accessible
- Check network permissions in AndroidManifest.xml

**Token expiration:**
- Logout and login again
- Backend should handle token refresh

## Future Enhancements

- Push notifications
- Biometric authentication
- Offline data caching
- PDF export of reports
- Multi-language support
- Dark mode
- Advanced filtering and search
- Real-time data updates

## License

See LICENSE file for details.

## Contact

For issues and feature requests, please use the project's issue tracker.
