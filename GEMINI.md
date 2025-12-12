# Project Context: Minimal YT (Android TV)

## 1. Project Overview
We are building **Minimal YT**, a minimalist YouTube client for **Android TV** using **Flutter**.
- **Repo Name:** `minimal_yt`
- **Philosophy:** Intentional watching. No Feeds, No Shorts.
- **Device:** Android TV (Requires D-Pad navigation logic).

## 2. Tech Stack & Libraries
- **Language:** Dart
- **Framework:** Flutter
- **State Management:** `flutter_riverpod` (Riverpod 2.0+ syntax: `ConsumerWidget`, `Ref`).
- **Data Fetching:** `youtube_explode_dart`.
- **UI Components:** `material.dart`, `google_fonts`.
- **Video:** `video_player`, `chewie`.

## 3. Coding Guidelines (CRITICAL FOR TV)

### A. Focus Management (The #1 Rule)
Android TV relies on **Focus**, not Touch.
- Every interactive widget (Card, Button, Input) **MUST** be wrapped in an `InkWell` or `Focus` widget.
- Implement `onFocusChange` to update the UI state (e.g., change border color, scale animation).
- Users must always know *visually* where their cursor is.
- **Example Pattern:**
  ```dart
  InkWell(
    onFocusChange: (hasFocus) => setState(() => _isFocused = hasFocus),
    child: Container(
      decoration: BoxDecoration(
        border: _isFocused ? Border.all(color: Colors.white) : null
      ),
      // ...
    ),
  )
  ```

### B. UI/UX Standards
- **Theme:** `scaffoldBackgroundColor: Colors.black`. Text is always `Colors.white`.
- **Typography:** Clean, readable from a distance (TV interface).
- **Navigation:** Use `Navigator.push` with simple transitions. No complex nested routes for now.

### C. Data Logic Rules
- **Repository Pattern:** Logic for fetching videos resides in `lib/data/youtube_repository.dart`.
- **Shorts Blocker:** Inside the repository, ALWAYS filter out videos where `duration.inSeconds <= 60`.
- **Stream Extraction:** Use `yt.videos.streamsClient.getManifest(id)` to get the `muxed` stream URL.

## 4. Folder Structure
```text
lib/
├── core/          # Theme, Constants
├── data/          # Repositories (YoutubeRepository)
├── features/
│   ├── home/      # HomeScreen (Search Input)
│   ├── search/    # SearchScreen (Grid Results)
│   └── player/    # PlayerScreen (Video Playback)
└── main.dart
  ```

## 5. Interaction Style
When asked to code:
1. Provide the complete code for the specific file requested.
2. Ensure imports are correct for the project name `minimal_yt`.
3. Always check for "Android TV Focus" logic in the code provided.