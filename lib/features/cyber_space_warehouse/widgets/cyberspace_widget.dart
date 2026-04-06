import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shader_app/features/cyber_space_warehouse/widgets/cyberspace_painter.dart';

class CyberspaceWidget extends StatefulWidget {
  const CyberspaceWidget({required this.program, super.key});

  final ui.FragmentProgram program;

  @override
  State<CyberspaceWidget> createState() => _CyberspaceWidgetState();
}

class _CyberspaceWidgetState extends State<CyberspaceWidget>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late final ui.FragmentShader _shader;

  double _time = 0;

  @override
  void initState() {
    super.initState();

    _shader = widget.program.fragmentShader();
    _ticker = createTicker((elapsed) {
      setState(() => _time = elapsed.inMicroseconds / 1e6);
    });

    unawaited(_ticker.start());
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return SizedBox.fromSize(
      size: Size(size.width, size.height),
      child: CustomPaint(
        painter: CyberspacePainter(shader: _shader, time: _time),
      ),
    );
  }
}
