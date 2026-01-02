import 'package:flutter/material.dart';
import 'package:notepnp/Drawingscreen.dart';
import 'package:notepnp/models/note.dart';
import 'package:notepnp/models/offset.dart';
import 'package:notepnp/models/strokes.dart';
import 'Spalshscreen.dart';
import 'Home.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(StrokeAdapter());
  Hive.registerAdapter(CustomoffsetAdapter());
  Hive.registerAdapter(DrawingNoteAdapter());

  await Hive.openBox<DrawingNote>('notes_box');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
      initialRoute: '/',
      routes: {
        '/': (context) => Spalshscreen(),
        '/home': (context) => Homescreen(),
        '/draw': (context) => Drawingscreen(),
      },
    );
  }
}
