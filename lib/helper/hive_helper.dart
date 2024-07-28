import 'package:hive_flutter/adapters.dart';
import 'package:TechI/model/story.dart';

class HiveHelper {
  static const String cacheIdsBoxName = 'cacheNews';
  static Box? _cacheBox;
  static final HiveHelper _hiveHelper = HiveHelper._internal();
  factory HiveHelper() {
    return _hiveHelper;
  }
  HiveHelper._internal();

  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(StoryAdapter());
    await Hive.openBox<Story>(cacheIdsBoxName);
    _cacheBox = Hive.box<Story>(cacheIdsBoxName);
  }

  static void addCacheStory(Story story) async {
    final Map<int, Story> cacheMap = getCacheStories();
    // debugPrint("cacheMap ${cacheMap.length}");

    if (cacheMap.containsKey(story.id)) {
      await removeFromCache(story.id);
      await _cacheBox?.put(story.id, story);
    } else {
      await _cacheBox?.put(story.id, story);
    }
  }

  static Box getBox() {
    // print("cache box here");
    return _cacheBox!;
  }

  static Map<int, Story> getCacheStories() {
    final Map<int, Story> cacheMap = {};
    for (Story story in (_cacheBox?.values ?? [])) {
      cacheMap[story.id] = story;
    }

    // debugPrint("bookmarks Stories ${getBookmarkStories().length}");

    return cacheMap;
  }

  static Map<int, Story> getBookmarkStories() {
    final Map<int, Story> bookmarkMap = {};
    for (Story story in (_cacheBox?.values ?? [])) {
      if (story.isBookmark) {
        bookmarkMap[story.id] = story.copyWith(isBookmark: true);
      }
    }
    // print("bookmarkMap ${bookmarkMap.length}");
    return bookmarkMap;
  }

  static Future<void> removeFromCache(int storyId) async {
    await _cacheBox?.delete(storyId);
  }

  static bool isCached(int id) {
    // debugPrint("isCached ${_cacheBox?.get(id) != null}");
    return _cacheBox?.get(id) != null;
  }

  static Story getStory(int id) {
    // debugPrint("getStory ${_cacheBox?.get(id)}");
    return _cacheBox?.get(id)! as Story;
  }

  static bool isFav(int id) {
    final story =
        _cacheBox?.get(id) != null ? _cacheBox?.get(id) as Story : null;

    return story != null && story.isBookmark;
  }
}
