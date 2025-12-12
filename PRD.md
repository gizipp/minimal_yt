# Product Requirements Document (PRD)
**Project Name:** Minimal YT
**Platform:** Android TV
**Version:** 1.0.0
**Status:** In Development

## 1. Executive Summary
**Minimal YT** is a third-party YouTube client specifically designed for **Android TV**. 
**Core Philosophy:** "Dopamine Free". The application removes the algorithmic feed, "Shorts", comments, and sidebar recommendations. It forces an "Intentional Viewing" habit where users must search for what they want to watch.

## 2. Technical Stack
* **Framework:** Flutter (Dart)
* **Target OS:** Android TV (Min SDK 21) & macOS (for Development/Testing).
* **State Management:** `flutter_riverpod`
* **Data Source:** `youtube_explode_dart` (Scraping method, No API Key required).
* **Video Player:** `video_player` + `chewie` (or `media_kit` for advanced performance).
* **Design System:** Material 3 (Dark Mode Only).

## 3. Key Features & User Flow

### 3.1. The "Zen" Home (Landing Page)
* **Objective:** Eliminate decision fatigue and "doom scrolling".
* **UI Elements:**
    * Pure Black Background (`#000000`).
    * Centered Search Bar.
    * Minimalist Logo: "Minimal YT".
* **Behavior:**
    * On launch, the focus is immediately on the Search Bar.
    * **NO** Home Feed, **NO** Trending Tab, **NO** History list on start.

### 3.2. Search Results
* **Objective:** Display relevant content without distractions.
* **Logic:**
    * **Strict Filtering:** Automatically hide any video shorter than 60 seconds (Shorts) from results.
    * **Hide Live Streams:** (Optional) Focus on VOD content.
* **UI Elements:**
    * Grid View (3 columns on TV landscape).
    * Video Cards: Thumbnail, Title, Channel Name, Duration.
* **Navigation:**
    * Fully optimized for D-Pad (Up/Down/Left/Right).
    * Visual Feedback: Card scales up (1.05x) and gets a white border when focused.

### 3.3. The Player
* **Objective:** Distraction-free consumption.
* **UI Elements:**
    * Full-screen video playback.
    * Custom Overlay: Play/Pause, Seek Bar, Volume.
* **Restrictions:**
    * **NO** "Up Next" auto-play.
    * **NO** "Recommended Videos" overlay at the end.
    * **NO** Comments section.

## 4. Non-Functional Requirements
1.  **TV Navigation:** The app must be 100% navigable using a standard TV remote (D-Pad + Select + Back). Mouse/Touch support is irrelevant.
2.  **Performance:** Must run smoothly on low-end Android TV boxes (e.g., Mi Box S, Chromecast with Google TV).
3.  **Privacy:** No Google Login required. No watch history tracking stored on YouTube servers.

## 5. Future Roadmap (Out of Scope for v1)
* "Subscriptions" (Local storage only, no account login).
* 4K Video Support (requires rigorous codec handling).
* SponsorBlock integration.