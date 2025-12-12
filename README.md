# Minimal YT (Android TV)

> **A distraction-free, privacy-focused YouTube client built specifically for Android TV.**

[![Status](https://img.shields.io/badge/Status-MVP%20Released-success)]() [![Platform](https://img.shields.io/badge/Platform-Android%20TV-green)]() [![Made With](https://img.shields.io/badge/Made%20With-Flutter-blue)](https://flutter.dev)

---

## ✨ Preview

This application is designed 100% for navigation using a TV Remote D-Pad, completely eliminating algorithmic feeds, Shorts, and distracting recommendations.

![Minimal YT Preview](assets/preview.gif)

---

## 🧠 Philosophy: Intentional Viewing

YouTube on TV often becomes a tool for endless "doom-scrolling" due to aggressive algorithmic recommendations.

**Minimal YT** is built on the **"Dopamine Free"** principle:
1.  **No Home Feed:** Upon opening, there is only a search box. You must know what you want to watch.
2.  **Anti-Shorts:** All search results and channel feeds automatically filter out videos under 60 seconds.
3.  **Safe Kiosk Mode:** An optional feature to display a curated row of safe/whitelisted channels for families/children on the main page.

---

## 🚀 Key Features

* 📺 **TV Native UI:** Fully optimized for Remote Control navigation (D-Pad Focus).
* 🔍 **Distraction-Free Search:** Search for content without ad interruptions or trending videos.
* 🛡️ **Curated Safe Feed:** Pin favorite channels (e.g., educational channels for kids) to the home page via configuration files.
* 🚫 **No Distractions:** No comment sections, no "Up Next" sidebar, no auto-play.
* 🔒 **Privacy Focused:** No Google account login required. No watch history saved to servers.

---

## 🛠 Tech Stack

This project is built using a single Flutter codebase targeting Android TV.

| Component | Technology | Description |
| :--- | :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev) | Dart language. |
| **State Management** | [Riverpod](https://riverpod.dev) | For robust and scalable state handling. |
| **Data Source** | [Youtube Explode](https://pub.dev/packages/youtube_explode_dart) | Scraping-based library (No official API Key needed). |
| **Video Player** | `video_player` | Standard Flutter video playback engine. |

---

## ⚙️ Configuration (Whitelisted Channels)

As a developer (or parent), you can configure which channels appear in "Quick Access" on the main page. This is useful for creating a "Safe Mode" for children.

1.  Open the file `lib/core/channel_config.dart`.
2.  Add the Channel Name and ID to the `pinnedChannels` list:

```dart
// lib/core/channel_config.dart

class ChannelConfig {
  static const List<Map<String, String>> pinnedChannels = [
    {
      'name': 'Bluey (Official)',
      'id': 'UC4-pmjDCkP-6M8BFxW8wgFw', // Obtained from the channel URL
    },
    {
      'name': 'Super Simple Songs',
      'id': 'UCLsooMJoIpl_7ux2jvdPB-Q',
    },
    // Add other channels here...
  ];
}


📦 Installation (Sideload to TV)
To install this application onto an Android TV Box, Mi Box, or Google TV:
1. Build Release APK
Run the following command in your terminal:

```Bash
flutter build apk --release
```

The APK file will be generated at: build/app/outputs/flutter-apk/app-release.apk
2. Transfer to TV
Copy the APK file to a USB Flash Drive.
Plug the Flash Drive into your Android TV.
Use a File Manager app on the TV to access the drive and install the APK.
🧑‍💻 Development Setup
If you want to run this project locally (development machine):
Prerequisites
Ensure the Flutter SDK is installed.
1. Clone Repo


```Bash
git clone [https://github.com/gizipp/minimal_yt.git](https://github.com/gizipp/minimal_yt.git)
cd minimal_yt
```

2. Get Dependencies

```Bash
flutter pub get
```

3. Run (Testing Navigation)
It is recommended to use macOS or Windows targets to simulate arrow key inputs as a TV remote.

```Bash
flutter run -d macos
# or
flutter run -d windows
```

📄 License
This project is open-source for educational and personal use.
Disclaimer: This project is a third-party client and is not affiliated with, associated with, or endorsed by YouTube or Google Inc.