import 'package:flutter/material.dart';
import 'package:notepnp/models/textnote.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notepnp/TextEditor.dart';

class CollectionNotes extends StatelessWidget {
  final String collectionName;
  const CollectionNotes({super.key, required this.collectionName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Notes")),
      body: ValueListenableBuilder<Box<TextNote>>(
        valueListenable: Hive.box<TextNote>("text_note_box").listenable(),
        builder: (context, Box<TextNote> box, _) {
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TextEditorContainer(
                          fileName: allNotes[index].fileName,
                        ),
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
