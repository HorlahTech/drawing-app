import 'package:drawing_app_test/models/drawing_points.dart';
import 'package:drawing_app_test/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final drawingController = ChangeNotifierProvider<DrawingController>((ref) {
  return DrawingController();
});

class DrawingController extends ChangeNotifier {
  List<DrawingPoint> historyDrawingPoints = <DrawingPoint>[];
  List<DrawingPoint> drawingPoints = <DrawingPoint>[];
  bool isZoom = false;
  Color bgColor = AppColors.white;
  Color pencilColor = Colors.black;
  double pencilWidth = 2.0 ;

  bool isErazer = false;
  DrawingPoint? currentDrawingPoint;
  DrawingMode mode = DrawingMode.scibble;

  void onPanStart(details) {
    currentDrawingPoint = DrawingPoint(
      offsets: [
        details.localPosition,
      ],
      color:isErazer? bgColor: pencilColor,
      mode: mode,
      width:  pencilWidth,
    );

    if (currentDrawingPoint == null) return;
    drawingPoints.add(currentDrawingPoint!);
    historyDrawingPoints = List.of(drawingPoints);
    notifyListeners();
  }

  void onPanUpdate(details) {
    if (currentDrawingPoint == null) return;

    currentDrawingPoint = currentDrawingPoint?.copyWith(
      offsets: currentDrawingPoint!.offsets..add(details.localPosition),
    );
    drawingPoints.last = currentDrawingPoint!;
    historyDrawingPoints = List.of(drawingPoints);
    notifyListeners();
  }

  void onPanEnd(_) {
    currentDrawingPoint = null;
    notifyListeners();
  }

  void undo() {
    if (drawingPoints.isNotEmpty && historyDrawingPoints.isNotEmpty) {
      drawingPoints.removeLast();
    }
    notifyListeners();
  }

  void redo() {
    if (drawingPoints.length < historyDrawingPoints.length) {
      final index = drawingPoints.length;
      drawingPoints.add(historyDrawingPoints[index]);
    }

    notifyListeners();
  }

  void clear() {
    drawingPoints.clear();

    notifyListeners();
  }

  void zoom() {
    isZoom = !isZoom;

    notifyListeners();
  }

  void changePencilColor(Color color) {
    pencilColor = color;

    notifyListeners();
  }

  void changeBgColor(Color color) {
    bgColor = color;

    notifyListeners();
  }
  void erazerOnchange(){
    mode = DrawingMode.scibble;
    isErazer = !isErazer;
    notifyListeners();
  }
  void pencilSizeOnchange(double value){
    pencilWidth = value;
    notifyListeners();
  }

  void shapeOnchange(DrawingMode value){
    mode = value;
    isErazer = false;
    notifyListeners();
  }
}
