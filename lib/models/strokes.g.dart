// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strokes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StrokeAdapter extends TypeAdapter<Stroke> {
  @override
  final int typeId = 1;

  @override
  Stroke read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Stroke(
      points: (fields[0] as List).cast<Customoffset>(),
      color: fields[1] as int,
      strokeWidth: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Stroke obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.points)
      ..writeByte(1)
      ..write(obj.color)
      ..writeByte(2)
      ..write(obj.strokeWidth);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StrokeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
