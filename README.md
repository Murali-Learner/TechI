# TechI

TechI is a mobile application built with Flutter that brings you the latest and most relevant tech news. The app uses the Hacker News original APIs to fetch news articles, providing a seamless and engaging user experience. Features include efficient state management with Bloc, dark and light theme switching, in-app webview for reading articles, caching with Hive DB to avoid repetitive API calls, and bookmark support to save articles for later reading.

## Features

- **Tech News**: Fetches the latest tech news from Hacker News with pagination for smooth browsing.
- **State Management**: Utilizes the Bloc pattern for efficient state management.
- **Theming**: Switch between dark and light themes to match your preference.
- **In-App WebView**: View entire articles within the app itself.
- **Efficient HTTP Calls**: Uses isolates for HTTP calls to avoid disturbing the main thread during API calls.
- **Caching**: Implemented caching with Hive DB to avoid repetitive API calls, storing news articles by their IDs for faster retrieval.
- **Bookmark Support**: Allows users to bookmark news articles using Hive DB, so they can easily save and read them later.

https://github.com/user-attachments/assets/196a67d1-2544-47f0-b267-5eba8b8a5f48

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/) SDK
- [Dart](https://dart.dev/) SDK

### Installation

1. Clone the repository:

   ```sh
   git clone https://github.com/Murali-Learner/TechI.git
   cd TechI
   ```

2. Install the dependencies:

   ```sh
   flutter pub get
   ```

3. Run the app:
   ```sh
   flutter run
   ```

## Usage

- Open the app to see the latest tech news.
- Switch between dark and light themes from the settings menu.
- Tap on any news article to read it in the in-app webview.
- Click on the bookmark icon on each news article to save it for later reading.
- Click on the top right bookmark icon to view your saved bookmarks.

## Built With

- [Flutter](https://flutter.dev/) - The UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
- [Dart](https://dart.dev/) - The programming language for Flutter.
- [Hacker News API](https://github.com/HackerNews/API) - The API used to fetch the latest tech news.
- [Bloc](https://bloclibrary.dev/#/) - State management library.
- [Hive](https://docs.hivedb.dev/#/) - A lightweight and fast key-value database for Flutter applications.

## Contributing

This project is open for contributions. Feel free to submit a pull request or open an issue.

## Releases

Check out the latest release [here](https://github.com/Murali-Learner/TechI/releases/tag/v.1.0.0).

## Acknowledgments

- Special thanks to the [Hacker News API](https://github.com/HackerNews/API) community for their amazing resources and support.
