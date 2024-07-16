import 'enums.dart';

Uri urlForStory(int storyId) {
  return Uri.parse("https://hacker-news.firebaseio.com/v0/item/$storyId.json");
}

Uri urlForStories(NewsType newsType) {
  return Uri.parse(
    newsType == NewsType.topStories
        ? "https://hacker-news.firebaseio.com/v0/topstories.json"
        : newsType == NewsType.bestStories
            ? "https://hacker-news.firebaseio.com/v0/beststories.json"
            : "https://hacker-news.firebaseio.com/v0/newstories.json",
  );
}
