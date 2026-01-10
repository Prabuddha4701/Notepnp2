import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:notepnp/models/note.dart';
import 'package:notepnp/models/strokes.dart';

import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart'
    as mdir;

import 'package:hive/hive.dart';

//import 'package:notepnp/models/offset.dart';
import 'package:notepnp/texteditor.dart';

import 'package:path_provider/path_provider.dart';

class Drawingscreen extends StatefulWidget {
  final DrawingNote? note;
  final String? fileName;
  const Drawingscreen({super.key, this.note, this.fileName});
  @override
  State<Drawingscreen> createState() => _DrawingscreenState();
}

enum Drawingtool { pen, eraser, highliter }

class _DrawingscreenState extends State<Drawingscreen> {
  List<Stroke> _strokes = [];
  List<Stroke> _undonestrokes = [];
  List<Offset> _currentpoints = [];
  Color selectedColor = Colors.black;
  double strokewidth = 4.0;
  bool _isdrawing = false;

  double _canvasheight = 800.0;

  Drawingtool selectedTool = Drawingtool.pen;

  @override
  void initState() {
    super.initState();
    if (widget.fileName != null) {
      _loadNote();
    } else {
      print("_loadnote did nor run");
    }
  }

  void dispose() {
    super.dispose();
  }

  //-------------savenote start---------------------------------
  Future<void> _saveNote(String collection, String title) async {
    String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    String fileName = 'canvas_${timeStamp}.json';
    try {
      //strokes to json
      List<Map<String, dynamic>> strokemap = _strokes
          .map(
            (stroke) => {
              'points': stroke.points
                  .map((p) => {'x': p.dx, 'y': p.dy})
                  .toList(),
              'color': stroke.color.value,
              'strokeWidth': stroke.strokeWidth,
            },
          )
          .toList();

      String JsonContent = jsonEncode(strokemap);

      //folder and file
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final file = File('${path}/${fileName}');
      //write to file
      await file.writeAsString(JsonContent);

      //save to hive
      var box = Hive.box<DrawingNote>('drawing_notes_box');

      final newDrawingNote = DrawingNote(
        collection: collection,
        title: title,
        fileName: fileName,
        date: DateTime.now(),
      );
      box.add(newDrawingNote);
      print("Drawing note saved successfully ${fileName}");
    } catch (err) {
      print("Drawing note save error ${err}");
    }
  }
  //-----------------savenote end------------------------------

  //--------------notesavedialogbox----------------
  void_saveNoteDialogBox() {
    final TextEditingController _collectioncontroller = TextEditingController();
    final TextEditingController _titlecontroller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Save Your Note As'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _collectioncontroller,
                decoration: InputDecoration(hintText: 'Enter Note Collection'),
              ),

              TextField(
                controller: _titlecontroller,
                decoration: InputDecoration(hintText: 'Enter Note Title'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('cancel'),
            ),
            TextButton(
              onPressed: () {
                String title = _titlecontroller.text;
                String collection = _collectioncontroller.text;
                if (title.isNotEmpty) {
                  _saveNote(collection, title);
                  Navigator.of(context).pop();
                }
              },
              child: Text('save'),
            ),
          ],
        );
      },
    );
  }
  //-----------------notesavedialogbox end--------------------------

  //-------------------load_note start-----------------------------
  Future<void> _loadNote() async {
    print("hello ${widget.fileName}");
    if (widget.fileName != null) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/${widget.fileName}');

        if (await file.exists()) {
          final content = await file.readAsString();
          final jsonResponse = jsonDecode(content);

          setState(() {
            _strokes = List<Stroke>.from(
              jsonResponse.map((stroke) {
                List<dynamic> PointsJson = stroke['points'];
                List<Offset> StrokePoints = PointsJson.map((point) {
                  return Offset(point['x'] as double, point['y'] as double);
                }).toList();

                Color strokeColor = Color(stroke['color'] as int);

                double width = (stroke['strokeWidth'] as num).toDouble();

                return Stroke(
                  points: StrokePoints,
                  color: strokeColor,
                  strokeWidth: width,
                );
              }).toList(),
            );
          });
        }
      } catch (err) {
        print("load err${err}");
      }
    } else {
      print("load_err");
    }
  }
  //------------------------loadnote end------------------------------

  //recoganizer
  final mdir.DigitalInkRecognizer _digitalInkRecoganizer =
      mdir.DigitalInkRecognizer(languageCode: 'en-US');
  //recoganizing function
  Future<void> recoganizrDrawing(List<Stroke> allStrokes) async {
    if (allStrokes.isNotEmpty) {
      try {
        final bool isModelDownloaded =
            await mdir.DigitalInkRecognizerModelManager().isModelDownloaded(
              'en-US',
            );
        if (!isModelDownloaded) {
          await mdir.DigitalInkRecognizerModelManager().downloadModel('en-US');
        }

        allStrokes.sort(
          (a, b) => a.points.first.dy.compareTo(b.points.first.dy),
        );
        List<List<Stroke>> lines = [];
        List<Stroke> currentLine = [allStrokes[0]];

        for (int i = 1; i < allStrokes.length; i++) {
          if (((allStrokes[i].points.first.dy) -
                      (currentLine.last.points.first.dy))
                  .abs() >
              50) {
            lines.add(List.from(currentLine));
            currentLine = [allStrokes[i]];
          } else {
            currentLine.add(allStrokes[i]);
          }
        }
        lines.add(currentLine);
        String fullText = "";
        for (var line in lines) {
          line.sort((a, b) => a.points.first.dx.compareTo(b.points.first.dx));
          final ink = mdir.Ink();

          for (var stroke in line) {
            final inkStroke = mdir.Stroke();
            for (var point in stroke.points) {
              inkStroke.points.add(
                mdir.StrokePoint(
                  x: point.dx,
                  y: point.dy,
                  t: DateTime.now().millisecondsSinceEpoch,
                ),
              );
            }
            ink.strokes.add(inkStroke);
          }
          final candidates = await _digitalInkRecoganizer.recognize(ink);
          if (candidates.isNotEmpty) {
            fullText += candidates[0].text + " ";
          }

          print(fullText);
          if (fullText.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TextEditorContainer(initialText: fullText),
              ),
            );
          }
        }
      } catch (err) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Note P n P"),
        actions: [
          IconButton(
            onPressed: () {
              recoganizrDrawing(_strokes);
            },
            icon: Icon(Icons.text_fields),
          ),
          IconButton(
            onPressed: () {
              void_saveNoteDialogBox();
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: GestureDetector(
              onPanStart: (details) {
                // print("started at ${details.localPosition}");
                setState(() {
                  if (selectedTool == Drawingtool.eraser) return;

                  _currentpoints.add(details.localPosition);
                  _isdrawing = true;
                });
              },
              onPanUpdate: (details) {
                // print("now at ${details.localPosition}");
                setState(() {
                  if (selectedTool == Drawingtool.eraser) {
                    final strokesToRemove = _strokes.where((stroke) {
                      return stroke.points.any(
                        (point) =>
                            (Offset(point.dx, point.dy) - details.localPosition)
                                .distance <=
                            10.0,
                      );
                    }).toList();
                    if (strokesToRemove.isNotEmpty) {
                      _undonestrokes.addAll(strokesToRemove);
                    }

                    _strokes.removeWhere(
                      (stroke) => strokesToRemove.contains(stroke),
                    );
                  } else {
                    _currentpoints.add(details.localPosition);
                  }

                  if (details.localPosition.dy > _canvasheight - 50) {
                    _canvasheight += _canvasheight;
                  }
                });
              },
              onPanEnd: (details) {
                // print("Ended at ${details.localPosition}");
                setState(() {
                  _isdrawing = false;
                  _strokes.add(
                    Stroke(
                      points: List.from(_currentpoints),
                      color: selectedColor,
                      strokeWidth: strokewidth,
                    ),
                  );
                  _currentpoints.clear();
                });
              },

              child: Container(
                color: const Color.fromARGB(255, 255, 255, 255),
                width: MediaQuery.of(context).size.width,
                height: _canvasheight,
                child: CustomPaint(
                  size: Size.infinite,
                  painter: Notecanvas(
                    _strokes,
                    _currentpoints,
                    selectedColor,
                    strokewidth,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            right: 10,
            child: AnimatedOpacity(
              opacity: _isdrawing ? 0.0 : 1.0,
              duration: Duration(microseconds: 200),
              child: IgnorePointer(ignoring: _isdrawing, child: Toolbar()),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget Toolbar() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          IconButton(
            onPressed: () {
              if (_strokes.isNotEmpty) {
                setState(() {
                  _undonestrokes.add(_strokes.removeLast());
                });
              }
            },
            icon: Icon(Icons.undo),
          ),
          IconButton(
            onPressed: () {
              if (_undonestrokes.isNotEmpty) {
                setState(() {
                  _strokes.add(_undonestrokes.removeLast());
                });
              }
            },

            icon: Icon(Icons.redo),
          ),
          IconButton(
            onPressed: () {
              showMoreDialog();
            },
            icon: (Icon(Icons.color_lens)),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                selectedColor = Colors.black;
              });
            },
            icon: Icon(Icons.circle, color: Colors.black),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                selectedColor = Colors.red;
              });
            },
            icon: Icon(Icons.circle, color: Colors.red),
          ),

          IconButton(
            onPressed: () {
              setState(() {
                selectedColor = Colors.blue;
              });
            },
            icon: Icon(Icons.circle, color: Colors.blue),
          ),
          SizedBox(
            height: 100,
            child: RotatedBox(
              quarterTurns: 3,
              child: Slider(
                value: strokewidth,
                min: 1.0,
                max: 10.0,
                onChanged: (value) {
                  setState(() {
                    strokewidth = value;
                  });
                },
              ),
            ),
          ),

          IconButton(
            onPressed: () {
              setState(() {
                selectedTool = Drawingtool.eraser;
              });
            },
            icon: Icon(Icons.remove_circle),
          ),

          IconButton(
            onPressed: () {
              setState(() {
                selectedTool = Drawingtool.pen;
              });
            },
            icon: Icon(Icons.brush),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                selectedTool = Drawingtool.highliter;
              });
            },
            icon: Icon(Icons.highlight),
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz_rounded)),
        ],
      ),
    );
  }

  void showMoreDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select Color"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ColorPicker(
                pickerColor: selectedColor,
                onColorChanged: (Color color) {
                  setState(() {
                    selectedColor = color;
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class Notecanvas extends CustomPainter {
  final List<Stroke> strokes;
  final List<Offset> currentPoints;
  final Color selectedColor;
  final double strokewidth;

  Notecanvas(
    this.strokes,
    this.currentPoints,
    this.selectedColor,
    this.strokewidth,
  );

  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      for (int i = 0; i < stroke.points.length - 1; i++) {
        canvas.drawLine(stroke.points[i], stroke.points[i + 1], paint);
      }
    }

    @override
    final paint = Paint()
      ..color = selectedColor
      ..strokeWidth = strokewidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < currentPoints.length - 1; i++) {
      canvas.drawLine(currentPoints[i], currentPoints[i + 1], paint);
    }

    @override
    final pageShadow = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    @override
    final gapPaint = Paint()..color = const Color.fromARGB(255, 227, 227, 227);

    for (double y = 800.0; y < size.height; y += 800.0) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 8.0), pageShadow);
      canvas.drawRect(Rect.fromLTWH(0, y + 2.0, size.width, 20.0), gapPaint);
    }
  }
  //recognition part

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
