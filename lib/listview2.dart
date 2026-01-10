import 'package:flutter/material.dart';
import 'package:notepnp/Drawingscreen.dart';
import 'package:notepnp/models/note.dart';

import 'package:hive_flutter/hive_flutter.dart';

class CollectionDrawings extends StatelessWidget {
  final String collectionName;
  const CollectionDrawings({super.key, required this.collectionName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Notes")),
      body: ValueListenableBuilder<Box<DrawingNote>>(
        valueListenable: Hive.box<DrawingNote>(
          "drawing_notes_box",
        ).listenable(),
        builder: (context, Box<DrawingNote> box, _) {
          final allNotes = box.values
              .where((note) => note.collection == collectionName)
              .toList();

          return ListView.builder(
            itemCount: allNotes.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2,
                child: ListTile(
                  leading: Icon(Icons.folder),
                  title: Text(allNotes[index].title),
                  trailing: Icon(Icons.abc_rounded),
                  onTap: () {
                    print(allNotes[index].fileName);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Drawingscreen(
                            fileName: allNotes[index].fileName,
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
