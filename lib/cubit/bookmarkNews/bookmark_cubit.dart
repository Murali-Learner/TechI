import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:TechI/helper/hive_helper.dart';
import 'package:TechI/model/story.dart';

part 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkLoaded> {
  BookmarkCubit() : super(BookmarkLoaded({}, false));

  Future<void> toggleBookMark(Story story) async {
    final Story updateStory = story.copyWith(isBookmark: !story.isBookmark);
    BookmarkLoaded loadedState = state;
    final updatedFavorites = {...loadedState.bookmarkStoryList};
    try {
      if (updateStory.isBookmark) {
        await HiveHelper.addToBookmark(updateStory);
        updatedFavorites[story.id] = updateStory;
      } else {
        updatedFavorites.remove(story.id);
        await HiveHelper.removeFromBookmarks(story.id);
      }
      loadedState = loadedState.copyWith(bookmarkStoryList: updatedFavorites);
      emit(loadedState);
    } catch (e) {
      emit(BookmarkLoaded(state.bookmarkStoryList, false));
    }
  }

  Future<void> fetchBookmarkStories() async {
    try {
      final stories = HiveHelper.getBookmarkStories();

      emit(BookmarkLoaded(stories, false));
    } catch (e) {
      emit(BookmarkLoaded(state.bookmarkStoryList, false));
    }
  }
}
