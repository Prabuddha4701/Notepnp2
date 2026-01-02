import 'package:hive/hive.dart';
import 'strokes.dart'; // ඔයාගේ Stroke class එක තියෙන file එක

part 'note.g.dart';

@HiveType(typeId: 2) // අංක 2 පාවිච්චි කරන්න
class DrawingNote extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  List<Stroke> strokes;

  @HiveField(2)
  DateTime date;

  DrawingNote({required this.title, required this.strokes, required this.date});
}
