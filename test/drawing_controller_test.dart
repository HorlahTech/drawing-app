import 'package:drawing_app_test/controller/drawing_controller.dart';
import 'package:drawing_app_test/models/drawing_points.dart';
import 'package:drawing_app_test/utils/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DrawingController', () {
    late DrawingController controller;

    setUp(() {
      controller = DrawingController();
    });

    test('Initial values are correct', () {
      expect(controller.historyDrawingPoints, isEmpty);
      expect(controller.drawingPoints, isEmpty);
      expect(controller.isZoom, isFalse);
      expect(controller.bgColor, AppColors.white);
      expect(controller.pencilColor, Colors.black);
      expect(controller.pencilWidth, 5.0);
      expect(controller.isErazer, isFalse);
      expect(controller.currentDrawingPoint, isNull);
      expect(controller.mode, DrawingMode.scibble);
    });

    test('onPanStart adds a drawing point', () {
      final details = TestPanStartDetails(localPosition: const Offset(10, 10));
      controller.onPanStart(details);

      expect(controller.drawingPoints, hasLength(1));
      expect(controller.drawingPoints.first.offsets, [const Offset(10, 10)]);
    });

    test('onPanUpdate updates the current drawing point', () {
      final startDetails =
          TestPanStartDetails(localPosition: const Offset(10, 10));
      controller.onPanStart(startDetails);

      final updateDetails =
          TestPanUpdateDetails(localPosition: const Offset(20, 20));
      controller.onPanUpdate(updateDetails);

      expect(
        controller.drawingPoints.first.offsets,
        [const Offset(10, 10), const Offset(20, 20)],
      );
    });

    test('onPanEnd clears the current drawing point', () {
      final details = TestPanStartDetails(localPosition: const Offset(10, 10));
      controller.onPanStart(details);

      controller.onPanEnd(null);

      expect(controller.currentDrawingPoint, isNull);
    });

    test('undo removes the last drawing point', () {
      final details = TestPanStartDetails(localPosition: const Offset(10, 10));
      controller.onPanStart(details);

      controller.undo();

      expect(controller.drawingPoints, isEmpty);
    });

    test('redo adds the last removed drawing point', () {
      final details = TestPanStartDetails(localPosition: const Offset(10, 10));
      controller.onPanStart(details);
      controller.undo();

      controller.redo();

      expect(controller.drawingPoints, hasLength(1));
    });

    test('clear removes all drawing points', () {
      final details = TestPanStartDetails(localPosition: const Offset(10, 10));
      controller.onPanStart(details);

      controller.clear();

      expect(controller.drawingPoints, isEmpty);
    });

    test('zoom toggles the isZoom property', () {
      controller.zoom();
      expect(controller.isZoom, isTrue);

      controller.zoom();
      expect(controller.isZoom, isFalse);
    });

    test('changePencilColor updates the pencil color', () {
      controller.changePencilColor(Colors.red);
      expect(controller.pencilColor, Colors.red);
    });

    test('changeBgColor updates the background color', () {
      controller.changeBgColor(Colors.blue);
      expect(controller.bgColor, Colors.blue);
    });

    test('erazerOnchange toggles the eraser mode', () {
      controller.erazerOnchange();
      expect(controller.isErazer, isTrue);
      expect(controller.mode, DrawingMode.scibble);

      controller.erazerOnchange();
      expect(controller.isErazer, isFalse);
    });

    test('pencilSizeOnchange updates the pencil width', () {
      controller.pencilSizeOnchange(5.0);
      expect(controller.pencilWidth, 5.0);
    });

    test('shapeOnchange updates the drawing mode and disables eraser', () {
      controller.shapeOnchange(DrawingMode.circle);
      expect(controller.mode, DrawingMode.circle);
      expect(controller.isErazer, isFalse);
    });
  });
}

// Helper classes to simulate pan events in the tests
class TestPanStartDetails {
  final Offset localPosition;
  TestPanStartDetails({required this.localPosition});
}

class TestPanUpdateDetails {
  final Offset localPosition;
  TestPanUpdateDetails({required this.localPosition});
}
