import 'package:TechI/helper/enums.dart';

extension NewsTypeExtension on NewsType {
  String get displayName {
    switch (this) {
      case NewsType.topStories:
        return 'Top';
      case NewsType.newStories:
        return 'New';
      case NewsType.bestStories:
        return 'Best';

      default:
        return '';
    }
  }
}
