import 'dart:ui';

import 'package:flutter/material.dart';

class ButterflyPainter extends CustomPainter {
  const ButterflyPainter({
    required this.shader,
    required this.time,
    this.mousePos = .zero,
    this.mouseClick = .zero,
  });

  final FragmentShader shader;
  final double time;
  final Offset mousePos;
  final Offset mouseClick;

  @override
  void paint(Canvas canvas, Size size) {
    var i = 0;

    shader
      ..setFloat(i++, time)
      ..setFloat(i++, size.width)
      ..setFloat(i++, size.height)
      ..setFloat(i++, mousePos.dx)
      ..setFloat(i++, mousePos.dy)
      ..setFloat(i++, mouseClick.dx)
      ..setFloat(i++, mouseClick.dy);

    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(ButterflyPainter old) =>
      old.time != time ||
      old.mousePos != mousePos ||
      old.mouseClick != mouseClick;
}
