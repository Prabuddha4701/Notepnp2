import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:notepnp/Drawingscreen.dart';
import 'package:notepnp/models/note.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        toolbarHeight: 80,
        elevation: 0,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<DrawingNote>('notes_box').listenable(),
        builder: (context, Box<DrawingNote> box, _) {
          if (box.values.isEmpty) {
            return Center(child: Text("No notes saved yet!"));
          }

          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              var note = box.getAt(index);

              return ListTile(
                title: Text(note!.title),
                subtitle: Text(note.date.toString().substring(0, 16)),
                leading: Icon(Icons.note),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () =>
                      note.delete(), // HiveObject නිසා කෙලින්ම මකන්න පුළුවන්
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Drawingscreen(note: note),
                    ),
                  );
                  // පරණ නෝට් එකක් ඕපන් කිරීම (පසුවට හදමු)
                },
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => (Drawingscreen())),
          ); // Action when button is pressed
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
