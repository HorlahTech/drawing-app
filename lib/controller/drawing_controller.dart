import 'package:drawing_app_test/controller/popup_manager.dart';
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
  double _pencilWidth = 5.0;
  bool isErazer = false;
  DrawingPoint? currentDrawingPoint;
  DrawingMode mode = DrawingMode.scibble;
  double get pencilWidth => _pencilWidth;

  /// onPanStart create drawingpoint and  recored the ofset of user gesture
  void onPanStart(details) {
    PopupManager().hideAllPopups();
    currentDrawingPoint = DrawingPoint(
      offsets: [
        details.localPosition,
      ],
      color: isErazer ? bgColor : pencilColor,
      mode: mode,
      width: _pencilWidth,
    );
    if (currentDrawingPoint == null) return;
    drawingPoints.add(currentDrawingPoint!);
    historyDrawingPoints = List.of(drawingPoints);
    notifyListeners();
  }

  /// onPanUpdate update the movement of the user gesture and record position

  void onPanUpdate(details) {
    if (currentDrawingPoint == null) return;

    currentDrawingPoint = currentDrawingPoint?.copyWith(
      offsets: currentDrawingPoint!.offsets..add(details.localPosition),
    );
    drawingPoints.last = currentDrawingPoint!;
    historyDrawingPoints = List.of(drawingPoints);
    notifyListeners();
  }

  /// onpanEnd set the drawningpoint to null when gesture movement stop
  void onPanEnd(_) {
    currentDrawingPoint = null;
    notifyListeners();
  }

  /// undo function remove the last point drawing pont
  void undo() {
    if (drawingPoints.isNotEmpty && historyDrawingPoints.isNotEmpty) {
      drawingPoints.removeLast();
    }
    notifyListeners();
  }

  /// undo function add the last point drawing pont when the drawingpoints length is lesser than historyDrawingPoints.length
  void redo() {
    if (drawingPoints.length < historyDrawingPoints.length) {
      final index = drawingPoints.length;
      drawingPoints.add(historyDrawingPoints[index]);
    }

    notifyListeners();
  }

  /// cleaer all the drawing point
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
    clear();
    bgColor = color;

    notifyListeners();
  }

  void erazerOnchange() {
    mode = DrawingMode.scibble;
    isErazer = !isErazer;
    notifyListeners();
  }

  void pencilSizeOnchange(double value) {
    _pencilWidth = value;
    notifyListeners();
  }

  void shapeOnchange(DrawingMode value) {
    mode = value;
    isErazer = false;
    notifyListeners();
  }
}
