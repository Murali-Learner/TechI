import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_i/helper/hive_helper.dart';
import 'package:tech_i/model/story.dart';

part 'fav_state.dart';

class FavCubit extends Cubit<FavLoaded> {
  FavCubit() : super(FavLoaded({}, false));

  Future<void> toggleBookMark(Story story) async {
    final Story updateStory = story.copyWith(isFav: !story.isFav);
    FavLoaded loadedState = state;
    final updatedFavorites = {...loadedState.favStoryList};
    try {
      if (updateStory.isFav) {
        await HiveHelper.addToFavorites(updateStory);
        updatedFavorites[story.id] = updateStory;
      } else {
        updatedFavorites.remove(story.id);
        await HiveHelper.removeFromFavorites(story.id);
      }
      loadedState = loadedState.copyWith(favStoryList: updatedFavorites);
      emit(loadedState);
    } catch (e) {
      emit(FavLoaded(state.favStoryList, false));
    }
  }

  Future<void> fetchFavoriteStories() async {
    try {
      final stories = HiveHelper.getFavoriteStories();

      emit(FavLoaded(stories, false));
    } catch (e) {
      emit(FavLoaded(state.favStoryList, false));
    }
  }
}
