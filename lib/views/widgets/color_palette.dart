import 'package:drawing_app_test/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:flutter_svg/svg.dart';

class ColorPalette extends StatelessWidget {
  final String title;
  final void Function(Color) onColorChanged;
  const ColorPalette({
    super.key,
    required this.title,
    required this.onColorChanged,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              showColorWheel(
                context,
              );
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

  void showColorWheel(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: AppColors.circleColorBG,
              onColorChanged: onColorChanged,
            ),
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
