# 🌱 Krishidnya (CropDoc)

> **Your trusted digital farming companion.**
>
> Krishidnya (CropDoc) is a production-ready AgriTech mobile application built with Flutter that helps farmers manage their farms, monitor crops, access weather insights, and receive intelligent agricultural recommendations.

---

## ✨ Features

- 🔐 Secure Authentication
- 🌾 Farm Management
- ☁️ Weather Forecasts
- 📍 GPS-based Location Detection
- 🌱 Crop Growth Monitoring
- 🦠 Disease Detection (AI-powered crop scanning)
- 📊 Farm Analytics (Digital farm logbook with expense tracking)
- 🔔 Smart Notifications
- 🌐 Localization Support
- 🎨 Modern Material 3 UI

---

# 🏗️ Project Architecture

The project follows a **Feature-First + Clean Architecture** approach.

```
lib/
├── main.dart
├── core/             # API, theme, routing, storage, networking, error handling
├── features/         # Application features
├── widgets/          # Shared reusable UI components
├── utils/            # Common helper functions
└── l10n/             # Localization
```

Each feature is organized as:

```
feature/
├── presentation/     # UI, Screens, Widgets, Riverpod Providers
├── domain/           # Business logic, Entities, Repository Contracts
└── data/             # Models, API, Local Storage, Repository Implementations
```

---

# 🛠 Tech Stack

| Layer | Technology |
|--------|------------|
| Framework | Flutter (Latest Stable) |
| Language | Dart |
| Architecture | Clean Architecture |
| State Management | Riverpod |
| Routing | GoRouter |
| Networking | Dio |
| Secure Storage | Flutter Secure Storage |
| Local Storage | SharedPreferences |
| Model Generation | Freezed + json_serializable |
| Code Generation | build_runner |
| Linting | Very Good Analysis |

---

# 🚀 Getting Started

## Prerequisites

Before running the project, ensure you have:

- Flutter SDK (Latest Stable)
- Android Studio or VS Code
- Xcode (for iOS development)
- Git

Verify Flutter installation:

```bash
flutter doctor
```

---

## Installation

Clone the repository:

```bash
git clone <repository-url>
cd krishidnya
```

Install dependencies:

```bash
flutter pub get
```

Generate platform folders (only if missing):

```bash
flutter create .
```

Generate models:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Run the application:

```bash
flutter run
```

---

# ⚙️ Backend Configuration

Default API:

```
http://13.200.235.31
```

Configured in:

```
lib/core/api/api_config.dart
```

Override during runtime:

```bash
flutter run --dart-define=API_BASE_URL=http://13.200.235.31
```

---

# 🔐 Authentication API

| Endpoint | Method |
|----------|--------|
| `/register` | POST |
| `/token` | POST |
| `/users/me` | GET |

### Notes

- Registration uses JSON.
- Login uses **form-urlencoded**.
- Mobile number is sent as the `username` field.
- Authentication is JWT-based.

---

# 🐞 Debug Logging

During development, API activity is logged to:

### Console

Filter logs by:

- HTTP
- Auth
- AuthRepo

### In-App Log Monitor

Tap the 🐞 floating action button on the Login or Dashboard screens.

Logs include:

- Timestamp
- Request URL
- Response
- Errors
- Stack traces

---

# 📍 Location Permissions

## Android

Since the backend uses HTTP, configure **cleartext traffic**.

Inside:

```
android/app/src/main/AndroidManifest.xml
```

Add:

```xml
<application
    android:networkSecurityConfig="@xml/network_security_config"
    ...>
```

The configuration file should exist at:

```
android/app/src/main/res/xml/network_security_config.xml
```

Also include location permissions:

```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

---

## iOS

Inside:

```
ios/Runner/Info.plist
```

Add:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>
Krishidnya needs your location to provide weather and crop insights for your farm.
</string>
```

---

# 📱 User Journey

## Onboarding

```
Welcome
    ↓
Introduction
    ↓
Features
    ↓
Register / Login
```

---

## Registration

```
Create Account
        ↓
Location Permission
        ↓
GPS Detection
        ↓
Location Found
        ↓
Almost Ready
        ↓
Account Created
        ↓
Dashboard
```

### Registration Rules

- Username is automatically generated.

Example:

```
Tejas Barguje
↓

tejas_barguje
```

Users log in using:

- Mobile Number
- Password

---

## Dashboard

Progressive loading animation:

```
Greeting
      ↓
Weather
      ↓
Farm Status
      ↓
Crop Stage
      ↓
Recommendations
```

---

# 📦 Project Status

| Module | Status |
|---------|--------|
| Authentication | ✅ Complete |
| Onboarding | ✅ Complete |
| Registration Flow | ✅ Complete |
| Dashboard | ✅ Complete |
| Weather | ✅ Complete |
| Farm Management | ✅ Complete |
| Disease Detection | ✅ Complete |
| Analytics | ✅ Complete |
| Notifications | ✅ Complete |
| Profile & Settings | ✅ Complete |
| Marketplace | ✅ Complete |
| Mandi Prices | ✅ Complete |
| Government Schemes | ✅ Complete |
| AI Chat | ✅ Complete |
| Community | ✅ Complete |

---

# 🎨 Design System

Krishidnya follows a modern design language inspired by nature.

- 🌿 Forest Green palette
- 🌎 Earth-tone accents
- ☁️ Sky Blue highlights
- Material 3
- Rounded cards
- Smooth animations
- Storytelling-driven UX
- Responsive layouts

---

# 📐 Development Guidelines

- Keep business logic out of Widgets.
- No API calls inside the UI layer.
- Follow Clean Architecture.
- Use Riverpod for state management.
- Keep files modular and maintainable.
- Place reusable components inside `lib/widgets`.
- Centralize API logic in `ApiClient`.
- Define endpoints only in `api_config.dart`.

---

# 🌍 Vision

Krishidnya is being built to empower **millions of farmers across India** with accessible, reliable, and intelligent digital farming tools.

---

## 🤝 Contributing

1. Fork the repository.
2. Create a feature branch.

```bash
git checkout -b feature/my-feature
```

3. Commit your changes.

```bash
git commit -m "Add new feature"
```

4. Push to your branch.

```bash
git push origin feature/my-feature
```

5. Open a Pull Request.

---

# 📄 License

This project is licensed under the MIT License unless stated otherwise.

---

<div align="center">

### 🌱 Built with Flutter for the future of Indian agriculture 🇮🇳

**Empowering farmers through technology.**

</div>
