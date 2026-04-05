import 'dart:ui';

import 'package:flutter/material.dart';

class ShaderPainter extends CustomPainter {
  const ShaderPainter({required this.shader, required this.time});

  final FragmentShader shader;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    var idx = 0;

    shader
      ..setFloat(idx++, time)
      ..setFloat(idx++, size.width)
      ..setFloat(idx++, size.height);

    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(ShaderPainter oldDelegate) => oldDelegate.time != time;
}
