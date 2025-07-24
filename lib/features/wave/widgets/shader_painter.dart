import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vec;

class ShaderPainter extends CustomPainter {
  ShaderPainter({required this.shader, super.repaint});

  final FragmentShader shader;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..translate(size.width, size.height)
      ..rotate(180 * vec.degrees2Radians)
      ..drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..shader = shader,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
