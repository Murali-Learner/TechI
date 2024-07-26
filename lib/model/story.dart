import 'package:hive/hive.dart';
import 'package:tech_i/helper/hive_helper.dart';
part 'story.g.dart';

@HiveType(typeId: 0)
class Story {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final bool deleted;
  @HiveField(2)
  final String type;
  @HiveField(3)
  final String by;
  @HiveField(4)
  final int time;
  @HiveField(5)
  final bool dead;
  @HiveField(6)
  final List<int> kids;
  @HiveField(7)
  final int descendants;
  @HiveField(8)
  final int score;
  @HiveField(9)
  final String title;
  @HiveField(10)
  final String url;
  @HiveField(11)
  final bool isFav;

  Story({
    required this.id,
    required this.deleted,
    required this.type,
    required this.by,
    required this.time,
    required this.dead,
    required this.kids,
    required this.descendants,
    required this.score,
    required this.title,
    required this.url,
    this.isFav = false,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] ?? 0,
      deleted: json['deleted'] ?? false,
      type: json['type'] ?? '',
      by: json["by"] ?? '',
      time: json["time"] ?? 0,
      dead: json["dead"] ?? false,
      descendants: json["descendants"] ?? 0,
      score: json["score"] ?? 0,
      title: json["title"] ?? '',
      url: json["url"] ?? '',
      kids: json["kids"]?.cast<int>() ?? [],
      isFav: HiveHelper.isFav(json["id"] ?? 0),
    );
  }

  Story copyWith({
    int? id,
    bool? deleted,
    String? type,
    String? by,
    int? time,
    bool? dead,
    List<int>? kids,
    int? descendants,
    int? score,
    String? title,
    String? url,
    bool? isFav,
  }) {
    return Story(
      id: id ?? this.id,
      deleted: deleted ?? this.deleted,
      type: type ?? this.type,
      by: by ?? this.by,
      time: time ?? this.time,
      dead: dead ?? this.dead,
      kids: kids ?? this.kids,
      descendants: descendants ?? this.descendants,
      score: score ?? this.score,
      title: title ?? this.title,
      url: url ?? this.url,
      isFav: isFav ?? this.isFav,
    );
  }
}
