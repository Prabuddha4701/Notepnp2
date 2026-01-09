// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'textnote.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TextNoteAdapter extends TypeAdapter<TextNote> {
  @override
  final int typeId = 3;

  @override
  TextNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TextNote(
      collection: fields[0] as String,
      title: fields[1] as String,
      fileName: fields[2] as String,
      date: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TextNote obj) {
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
      other is TextNoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
