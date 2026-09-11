import 'dart:ui';

import 'package:material_ui/material_ui.dart';

class ShaderPainter extends CustomPainter {
  new({required this.shader, super.repaint});

  final FragmentShader shader;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPaint(Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
