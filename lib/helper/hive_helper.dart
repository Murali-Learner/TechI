import 'package:hive_flutter/adapters.dart';
import 'package:flutter/material.dart';
import 'package:tech_i/model/story.dart';

class HiveHelper {
  static const String favNewsBoxName = 'favNews';
  static Box? _box;

  static final HiveHelper _hiveHelper = HiveHelper._internal();
  factory HiveHelper() {
    return _hiveHelper;
  }
  HiveHelper._internal();

  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(StoryAdapter());
    await Hive.openBox<Story>(favNewsBoxName);
    _box = Hive.box<Story>(favNewsBoxName);
  }

  static Future<void> addToFavorites(Story story) async {
    await _box?.put(story.id, story);
  }

  static Future<void> removeFromFavorites(int storyId) async {
    await _box?.delete(storyId);
  }

  static Map<int, Story> getFavoriteStories() {
    final Map<int, Story> favStoryList = {};

    for (Story story in (_box?.values ?? [])) {
      favStoryList[story.id] = story;
      // print("Is fav val ${story.id} ${story.isFav}");
    }

    debugPrint("favStoryList ${favStoryList.length}");

    return favStoryList;
  }

  static bool isFav(int id) {
    final stories = getFavoriteStories();

    stories.values.forEach((ele) {
      // print("insideBox ${ele.id} ${ele.isFav}}");
    });
    // print("I got ${id} this ${_box?.get(id)}");
    return _box?.get(id) != null;
  }
}
