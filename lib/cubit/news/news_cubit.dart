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

  void setNewsType(NewsType type) {
    newsType = type;
    fetchStories();
  }

  void setPageCount() async {
    final currentState = state;
    if (currentState is NewsLoaded && currentState is! MoreNewsLoading) {
      emit(MoreNewsLoading(currentState.stories));
      try {
        final List<Story> newStories =
            await _fetchStoriesInIsolate(newsType, count + 10);
        final List<Story> allStories = List.from(currentState.stories)
          ..addAll(newStories);
        count += 10;
        emit(NewsLoaded(allStories));
      } catch (e) {
        emit(NewsError(e.toString()));
      }
    }
  }

  Future<void> fetchStories() async {
    emit(NewsLoading());
    try {
      final List<Story> stories = await _fetchStoriesInIsolate(newsType, count);
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

  Future<List<Story>> _fetchStoriesInIsolate(NewsType type, int count) async {
    final responsePort = ReceivePort();
    await Isolate.spawn(
        _fetchStoriesIsolate, [responsePort.sendPort, type, count]);

    return await responsePort.first;
  }

  static Future<void> _fetchStoriesIsolate(List<dynamic> args) async {
    SendPort sendPort = args[0];
    NewsType type = args[1];
    int count = args[2];
    // debugPrint("url for stories ${urlForStories(type)}");
    try {
      final response = await http.get(urlForStories(type));

      if (response.statusCode == 200) {
        Iterable storyIds = jsonDecode(response.body);

        final List<Story> stories =
            await Future.wait(storyIds.take(count).map((storyId) async {
          final response = await http.get(urlForStory(storyId));
          // debugPrint("response $response");
          final json = jsonDecode(response.body);
          // debugPrint("json Data $json");
          return Story.fromJson(json);
        }));
        // debugPrint("stories length ${stories.length}");
        sendPort.send(stories);
      } else {
        throw NewsException("Unable to fetch data! ${response.statusCode}");
      }
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
