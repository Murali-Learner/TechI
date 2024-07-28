// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoryAdapter extends TypeAdapter<Story> {
  @override
  final int typeId = 0;

  @override
  Story read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Story(
      id: fields[0] as int,
      deleted: fields[1] as bool,
      type: fields[2] as String,
      by: fields[3] as String,
      time: fields[4] as int,
      dead: fields[5] as bool,
      kids: (fields[6] as List).cast<int>(),
      descendants: fields[7] as int,
      score: fields[8] as int,
      title: fields[9] as String,
      url: fields[10] as String,
      isBookmark: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Story obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.deleted)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.by)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.dead)
      ..writeByte(6)
      ..write(obj.kids)
      ..writeByte(7)
      ..write(obj.descendants)
      ..writeByte(8)
      ..write(obj.score)
      ..writeByte(9)
      ..write(obj.title)
      ..writeByte(10)
      ..write(obj.url)
      ..writeByte(11)
      ..write(obj.isBookmark);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
