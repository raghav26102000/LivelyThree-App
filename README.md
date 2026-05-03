<div align="center">

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&size=13&pause=1000&color=4CAF50&center=true&vCenter=true&width=500&lines=🌱+Plant-Based+Nutrition+Tracker;Mood+%7C+Health+%7C+Community+Insights;Flutter+%7C+Firebase+%7C+Supabase+%7C+Cross-Platform" alt="Typing SVG" />

# 🌿 The Lively Three

### _Track Your Plants. Understand Your Body. Thrive._

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-Language-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Supabase](https://img.shields.io/badge/Supabase-Auth+DB-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com)
[![iOS](https://img.shields.io/badge/iOS-11.0+-000000?style=for-the-badge&logo=apple&logoColor=white)](https://apple.com)
[![Android](https://img.shields.io/badge/Android-SDK+21+-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://android.com)
[![License](https://img.shields.io/badge/License-MIT-22C55E?style=for-the-badge)](LICENSE)
[![Version](https://img.shields.io/badge/Version-v0.97.0+36-4CAF50?style=for-the-badge)](CHANGELOG.md)

<br/>

> **The Lively Three** is a comprehensive health and nutrition tracking app that helps users monitor their plant-based food consumption, track health metrics, and achieve wellness goals through personalized analytics and community insights.

<br/>

[🚀 Quick Start](#-getting-started) · [✨ Features](#-features) · [🛠 Tech Stack](#-tech-stack) · [📁 Structure](#-app-structure) · [🗺 Roadmap](#-roadmap)

---

</div>

<br/>

## ✨ Features

<br/>

### 🌱 Plant-Based Nutrition Tracking
- Log daily plant consumption and monitor nutritional intake
- **Fiber & Protein tracking** against science-backed recommendations
- Add-on tracking for water, processed food intake, and weight changes

### 📊 Health Score Dashboard
- Interactive charts and progress indicators via **FL Chart**
- Visualize trends across multiple health dimensions
- Historical data analysis with premium subscription

### 😊 Mood & Body Tracking
- Record mental and physical well-being **up to 12 times daily**
- Spot patterns between diet, mood, and energy levels over time

### 👥 Community Analytics
- Compare your progress with **community averages**
- Discover insights from aggregated anonymised data
- Celebrate milestones alongside your community

### 🎯 Personalized Recommendations
- Tailored suggestions based on your health goals and dietary preferences
- Guided in-app **walkthroughs and coach marks** for new users
- **Push notifications** for health reminders via Firebase Cloud Messaging

### 🌍 Multi-language & Cross-Platform
- Available in **English, German, French, and Dutch**
- Runs on **iOS, Android, Web, macOS, Linux, and Windows**

<br/>

---

## 🏗 Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                        UI LAYER                              │
│     Flutter Widgets · FL Chart · Custom Animations          │
│     Montserrat + KoHo Fonts · Responsive Layouts            │
└───────────────────────────┬──────────────────────────────────┘
                            │
┌───────────────────────────▼──────────────────────────────────┐
│                    STATE & NAVIGATION                        │
│              Provider (State Management)                     │
│              go_router (Navigation & Routing)                │
└──────┬────────────────────┬─────────────────────────────────-┘
       │                    │
┌──────▼──────┐    ┌────────▼──────────────────────────────-──┐
│  LOCAL DATA │    │            REMOTE BACKENDS                │
│  SQLite     │    │  Firebase Firestore · Firebase Auth       │
│  SharedPrefs│    │  Firebase FCM · Supabase Auth + DB        │
└─────────────┘    └───────────────────────────────────────────┘
```

<br/>

---

## 🛠 Tech Stack

| Category | Technology | Purpose |
|----------|-----------|---------|
| **Framework** | Flutter 3.0+ | Cross-platform UI |
| **Language** | Dart | App logic |
| **Backend** | Firebase Firestore | Real-time data sync |
| **Auth** | Supabase + Google Sign-In | Authentication |
| **Messaging** | Firebase Cloud Messaging | Push notifications |
| **Navigation** | go_router | Routing & deep linking |
| **State** | provider | State management |
| **Charts** | fl_chart | Data visualisation |
| **Local DB** | sqflite | Offline SQLite storage |
| **Local Store** | shared_preferences | Lightweight persistence |
| **Images** | cached_network_image | Efficient image loading |
| **Notifications** | flutter_local_notifications | Local alerts |
| **Payments** | in_app_purchase | Subscription monetisation |
| **Fonts** | Montserrat, KoHo | Custom typography |
| **Analytics** | Firebase Analytics | User behaviour tracking |

<br/>

---

## 📁 App Structure

```
lib/
├── auth/                   # Authentication logic
│   ├── google_sign_in.dart
│   └── supabase_auth.dart
│
├── backend/                # API integrations
│   ├── firebase/           # Firestore & FCM
│   └── supabase/           # Supabase client
│
├── components/             # Reusable UI components
│   ├── bottom_nav/         # Custom bottom navigation
│   ├── charts/             # Chart widgets
│   └── progress/           # Progress indicators
│
├── pages/                  # Screen implementations
│   ├── dashboard/          # Health metrics dashboard
│   ├── homepage/           # Main app interface
│   ├── login/              # Authentication screens
│   └── subscription/       # Premium features
│
├── models/                 # Data models
├── providers/              # State management
├── utils/                  # Helper functions
├── flutter_flow/           # FlutterFlow generated code
├── custom_code/            # Custom widgets & utilities
├── walkthroughs/           # Coach marks & tutorials
└── l10n/                   # Localisation (en, de, fr, nl)
```

<br/>

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `>=3.0.0`
- Dart SDK
- A [Firebase](https://console.firebase.google.com) project
- A [Supabase](https://supabase.com) project
- Google Sign-In credentials (optional)

---

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/the-lively-three.git
cd the-lively-three/the_lively_three
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Setup

```bash
# Install the FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for all platforms
flutterfire configure
```

Then place the generated files:
- `GoogleService-Info.plist` → `ios/Runner/`
- `google-services.json` → `android/app/`

### 4. Supabase Configuration

Create a `.env` file or update `lib/flutter_flow/flutter_flow_util.dart` with your credentials:

```dart
const supabaseUrl = 'https://your-project.supabase.co';
const supabaseAnonKey = 'your-anon-key';
```

### 5. Run the App

```bash
# Run on connected device or emulator
flutter run

# Run on a specific platform
flutter run -d chrome        # Web
flutter run -d macos         # macOS
flutter run -d windows       # Windows
```

<br/>

---

## 📱 Platform Support

| Platform | Min Version | Status |
|----------|------------|--------|
| 🤖 Android | SDK 21 (Android 5.0) | ✅ Supported |
| 🍎 iOS | iOS 11.0+ | ✅ Supported |
| 🌐 Web | Modern browsers | ✅ Supported |
| 🖥 macOS | macOS 10.14+ | ✅ Supported |
| 🪟 Windows | Windows 10+ | ✅ Supported |
| 🐧 Linux | Ubuntu 18.04+ | ✅ Supported |

<br/>

---

## 🌍 Localization

The app supports 4 languages out of the box:

| Code | Language |
|------|----------|
| `en` | 🇬🇧 English |
| `de` | 🇩🇪 German |
| `fr` | 🇫🇷 French |
| `nl` | 🇳🇱 Dutch |

Translation files live in `lib/l10n/`. To add a new language, create `app_xx.arb` and register it in `l10n.yaml`.

<br/>

---

## 🔒 Privacy & Security

- **OAuth2** and email/password authentication via Supabase & Firebase
- **Encrypted** data transmission over HTTPS
- **GDPR compliant** — user consent and data management controls built in
- **Anonymous community analytics** — no personal data shared in aggregates

<br/>

---

## 🗺 Roadmap

- [ ] Apple Watch integration
- [ ] Advanced AI-powered nutrition recommendations
- [ ] Social features and community challenges
- [ ] Integration with health wearables (Fitbit, Garmin, Oura)
- [ ] Web dashboard for detailed analytics
- [ ] Recipe suggestions based on nutritional gaps

<br/>

---

## 🤝 Contributing

Contributions are welcome!

```bash
# Fork the repo, then:
git clone https://github.com/your-username/the-lively-three.git
git checkout -b feature/AmazingFeature

# Make your changes, then:
git commit -m 'feat: Add AmazingFeature'
git push origin feature/AmazingFeature
# Open a Pull Request
```

Please make sure your code passes `flutter analyze` and existing tests before submitting.

```bash
flutter analyze
flutter test
```

<br/>

---

## 🆘 Support

| Channel | Details |
|---------|---------|
| 🐛 Issues | [Open a GitHub Issue](../../issues) |
| 📖 Wiki | Check the repo Wiki for docs |
| 🎓 In-App | Follow guided walkthroughs inside the app |

<br/>

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

<br/>

---

<div align="center">

Built with ❤️ using Flutter

**v0.97.0+36** · FlutterFlow Project · Flutter Stable Channel

[![GitHub stars](https://img.shields.io/github/stars/your-username/the-lively-three?style=social)](https://github.com/your-username/the-lively-three)
[![GitHub forks](https://img.shields.io/github/forks/your-username/the-lively-three?style=social)](https://github.com/your-username/the-lively-three/fork)

</div>
