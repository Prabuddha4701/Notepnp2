import 'package:flutter/material.dart';

import 'package:notepnp/models/note.dart';

import 'package:notepnp/models/textnote.dart';
import 'Spalshscreen.dart';
import 'Home.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(DrawingNoteAdapter());
  Hive.registerAdapter(TextNoteAdapter());

  await Hive.openBox<DrawingNote>('drawing_notes_box');
  await Hive.openBox<TextNote>('text_note_box');

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
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
    );
  }
}
