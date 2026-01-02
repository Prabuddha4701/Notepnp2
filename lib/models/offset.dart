import 'package:hive/hive.dart';
import 'dart:ui';

part 'offset.g.dart';

@HiveType(typeId: 0)
class Customoffset extends HiveObject {
  @HiveField(0)
  final double dx;

  @HiveField(1)
  final double dy;

  Customoffset({required this.dx, required this.dy});

  /// Convert Hive object → Flutter Offset
  Offset toOffset() => Offset(dx, dy);

  /// Convert Flutter Offset → Hive object

  factory Customoffset.fromOffset(Offset offset) {
    return Customoffset(dx: offset.dx, dy: offset.dy);
  }
}
