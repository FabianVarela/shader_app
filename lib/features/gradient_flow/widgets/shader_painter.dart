import 'dart:ui';

import 'package:flutter/material.dart';

class ShaderPainter extends CustomPainter {
  ShaderPainter({
    required this.shader,
    required this.colors,
    required this.time,
    super.repaint,
  }) : assert(colors.length == 4, 'Must set 4 colors in the list');

  final FragmentShader shader;
  final List<Color> colors;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time);

    final rgbList = <double>[];
    for (final item in colors) {
      rgbList.addAll([item.r, item.g, item.b]);
    }

    for (final (index, color) in rgbList.indexed) {
      shader.setFloat(3 + index, color);
    }

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
