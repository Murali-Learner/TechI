import 'package:tech_i/helper/constants.dart';
import 'package:tech_i/helper/enums.dart';
import 'package:tech_i/helper/exception.dart';
import 'package:tech_i/model/story.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:isolate';
import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit({
    this.newsType = NewsType.topStories,
    this.count = 10,
  }) : super(NewsInitial());

  NewsType newsType;
  int count;
  List<int> _allStoryIds = [];

  void setNewsType(NewsType type) {
    newsType = type;
    count = 10;
    fetchStories();
  }

  void setPageCount() async {
    final currentState = state;
    if (currentState is NewsLoaded && currentState is! MoreNewsLoading) {
      emit(MoreNewsLoading(currentState.stories));
      try {
        final List<Story> newStories = await _fetchStoriesFromIds(
          _allStoryIds.skip(currentState.stories.length).take(count).toList(),
        );
        final List<Story> allStories = List.from(currentState.stories)
          ..addAll(newStories);
        allStories.sort((a, b) => b.score.compareTo(a.score));
        emit(NewsLoaded(allStories));
      } catch (e) {
        emit(NewsError(e.toString()));
      }
    }
  }

  Future<void> fetchStories() async {
    emit(NewsLoading());
    try {
      if (_allStoryIds.isEmpty) {
        final response = await http.get(urlForStories(newsType));
        if (response.statusCode == 200) {
          _allStoryIds = List<int>.from(jsonDecode(response.body));
        } else {
          throw NewsException("Unable to fetch data! ${response.statusCode}");
        }
      }
      final List<Story> stories = await _fetchStoriesFromIds(
        _allStoryIds.take(count).toList(),
      );
      stories.sort((a, b) => b.score.compareTo(a.score));
      emit(NewsLoaded(stories));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  Future<void> fetchStory(int storyID) async {
    emit(NewsLoading());
    try {
      final Story story = await _fetchStoryInIsolate(storyID);
      emit(NewsLoaded([story]));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  Future<List<Story>> _fetchStoriesFromIds(List<int> storyIds) async {
    final responsePort = ReceivePort();
    await Isolate.spawn(
        _fetchStoriesIsolate, [responsePort.sendPort, storyIds]);

    return await responsePort.first;
  }

  static Future<void> _fetchStoriesIsolate(List<dynamic> args) async {
    SendPort sendPort = args[0];
    List<int> storyIds = args[1];

    try {
      final List<Story> stories =
          await Future.wait(storyIds.map((storyId) async {
        final response = await http.get(urlForStory(storyId));
        final json = jsonDecode(response.body);
        return Story.fromJson(json);
      }));
      sendPort.send(stories);
    } catch (e) {
      sendPort.send(e);
    }
  }

  Future<Story> _fetchStoryInIsolate(int storyId) async {
    final responsePort = ReceivePort();
    await Isolate.spawn(_fetchStoryIsolate, [responsePort.sendPort, storyId]);

    return await responsePort.first;
  }

  static Future<void> _fetchStoryIsolate(List<dynamic> args) async {
    SendPort sendPort = args[0];
    int storyId = args[1];

    try {
      final response = await http.get(urlForStory(storyId));
      final json = jsonDecode(response.body);
      final story = Story.fromJson(json);
      sendPort.send(story);
    } catch (e) {
      sendPort.send(e);
    }
  }
}
