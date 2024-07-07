import 'package:drawing_app_test/controller/popup_manager.dart';
import 'package:drawing_app_test/utils/app_colors.dart';
import 'package:flutter/material.dart';

class BoxButton extends StatelessWidget {
  BoxButton({
    super.key,
    this.onTap,
    this.color,
    required this.icon,
    this.isSelected = false,
    this.iconcolor = AppColors.white,
    this.hasPopUp = false,
    this.popupChildren = const [],
  })  : onChanged = null,
        isSlider = false,
        sliderValue = null;
  BoxButton.slider({
    super.key,
    this.color,
    required this.icon,
    this.sliderValue,
    this.iconcolor = AppColors.white,
    this.onChanged,
  })  : onTap = null,
        hasPopUp = false,
        popupChildren = null,
        isSlider = true,
        isSelected = false;
  final VoidCallback? onTap;
  final Color? color;
  final double? sliderValue;
  final Color iconcolor;
  final IconData icon;
  final bool hasPopUp;
  final bool isSlider;
  final bool isSelected;
  final List<Widget>? popupChildren;
  final void Function(double)? onChanged;

  OverlayEntry? _overlayEntry;

  OverlayEntry _createOverlayEntry(
    BuildContext context,
    Offset buttonPosition,
  ) {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          left: buttonPosition.dx + 60,
          top: buttonPosition.dy + 10.0, // Adjust the position as needed
          child: _buildPop(context),
        );
      },
    );
  }

  void _showPopup(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox;
    final buttonPosition = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = _createOverlayEntry(context, buttonPosition);
    PopupManager().addPopup(_overlayEntry!); // Add to active popups list
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hidePopup() {
    if (_overlayEntry != null) {
      // _overlayEntry!.remove();
      PopupManager()
          .removePopup(_overlayEntry!); // Remove from active popups list
      _overlayEntry = null;
    }
  }

  Widget _buildPop(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: isSlider && !hasPopUp
          ? RotatedBox(
              quarterTurns: 3, // 270 degree
              child: Slider(
                value: sliderValue!,
                min: 1,
                max: 20,
                onChanged: onChanged,
              ),
            )
          : Container(
              width: 170,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: Wrap(
                children: popupChildren ?? [],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // assert(
    //     hasPopUp && onTap == null, "cannot have pop up when ontap is not null");
    return GestureDetector(
      onTap: hasPopUp || isSlider
          ? () {
              PopupManager().hideAllPopups();
              if (_overlayEntry == null) {
                _showPopup(context);
              } else {
                _hidePopup();
              }
            }
          : () {
              PopupManager().hideAllPopups();
              onTap?.call();
            },
      child: Container(
        height: 40,
        width: 40,
        margin: const EdgeInsets.only(top: 3, left: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.circleColorBG
              : const Color.fromARGB(255, 245, 230, 247),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          color: isSelected ? AppColors.white : AppColors.black,
        ),
      ),
    );
  }
}
