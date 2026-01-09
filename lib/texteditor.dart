import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notepnp/Home.dart';
import 'package:notepnp/models/textnote.dart';

import 'dart:convert'; // jsonEncode and jsonDecode
import 'dart:io'; // File
import 'package:path_provider/path_provider.dart'; // File path

class TextEditorContainer extends StatefulWidget {
  const TextEditorContainer({super.key});
  @override
  State<TextEditorContainer> createState() => _TextEditor();
}

class _TextEditor extends State<TextEditorContainer> {
  //saving notes function start
  Future<void> _saveNote(String title, String collection) async {
    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    String fileName = "note_$timeStamp";
    try {
      final jsonContent = jsonEncode(_controller.document.toDelta().toJson());

      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;

      final file = File('$path/$fileName.json');
      await file.writeAsString(jsonContent);

      var box = Hive.box<TextNote>('text_note_box');

      final newTextNote = TextNote(
        collection: collection,
        title: title,
        fileName: fileName,
        date: DateTime.now(),
      );

      box.add(newTextNote);
      print("fine saved in ${file.path}");
    } catch (err) {
      print('err occured ${err}');
    }
  }
  //saving note function end

  //saving note dialogbox start
  void showDialogBox() {
    final TextEditingController _titlecontroller = TextEditingController();
    final TextEditingController _collectioncontroller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Save Note as,"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titlecontroller,
                decoration: InputDecoration(hintText: "Enter Note Title"),
              ),
              TextField(
                controller: _collectioncontroller,
                decoration: InputDecoration(
                  hintText: "Enter Note Collection Name",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String title = _titlecontroller.text;
                String collection = _collectioncontroller.text;
                if (title.isNotEmpty && collection.isNotEmpty) {
                  _saveNote(title, collection);
                  Navigator.of(context).pop();
                  Future.microtask(() {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => Homescreen()),
                    );
                  });
                }
              },
              child: Text("Save"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
  //saving dialog box end

  //loading a note function start
  Future<void> _loadNote(String fileName) async {
    final directory = await getApplicationCacheDirectory();
    final file = File('$directory/$fileName.json');

    if (await file.exists()) {
      final content = await file.readAsString();
      final jsonResponse = jsonDecode(content);

      setState(() {
        _controller = QuillController(
          document: Document.fromJson(jsonResponse),
          selection: const TextSelection.collapsed(offset: 0),
        );
      });
    }
  }

  QuillController _controller = QuillController.basic();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TextEditor"),
        actions: [
          IconButton(
            onPressed: () {
              showDialogBox();
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Column(
        children: [
          QuillSimpleToolbar(controller: _controller),
          Expanded(child: QuillEditor.basic(controller: _controller)),
        ],
      ),
    );
  }
}
