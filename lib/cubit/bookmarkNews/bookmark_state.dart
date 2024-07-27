part of 'bookmark_cubit.dart';

class BookmarkLoaded {
  final Map<int, Story> bookmarkStoryList;
  final bool isLoading;

  BookmarkLoaded(this.bookmarkStoryList, this.isLoading);

  BookmarkLoaded copyWith({
    Map<int, Story>? bookmarkStoryList,
    bool? isLoading,
  }) {
    return BookmarkLoaded(
      bookmarkStoryList ?? this.bookmarkStoryList,
      isLoading ?? this.isLoading,
    );
  }
}
