import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 2) // අංක 2 පාවිච්චි කරන්න
class DrawingNote extends HiveObject {
  @HiveField(0)
  String collection;

  @HiveField(1)
  String title;

  @HiveField(2)
  String fileName;

  @HiveField(3)
  DateTime date;

  DrawingNote({
    required this.collection,
    required this.title,
    required this.fileName,
    required this.date,
  });
}
