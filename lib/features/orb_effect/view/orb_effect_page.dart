import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shader_app/features/orb_effect/widgets/orb_painter.dart';

class OrbEffectPage extends StatelessWidget {
  const OrbEffectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const OrbEffectView();
  }
}

class OrbEffectView extends StatefulWidget {
  const OrbEffectView({super.key, this.size = 400});

  final double size;

  @override
  State<OrbEffectView> createState() => _OrbEffectViewState();
}

class _OrbEffectViewState extends State<OrbEffectView>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  ui.FragmentShader? _shader;
  double _time = 0;

  @override
  void initState() {
    super.initState();

    _ticker = Ticker((elapsed) {
      if (mounted) setState(() => _time = elapsed.inMicroseconds / 1e6);
    });
    unawaited(_loadShader());
  }

  Future<void> _loadShader() async {
    final program = await ui.FragmentProgram.fromAsset(
      'shaders/orb_effect.frag',
    );

    if (mounted) {
      setState(() => _shader = program.fragmentShader());
      unawaited(_ticker.start());
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: _shader == null
          ? const Center(child: CircularProgressIndicator())
          : SizedBox.fromSize(
              size: Size(size.width, size.height),
              child: CustomPaint(
                painter: OrbPainter(shader: _shader!, time: _time),
              ),
            ),
    );
  }
}
