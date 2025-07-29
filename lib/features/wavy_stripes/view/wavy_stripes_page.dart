import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shader_app/features/wavy_stripes/widgets/shader_painter.dart';

class WavyStripesPage extends StatelessWidget {
  const WavyStripesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WavyStripesView();
  }
}

class WavyStripesView extends StatefulWidget {
  const WavyStripesView({super.key});

  @override
  State<WavyStripesView> createState() => _WavyStripesViewState();
}

class _WavyStripesViewState extends State<WavyStripesView> {
  late Timer _timer;
  FragmentShader? _shader;

  var _delta = 0.0;

  @override
  void initState() {
    super.initState();
    _loadShader();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final screenIncrement = switch (defaultTargetPlatform) {
      TargetPlatform.android || TargetPlatform.iOS => 3,
      _ => 1,
    };

    return Scaffold(
      body: _shader == null
          ? const Center(child: CircularProgressIndicator())
          : SizedBox.fromSize(
              size: Size(size.width, size.height),
              child: CustomPaint(
                painter: ShaderPainter(
                  shader: _shader!,
                  incrementSize: screenIncrement,
                  time: _delta,
                ),
              ),
            ),
    );
  }

  Future<void> _loadShader() async {
    final program = await FragmentProgram.fromAsset(
      'shaders/wavy_stripes.frag',
    );
    setState(() => _shader = program.fragmentShader());

    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      setState(() => _delta += 1 / 60);
    });
  }
}
