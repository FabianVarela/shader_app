import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class OrbPainter extends CustomPainter {
  OrbPainter({required this.shader, required this.time});

  final ui.FragmentShader shader;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, time)
      ..setFloat(1, size.width)
      ..setFloat(2, size.height);

    final paint = Paint()..shader = shader;
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(OrbPainter old) => old.time != time;
}
