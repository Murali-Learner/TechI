part of 'fav_cubit.dart';

class FavLoaded {
  final Map<int, Story> favStoryList;
  final bool isLoading;

  FavLoaded(this.favStoryList, this.isLoading);

  FavLoaded copyWith({
    Map<int, Story>? favStoryList,
    bool? isLoading,
  }) {
    return FavLoaded(
      favStoryList ?? this.favStoryList,
      isLoading ?? this.isLoading,
    );
  }
}
