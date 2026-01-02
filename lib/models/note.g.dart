// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DrawingNoteAdapter extends TypeAdapter<DrawingNote> {
  @override
  final int typeId = 2;

  @override
  DrawingNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DrawingNote(
      title: fields[0] as String,
      strokes: (fields[1] as List).cast<Stroke>(),
      date: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DrawingNote obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.strokes)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrawingNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
