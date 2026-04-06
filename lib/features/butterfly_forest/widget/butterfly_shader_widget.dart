import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shader_app/features/butterfly_forest/widget/butterfly_painter.dart';

class ButterflyWidget extends StatefulWidget {
  const ButterflyWidget({
    required this.program,
    required this.noiseImage,
    required this.envImage,
    super.key,
  });

  final ui.FragmentProgram program;
  final ui.Image noiseImage;
  final ui.Image envImage;

  @override
  State<ButterflyWidget> createState() => _ButterflyWidgetState();
}

class _ButterflyWidgetState extends State<ButterflyWidget>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late final ui.FragmentShader _shader;

  double _time = 0;

  Offset _mousePos = .zero;
  Offset _mouseClick = .zero;

  @override
  void initState() {
    super.initState();
    _shader = widget.program.fragmentShader();

    _shader
      ..setImageSampler(0, widget.noiseImage)
      ..setImageSampler(1, widget.envImage);

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
      child: GestureDetector(
        onPanUpdate: (d) {
          setState(() => _mousePos = d.localPosition);
        },
        onTapDown: (d) {
          setState(() {
            _mousePos = d.localPosition;
            _mouseClick = d.localPosition;
          });
        },
        child: CustomPaint(
          painter: ButterflyPainter(
            shader: _shader,
            time: _time,
            mousePos: _mousePos,
            mouseClick: _mouseClick,
          ),
        ),
      ),
    );
  }
}
