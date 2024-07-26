import 'package:flutter/material.dart';
import 'package:tech_i/helper/constants.dart';
import 'package:tech_i/helper/enums.dart';
import 'package:tech_i/helper/hive_helper.dart';
import 'package:tech_i/model/story.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:isolate';
import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit({
    this.newsType = NewsType.topStories,
    this.pageSize = 15,
  }) : super(NewsInitial());

  NewsType newsType;
  int pageSize;
  List<int> allStoryIds = [];
  int currentPage = 0;
  Map<int, Story> favNews = {};

  void setNewsType(NewsType type) {
    newsType = type;

    fetchStories();
  }

  void setPageCount() async {
    var currentState = state;
    if (currentState is NewsLoaded && currentState is! MoreNewsLoading) {
      emit(MoreNewsLoading(currentState.stories));
      try {
        final Map<int, Story> newStories = await _fetchStoriesFromIds(
            allStoryIds, currentPage * pageSize, pageSize);
        currentPage++;
        currentState = currentState.copyWith(stories: {
          ...currentState.stories,
          ...newStories,
        });
        emit(currentState);
        debugPrint("allStories ${currentState.stories.length}");
      } catch (e) {
        emit(NewsError(e.toString()));
      }
    }
  }

  Future<void> fetchStories() async {
    emit(NewsLoading());
    try {
      allStoryIds = await _fetchStoryIdsInIsolate(newsType);
      currentPage = 0;
      final Map<int, Story> stories = await _fetchStoriesFromIds(
          allStoryIds, currentPage * pageSize, pageSize);
      currentPage++;
      emit(NewsLoaded(stories));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  Future<void> fetchStory(int storyID) async {
    try {
      if (state is NewsLoaded) {
        final Story story = await _fetchStoryInIsolate(storyID);
        NewsLoaded loadedState = state as NewsLoaded;
        loadedState = loadedState.copyWith(stories: {
          ...loadedState.stories,
          storyID: story,
        });
        emit(loadedState);
      }
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  Future<void> toggleFavorite(Story story) async {
    if (state is NewsLoaded) {
      NewsLoaded loadedState = state as NewsLoaded;
      if (loadedState.stories.containsKey(story.id)) {
        loadedState = loadedState.copyWith(stories: {
          ...loadedState.stories,
          story.id: story.copyWith(isFav: !story.isFav),
        });
        emit(loadedState);
      }
    }
  }

  Future<List<int>> _fetchStoryIdsInIsolate(NewsType type) async {
    final responsePort = ReceivePort();
    await Isolate.spawn(_fetchStoryIdsIsolate, [responsePort.sendPort, type]);
    final port = await responsePort.first;

    if (port is Map && port['success'] == true) {
      return List<int>.from(port['storyIds']);
    } else if (port is Map && port['success'] == false) {
      throw Exception(port['error']);
    } else {
      throw Exception("Unexpected data received from isolate");
    }
  }

  static Future<void> _fetchStoryIdsIsolate(List<dynamic> args) async {
    SendPort sendPort = args[0];
    NewsType type = args[1];
    try {
      final response = await http.get(urlForStories(type));

      if (response.statusCode == 200) {
        final storyIds = List<int>.from(jsonDecode(response.body));

        sendPort.send({'success': true, 'storyIds': storyIds});
      } else {
        sendPort.send({
          'success': false,
          'error': 'Unable to fetch data! ${response.statusCode}'
        });
      }
    } catch (e) {
      sendPort.send(
        {'success': false, 'error': e.toString()},
      );
    }
  }

  Future<Map<int, Story>> _fetchStoriesFromIds(
    List<int> storyIds,
    int startIndex,
    int count,
  ) async {
    final idsToFetch = storyIds.skip(startIndex).take(count).toList();

    Map<int, Story> stories = {};
    for (final id in idsToFetch) {
      stories[id] = await _fetchStoryInIsolate(id);
    }

    return Future.value(stories);
  }

  Future<Story> _fetchStoryInIsolate(int storyId) async {
    final responsePort = ReceivePort();
    final stories = HiveHelper.getFavoriteStories();
    await Isolate.spawn(
        _fetchStoryIsolate, [responsePort.sendPort, storyId, stories]);
    final port = await responsePort.first;
    if (port is Map && port['success'] == true) {
      return port['story'];
    } else if (port is Map && port['success'] == false) {
      throw Exception(port['error']);
    } else {
      throw Exception("Unexpected data received from isolate");
    }
  }

  static Future<void> _fetchStoryIsolate(List<dynamic> args) async {
    SendPort sendPort = args[0];
    int storyId = args[1];
    Map<int, Story> stories = args[2];
    try {
      final response = await http.get(urlForStory(storyId));

      if (response.statusCode == 200 && response.body != "null") {
        final json = jsonDecode(response.body);
        Story story = Story.fromJson(json);
        story = story.copyWith(isFav: stories.containsKey(story.id));
        // debugPrint("story ${story}");
        sendPort.send({'success': true, 'story': story});
      } else {
        sendPort.send({
          'success': false,
          'error': 'Unable to fetch story! ${response.statusCode}'
        });
      }
    } catch (e) {
      sendPort.send({'success': false, 'error': e.toString()});
    }
  }
}
