import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notepnp/models/offset.dart';

part 'strokes.g.dart';

@HiveType(typeId: 1)
class Stroke {
  @HiveField(0)
  final List<Customoffset> points;
  @HiveField(1)
  final int color;
  @HiveField(2)
  final double strokeWidth;

  Stroke({
    required this.points,
    required this.color,
    required this.strokeWidth,
  });

  factory Stroke.fromDrawing({
    required List<Offset> points,
    required int color,
    required double strokeWidth,
  }) {
    return Stroke(
      points: points.map((e) => Customoffset.fromOffset(e)).toList(),
      color: color,
      strokeWidth: strokeWidth,
    );
  }

  List<Offset> get getPoints => points.map((e) => e.toOffset()).toList();
  Color get getColor => Color(color);
}
