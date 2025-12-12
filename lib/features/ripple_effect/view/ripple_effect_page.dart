import 'dart:async';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shader_app/features/ripple_effect/widgets/shader_painter.dart';

class RippleEffectPage extends StatelessWidget {
  const RippleEffectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RippleEffectView();
  }
}

class RippleEffectView extends StatefulWidget {
  const RippleEffectView({super.key});

  @override
  State<RippleEffectView> createState() => _RippleEffectViewState();
}

class _RippleEffectViewState extends State<RippleEffectView> {
  late Timer _timer;

  double _delta = 0;

  FragmentShader? _shader;
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    unawaited(_loadMyShader());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _shader == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: <Widget>[
                Positioned.fill(
                  child: CustomPaint(
                    painter: ShaderPainter(_shader!, [_delta], [_image]),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _loadMyShader() async {
    final imageData = await rootBundle.load('assets/dash.jpg');
    _image = await decodeImageFromList(imageData.buffer.asUint8List());

    final program = await FragmentProgram.fromAsset(
      'shaders/ripple_effect.frag',
    );
    _shader = program.fragmentShader();
    setState(() {});

    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() => _delta += 1 / 60);
    });
  }
}
