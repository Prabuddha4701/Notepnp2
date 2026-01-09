// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pdf.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PdfDocsAdapter extends TypeAdapter<PdfDocs> {
  @override
  final int typeId = 4;

  @override
  PdfDocs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PdfDocs(
      collection: fields[0] as String,
      fileName: fields[1] as String,
      filePath: fields[2] as String,
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PdfDocs obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.collection)
      ..writeByte(1)
      ..write(obj.fileName)
      ..writeByte(2)
      ..write(obj.filePath)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PdfDocsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
