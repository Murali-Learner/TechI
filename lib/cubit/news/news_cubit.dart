import 'package:flutter/material.dart';
import 'package:tech_i/helper/constants.dart';
import 'package:tech_i/helper/enums.dart';
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

  void setNewsType(NewsType type) {
    newsType = type;
    fetchStories();
  }

  void setPageCount() async {
    final currentState = state;
    if (currentState is NewsLoaded && currentState is! MoreNewsLoading) {
      emit(MoreNewsLoading(currentState.stories));
      try {
        final List<Story> newStories = await _fetchStoriesFromIds(
            allStoryIds, currentPage * pageSize, pageSize);
        currentPage++;
        final List<Story> allStories = List.from(currentState.stories)
          ..addAll(newStories);
        debugPrint("allStories ${allStories.length}");
        emit(NewsLoaded(allStories));
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
      final List<Story> stories = await _fetchStoriesFromIds(
          allStoryIds, currentPage * pageSize, pageSize);
      currentPage++;
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

  Future<List<Story>> _fetchStoriesFromIds(
      List<int> storyIds, int startIndex, int count) async {
    final idsToFetch = storyIds.skip(startIndex).take(count).toList();

    final stories = await Future.wait(idsToFetch.map((id) async {
      try {
        return await _fetchStoryInIsolate(id);
      } catch (e) {
        return null;
      }
    }));

    return stories.where((story) => story != null).cast<Story>().toList();
  }

  Future<Story> _fetchStoryInIsolate(int storyId) async {
    final responsePort = ReceivePort();
    await Isolate.spawn(_fetchStoryIsolate, [responsePort.sendPort, storyId]);
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

    try {
      final response = await http.get(urlForStory(storyId));

      if (response.statusCode == 200 && response.body != "null") {
        final json = jsonDecode(response.body);
        final story = Story.fromJson(json);
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
