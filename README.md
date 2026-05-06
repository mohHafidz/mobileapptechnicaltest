# 📖 Quran Audio App - Flutter Mobile Technical Test

A modern, feature-rich Flutter application designed for a seamless Quran listening experience. This app allows users to explore surahs, listen to beautiful recitations from various Qori, and manage playback even when the app is in the background.

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![GetX](https://img.shields.io/badge/GetX-%236E1BFF.svg?style=for-the-badge&logo=getx&logoColor=white)

## ✨ Features

### 🎵 Advanced Audio Playback
- **Sequential & Shuffle Playback**: Listen to surahs in order or mix them up with a dedicated shuffle mode.
- **Background Playback**: Keep the recitation playing even when the app is minimized or the screen is locked, thanks to `just_audio_background`.
- **Media Controls**: Full control from the notification bar and lock screen (Play, Pause, Skip, Previous).
- **Persistent Mini Player**: A sleek mini-player that stays visible across different screens for quick control.

### 🎙️ Qori Selection
- **Multiple Reciters**: Choose from a variety of famous Qoris.
- **Searchable BottomSheet**: Easily find your favorite reciter using the integrated search in the Qori selection panel.

### 🔍 Smart Search
- **Surah Search**: Find surahs quickly by name.
- **Search History**: Keeps track of your last 6 searches for quick access, with automatic management of old entries.

### 🎨 Premium Design
- **Dark Mode Aesthetics**: A beautiful, modern dark theme using a curated teal and gold color palette.
- **Smooth Transitions**: Fluid navigation between screens using GetX transitions.
- **Modern Typography**: High-quality rendering using Google Fonts (Manrope).

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [GetX](https://pub.dev/packages/get)
- **Audio Engine**: [just_audio](https://pub.dev/packages/just_audio) & [just_audio_background](https://pub.dev/packages/just_audio_background)
- **Networking**: [http](https://pub.dev/packages/http)
- **Typography**: [google_fonts](https://pub.dev/packages/google_fonts)

## 📂 Project Structure

```bash
lib/
├── component/    # Reusable UI widgets (MiniPlayer, etc.)
├── model/        # Data models for Surah, Ayah, and Qori
├── page/         # App screens (Home, Detail, Search, NowPlaying)
├── tools/        # Utility classes and color constants
├── view model/   # GetX controllers handling business logic
└── main.dart     # App entry point and configuration
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Latest Version recommended)
- Android Studio / VS Code
- An Android/iOS Emulator or Physical Device

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/mobileapptechnicaltest.git
   ```

2. **Navigate to the project directory**
   ```bash
   cd mobileapptechnicaltest
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

## 📱 Screenshots

*Add your app screenshots here to showcase the beautiful UI!*

---

Developed as a Technical Test for Mobile Development.
