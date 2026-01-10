import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:notepnp/Drawingscreen.dart';
import 'package:notepnp/models/note.dart';
import 'package:notepnp/models/textnote.dart';
import 'package:notepnp/texteditor.dart';
import 'package:notepnp/listview.dart';
import 'package:notepnp/listview2.dart';

enum Tabs { handwriting, text, pdf }

class Homescreen extends StatelessWidget {
  final ValueNotifier<Tabs> currentTab = ValueNotifier<Tabs>(Tabs.handwriting);
  Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home Screen"),
          toolbarHeight: 80,
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(text: "Handwritten notes"),
              Tab(text: "Textnotes"),
              Tab(text: "PDF notes"),
            ],
            onTap: (index) {
              currentTab.value = Tabs.values[index];
            },
          ),
        ),
        body: TabBarView(
          children: [
            Stack(
              children: [
                ValueListenableBuilder(
                  valueListenable: Hive.box<DrawingNote>(
                    'drawing_notes_box',
                  ).listenable(),
                  builder: (context, Box<DrawingNote> box, _) {
                    if (box.values.isEmpty) {
                      return Center(child: Text("No notes saved yet!"));
                    }
                    final allNotes = box.values.toList();
                    final collections = allNotes
                        .map((note) => note.collection)
                        .toSet()
                        .toList();

                    return ListView.builder(
                      itemCount: collections.length,
                      itemBuilder: (context, index) {
                        final collection = collections[index];

                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.all(8),
                          child: ListTile(
                            leading: Icon(Icons.folder),
                            title: Text(collection),
                            trailing: Icon(Icons.abc_rounded),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CollectionDrawings(
                                    collectionName: collection,
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
              ],
            ),
            //2nd tab
            Stack(
              children: [
                ValueListenableBuilder(
                  valueListenable: Hive.box<TextNote>(
                    'text_note_box',
                  ).listenable(),
                  builder: (context, Box<TextNote> box, _) {
                    if (box.values.isEmpty) {
                      return Center(child: Text("No Text Notes Saved Yet"));
                    }

                    final allNotes = box.values.toList();
                    final collections = allNotes
                        .map((note) => note.collection)
                        .toSet()
                        .toList();

                    return ListView.builder(
                      itemCount: collections.length,
                      itemBuilder: (context, index) {
                        final collectionName = collections[index];

                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.all(8),
                          child: ListTile(
                            leading: Icon(Icons.folder),
                            title: Text(collectionName),
                            trailing: Icon(Icons.abc_rounded),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CollectionNotes(
                                    collectionName: collectionName,
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
              ],
            ),
          ],
        ),

        //floating action button
        floatingActionButton: ValueListenableBuilder<Tabs>(
          valueListenable: currentTab,
          builder: (context, activeTab, child) {
            return FloatingActionButton(
              onPressed: () {
                switch (currentTab.value) {
                  case Tabs.handwriting:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => (Drawingscreen()),
                      ),
                    );
                    break;

                  case Tabs.text:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => (TextEditorContainer()),
                      ),
                    );
                  default:
                    return;
                }
                // Action when button is pressed
              },
              child: Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}
