import 'dart:ui';

import 'package:flutter/material.dart';

class ShaderPainter extends CustomPainter {
  ShaderPainter({
    required this.shader,
    required this.incrementSize,
    required this.time,
    super.repaint,
  });

  final FragmentShader shader;
  final int incrementSize;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, time)
      ..setFloat(1, size.width * incrementSize)
      ..setFloat(2, size.height * incrementSize);

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
