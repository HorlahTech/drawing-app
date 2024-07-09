import 'dart:math' show pi;

import 'package:drawing_app_test/controller/drawing_controller.dart';
import 'package:drawing_app_test/controller/popup_manager.dart';
import 'package:drawing_app_test/models/drawing_points.dart';

import 'package:drawing_app_test/utils/app_colors.dart';
import 'package:drawing_app_test/views/painter.dart';
import 'package:drawing_app_test/views/widgets/boxbutton.dart';
import 'package:drawing_app_test/views/widgets/color_palette.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zoom_widget/zoom_widget.dart';

class DrawingApp extends ConsumerStatefulWidget {
  const DrawingApp({super.key});

  @override
  ConsumerState<DrawingApp> createState() => _DrawingAppState();
}

class _DrawingAppState extends ConsumerState<DrawingApp>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  double _width = 1000;
  double _scale = 1.0;
  final double _height = 1800;
  final ValueNotifier<bool> _isOpen = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    final stateRead = ref.read(drawingController.notifier);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isPortrait = orientation == Orientation.portrait;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              /// drawing Canvas

              Zoom(
                backgroundColor: ref.watch(drawingController).bgColor,
                onScaleUpdate: (scale, widght) {
                  setState(() {
                    _scale = scale;
                    // _height = _height * _scale;
                    _width = _width * _scale;
                  });
                },
                child: GestureDetector(
                  onPanStart: ref.watch(drawingController).isZoom
                      ? null
                      : stateRead.onPanStart,
                  onPanUpdate: ref.watch(drawingController).isZoom
                      ? null
                      : stateRead.onPanUpdate,
                  onPanEnd: ref.watch(drawingController).isZoom
                      ? null
                      : stateRead.onPanEnd,
                  child: Transform.scale(
                    scale: _scale,
                    child: Container(
                      width: _height,
                      height: _width,
                      color: ref.watch(drawingController).bgColor,
                      child: CustomPaint(
                        painter: DrawingPainter(
                          drawingPoints:
                              ref.watch(drawingController).drawingPoints,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /// tools
              Positioned(
                top: isPortrait ? kToolbarHeight + 20 : -170,
                left: isPortrait ? 0 : kToolbarHeight + 170,
                child: Transform.rotate(
                  angle: isPortrait ? 0 : pi / 2,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1, 0),
                      end: Offset.zero,
                    ).animate(animationController),
                    child: Container(
                      width: isPortrait ? 70 : 60,
                      height: isPortrait ? screenSize.height - 300 : 400,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                        border: const Border(
                          right: BorderSide(
                            // strokeAlign: BorderSide.strokeAlignOutside,
                            width: 3,
                            color: AppColors.circleColorBG,
                          ),
                        ),
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            spreadRadius: 2,
                            blurStyle: BlurStyle.outer,
                            color: AppColors.black.withOpacity(.5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          BoxButton(
                            onTap: stateRead.zoom,
                            icon: ref.watch(drawingController).isZoom
                                ? Icons.zoom_out
                                : Icons.zoom_in,
                          ),
                          BoxButton(
                            onTap: stateRead.undo,
                            icon: FontAwesomeIcons.arrowRotateLeft,
                          ),
                          BoxButton(
                            onTap: stateRead.redo,
                            icon: FontAwesomeIcons.arrowRotateRight,
                          ),
                          BoxButton(
                            onTap: stateRead.clear,
                            icon: FontAwesomeIcons.xmark,
                          ),
                          Consumer(
                            builder: (context, ref, _) {
                              final sliderValue =
                                  ref.watch(drawingController).pencilWidth;
                              final sliderOnchange =
                                  ref.read(drawingController.notifier);
                              return BoxButton.slider(
                                icon: FontAwesomeIcons.pencil,
                                sliderValue: sliderValue,
                                onChanged: sliderOnchange.pencilSizeOnchange,
                              );
                            },
                          ),

                          BoxButton(
                            isSelected: ref.watch(drawingController).isErazer,
                            icon: FontAwesomeIcons.eraser,
                            onTap: stateRead.erazerOnchange,
                          ),
                          BoxButton(
                            icon: FontAwesomeIcons.shapes,
                            hasPopUp: true,
                            popupChildren: [
                              BoxButton(
                                icon: FontAwesomeIcons.circle,
                                onTap: () {
                                  stateRead.shapeOnchange(DrawingMode.circle);
                                },
                              ),
                              BoxButton(
                                icon: FontAwesomeIcons.square,
                                onTap: () {
                                  stateRead.shapeOnchange(DrawingMode.sqaure);
                                },
                              ),
                              BoxButton(
                                icon: FontAwesomeIcons.slash,
                                onTap: () {
                                  stateRead.shapeOnchange(DrawingMode.line);
                                },
                              ),
                              BoxButton(
                                icon: FontAwesomeIcons.openid,
                                onTap: () {
                                  stateRead.shapeOnchange(DrawingMode.scibble);
                                },
                              ),
                            ],
                          ),

                          ///pencil color picker
                          ColorPalette(
                            title: 'Pick Pencil color!',
                            onColorChanged: stateRead.changePencilColor,
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => const AlertDialog(
                                  content: Text(
                                    'Changing canvas color will clear your canvas, are you sure to Proceed',
                                  ),
                                ),
                              );
                            },

                            /// background color picker
                            child: ColorPalette(
                              title: 'Pick Canvas color!',
                              onColorChanged: stateRead.changeBgColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ValueListenableBuilder(
                  valueListenable: _isOpen,
                  builder: (context, isOpen, _) {
                    return GestureDetector(
                      onTap: () {
                        PopupManager().hideAllPopups();
                        if (isOpen) {
                          animationController.reverse();
                        } else {
                          animationController.forward();
                        }
                        _isOpen.value = !_isOpen.value;
                      },
                      child: Icon(
                        isOpen ? Icons.cancel_outlined : Icons.menu,
                        color: AppColors.circleColorBG,
                        size: 30,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
