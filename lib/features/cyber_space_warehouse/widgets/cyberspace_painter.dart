import 'dart:ui' as ui;

import 'package:material_ui/material_ui.dart';

class CyberspacePainter extends CustomPainter {
  const new({required this.shader, required this.time});

  final ui.FragmentShader shader;
  final double time;

  @override
  void paint(Canvas canvas, Size size) {
    var i = 0;

    shader
      ..setFloat(i++, time)
      ..setFloat(i++, size.width)
      ..setFloat(i++, size.height);

    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(CyberspacePainter old) => old.time != time;
}
