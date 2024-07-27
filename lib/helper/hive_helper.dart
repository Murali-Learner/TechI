import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:TechI/model/story.dart';

class HiveHelper {
  static const String favNewsBoxName = 'favNews';
  static const String storyIdsBoxName = 'cacheNews';
  static Box? _bookmarkBox;
  static Box? _cacheBox;
  static final HiveHelper _hiveHelper = HiveHelper._internal();
  factory HiveHelper() {
    return _hiveHelper;
  }
  HiveHelper._internal();

  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(StoryAdapter());
    await Hive.openBox<Story>(favNewsBoxName);
    await Hive.openBox<Story>(storyIdsBoxName);
    _bookmarkBox = Hive.box<Story>(favNewsBoxName);
    _cacheBox = Hive.box<Story>(storyIdsBoxName);
  }

  static Future<void> addToBookmark(Story story) async {
    await _bookmarkBox?.put(story.id, story);
  }

  static void addCacheStory(Story story) async {
    final Map<int, Story> cacheMap = getCacheStories();
    debugPrint("cacheMap ${cacheMap.length}");

    if (cacheMap.containsKey(story.id)) {
      await removeFromCache(story.id);
      await _cacheBox?.put(story.id, story);
    } else {
      await _cacheBox?.put(story.id, story);
    }
  }

  static Box getBox() {
    print("cache box here");
    return _cacheBox!;
  }

  static Map<int, Story> getCacheStories() {
    final Map<int, Story> cacheMap = {};
    for (Story story in (_cacheBox?.values ?? [])) {
      cacheMap[story.id] = story;
    }

    debugPrint("bookmarks Stories ${getBookStories().length}");

    return cacheMap;
  }

  static Map<int, Story> getBookStories() {
    final Map<int, Story> bookmarkMap = {};
    for (Story story in (_cacheBox?.values ?? [])) {
      if (story.isBookmark) {
        bookmarkMap[story.id] = story.copyWith(isBookmark: true);
      }
    }
    print("bookmarkMap ${bookmarkMap.length}");
    return bookmarkMap;
  }

  static Future<void> removeFromBookmarks(int storyId) async {
    await _bookmarkBox?.delete(storyId);
  }

  static Future<void> removeFromCache(int storyId) async {
    await _cacheBox?.delete(storyId);
  }

  static Map<int, Story> getBookmarkStories() {
    final Map<int, Story> bookmarkStoryMap = {};

    for (Story story in (_bookmarkBox?.values ?? [])) {
      bookmarkStoryMap[story.id] = story;
    }

    return bookmarkStoryMap;
  }

  static bool isCached(int id) {
    debugPrint("isCached ${_cacheBox?.get(id) != null}");
    return _cacheBox?.get(id) != null;
  }

  static bool isFav(int id) {
    // final stories = getFavoriteStories();

    // stories.values.forEach((ele) {
    // print("insideBox ${ele.id} ${ele.isFav}}");
    // });
    print("I got ${id} this ${_bookmarkBox?.get(id)}");
    return _bookmarkBox?.get(id) != null;
  }
}
