import 'package:flutter/material.dart';

enum DrawingMode { circle, sqaure, line, scibble, eraser }

class DrawingPoint {
  List<Offset> offsets;
  Color color;
  double width;
  DrawingMode mode;
  bool isErazer;

  DrawingPoint(
      {this.offsets = const [],
      this.color = Colors.pink,
      this.width = 2,
      this.mode = DrawingMode.scibble, this.isErazer = false});

  DrawingPoint copyWith({
    List<Offset>? offsets,
    Color? color,
    double? width,
    DrawingMode? mode,
  }) {
    return DrawingPoint(
      color: color ?? this.color,
      width: width ?? this.width,
      mode: mode ?? this.mode,
      offsets: offsets ?? this.offsets,
    );
  }
}
