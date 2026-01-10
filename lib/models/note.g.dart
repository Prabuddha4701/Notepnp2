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
      collection: fields[0] as String,
      title: fields[1] as String,
      fileName: fields[2] as String,
      date: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DrawingNote obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.collection)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.fileName)
      ..writeByte(3)
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
