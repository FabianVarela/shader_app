import 'dart:ui';

import 'package:flutter/material.dart';

class ShaderPainter extends CustomPainter {
  ShaderPainter({required this.shader, super.repaint});

  final FragmentShader shader;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPaint(Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
