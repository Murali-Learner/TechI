import 'package:tech_i/model/story.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class MoreNewsLoading extends NewsState {
  final Map<int, Story> stories;

  MoreNewsLoading(this.stories);
}

class NewsLoaded extends NewsState {
  final Map<int, Story> stories;

  NewsLoaded(this.stories);
  NewsLoaded copyWith({Map<int, Story>? stories}) {
    return NewsLoaded(stories ?? this.stories);
  }
}

class NewsError extends NewsState {
  final String message;

  NewsError(this.message);
}
