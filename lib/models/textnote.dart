import 'package:hive/hive.dart';

part 'textnote.g.dart';

@HiveType(typeId: 3)
class TextNote extends HiveObject {
  @HiveField(0)
  String collection;

  @HiveField(1)
  String title;

  @HiveField(2)
  String fileName;

  @HiveField(3)
  DateTime date;

  TextNote({
    required this.collection,
    required this.title,
    required this.fileName,
    required this.date,
  });
}
