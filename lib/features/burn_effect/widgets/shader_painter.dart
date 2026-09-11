import 'dart:ui';

import 'package:material_ui/material_ui.dart';

class ShaderPainter extends CustomPainter {
  new({required this.shader, super.repaint});

  final FragmentShader shader;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height);

    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
