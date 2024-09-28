import 'dart:convert';
import 'dart:isolate';

import 'package:TechI/helper/constants.dart';
import 'package:TechI/helper/enums.dart';
import 'package:TechI/helper/hive_helper.dart';
import 'package:TechI/model/story.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit({
    this.newsType = NewsType.topStories,
  }) : super(NewsInitial());

  NewsType newsType;
  int pageSize = 12;
  List<int> allStoryIds = [];
  int currentPage = 0;
  Map<int, Story> favNews = {};

  void setNewsType(NewsType type) {
    newsType = type;
    fetchStories();
  }

  void setPageSize(int size) {
    if (pageSize > 0) pageSize = size;
    debugPrint("set page size ${pageSize}");
  }

  void loadMoreNews() async {
    var currentState = state;
    if (currentState is NewsLoaded && currentState is! MoreNewsLoading) {
      emit(MoreNewsLoading(currentState.stories));
      try {
        final stopwatch = Stopwatch()..start();
        final Map<int, Story> newStories = await _fetchStoriesFromIds(
          allStoryIds,
          currentPage * pageSize,
          pageSize,
        );
        currentPage++;
        currentState = currentState.copyWith(stories: {
          ...currentState.stories,
          ...newStories,
        });
        emit(currentState);
        debugPrint(
            "allStories  ${stopwatch.elapsed} ${currentState.stories.length}");
        stopwatch.reset();
      } catch (e) {
        emit(NewsError(e.toString()));
      }
    }
  }

  Future<void> fetchStories() async {
    if (isClosed) return;
    emit(NewsLoading());
    try {
      final stopwatch = Stopwatch()..start();
      allStoryIds = await _fetchStoryIdsInIsolate(newsType);
      currentPage = 0;
      debugPrint("allStoryIds ${allStoryIds.length}");
      final Map<int, Story> stories = await _fetchStoriesFromIds(
        allStoryIds,
        currentPage * pageSize,
        pageSize,
      );
      currentPage++;
      debugPrint(' executed in ${stopwatch.elapsed}');

      if (!isClosed) {
        debugPrint(' executed in ${stopwatch.elapsed}');
        emit(NewsLoaded(stories));
      }
    } catch (e) {
      if (!isClosed) {
        emit(NewsError(e.toString()));
      }
    }
  }

  Future<void> fetchStory(int storyID) async {
    try {
      if (state is NewsLoaded) {
        final Story? story = await _fetchStoryInIsolate(storyID);
        NewsLoaded loadedState = state as NewsLoaded;
        loadedState = loadedState.copyWith(stories: {
          ...loadedState.stories,
          storyID: story!,
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
      final Story cacheStory = story.copyWith(isBookmark: !story.isBookmark);

      if (loadedState.stories.containsKey(story.id)) {
        loadedState = loadedState.copyWith(stories: {
          ...loadedState.stories,
          story.id: cacheStory,
        });

        HiveHelper.addCacheStory(cacheStory);
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
    final futures = idsToFetch.map((id) => _fetchStoryInIsolate(id));
    final results = await Future.wait(futures);

    for (var i = 0; i < idsToFetch.length; i++) {
      if (results[i] != null && results[i]!.url.isNotEmpty) {
        stories[idsToFetch[i]] = results[i]!;
      }
    }
    debugPrint("results ${results.length} ${stories.length}");
    return stories;
  }

  Future<Story?> _fetchStoryInIsolate(int storyId) async {
    final bookmarkStories = HiveHelper.getBookmarkStories();

    if (!HiveHelper.isCached(storyId)) {
      final Story? story = await fetchStoryIsolate(storyId, bookmarkStories);

      debugPrint("isBookmark ${story!.isBookmark}");

      HiveHelper.addCacheStory(story);

      return story;
    } else {
      final story = HiveHelper.getCacheStories()[storyId]!;
      debugPrint("isBookmark ${story.isBookmark}");

      return story;
    }
  }

  static Future<Story?> fetchStoryIsolate(
      int storyId, Map<int, Story> bookmarks) async {
    try {
      final response = await http.get(urlForStory(storyId));

      if (response.statusCode == 200 && response.body != "null") {
        final json = jsonDecode(response.body);
        Story story = Story.fromJson(json);

        if (story.url.isNotEmpty) {
          story = story.copyWith(isBookmark: bookmarks.containsKey(story.id));
          return story;
        } else {
          debugPrint("Skipping story $storyId due to empty URL");
          return null;
        }
      } else {
        debugPrint("Error in fetching story");
        return null;
      }
    } catch (e) {
      debugPrint("Error in fetching story $e");
      throw Exception(e.toString());
    }
  }
}
