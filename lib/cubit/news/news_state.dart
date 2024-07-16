import 'package:tech_i/model/story.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class MoreNewsLoading extends NewsState {
  final List<Story> stories;

  MoreNewsLoading(this.stories);
}

class NewsLoaded extends NewsState {
  final List<Story> stories;

  NewsLoaded(this.stories);
}

class NewsError extends NewsState {
  final String message;

  NewsError(this.message);
}
