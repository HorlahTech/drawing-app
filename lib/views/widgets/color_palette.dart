import 'package:drawing_app_test/controller/drawing_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/svg.dart';

class ColorPalette extends ConsumerWidget {
  String title;
  void Function(Color) onColorChanged;
  ColorPalette({
    Key? key,
    required this.title,
    required this.onColorChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              showColorWheel(context, ref);
            },
            child: SvgPicture.asset(
              'assets/images/color_wheel.svg',
              height: 30,
              width: 30,
            ),
          ),
        ),
      ],
    );
  }

  void showColorWheel(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ColorPicker(
                pickerColor: ref.watch(drawingController).pencilColor,
                onColorChanged: onColorChanged),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Done'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
