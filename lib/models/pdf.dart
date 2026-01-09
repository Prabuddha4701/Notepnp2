import 'package:hive/hive.dart';

part 'pdf.g.dart';

@HiveType(typeId: 4)
class PdfDocs extends HiveObject {
  @HiveField(0)
  String collection;

  @HiveField(1)
  String fileName;

  @HiveField(2)
  String filePath;

  @HiveField(3)
  DateTime createdAt;

  PdfDocs({
    required this.collection,
    required this.fileName,
    required this.filePath,
    required this.createdAt,
  });
}
