# Infinite Image Gallery

A Flutter image gallery application built using Flutter, Dart, GetX, and the Pixabay API.

## Features

- Responsive image grid
- Infinite scrolling and pagination
- Search and category filters
- Image detail screen
- Download images to device Gallery
- Favorites
- Loading and error handling
- Image sharing

## Prerequisites

- Flutter SDK
- Android Studio or VS Code
- A valid Pixabay API key

## Setup Instructions

Clone the repository:

```bash
git clone https://github.com/Karthika2623/infinite-image-gallery.git
cd infinite-image-gallery
```

Install dependencies:

```bash
flutter pub get
```

### Configure the Pixabay API Key

Run the application with your own valid Pixabay API key:

```bash
flutter run --dart-define=PIXABAY_API_KEY=58019871-21017482383b7e02d6be0d25f
```

Replace `YOUR_PIXABAY_API_KEY` with your valid API key.

**Security:** Do not commit API keys or other secrets to the repository.

## Build APK

```bash
flutter build apk --release --dart-define=PIXABAY_API_KEY=58019871-21017482383b7e02d6be0d25f
```

APK output path:

`build/app/outputs/flutter-apk/app-release.apk`

## Architecture and State Management

The application uses GetX for state management and separates responsibilities into:

- Views: UI screens
- Controllers: UI state and user interactions
- Bindings: Dependency injection
- Models: Photo data representation
- Services: Pixabay API communication
- Repositories: Data access
- Shared widgets: Reusable UI components

## API

Pixabay API: https://pixabay.com/api/

## Screenshots / Demo




https://github.com/user-attachments/assets/edc760cc-8127-4904-aba6-c327bfca2f93




## Assumptions and Limitations

- A valid Pixabay API key and internet connection are required to fetch images.
- Image availability depends on the Pixabay API.
- The app should be tested on the target Android device before submission.
- Any remaining issues or incomplete features should be documented here.
