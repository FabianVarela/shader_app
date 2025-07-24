import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shader_app/features/wave/widgets/shader_painter.dart';

class WavePage extends StatelessWidget {
  const WavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WaveView();
  }
}

class WaveView extends StatefulWidget {
  const WaveView({super.key});

  @override
  State<WaveView> createState() => _WaveViewState();
}

class _WaveViewState extends State<WaveView> with TickerProviderStateMixin {
  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..repeat();

  int _startTime = 0;
  FragmentShader? _fragmentShader;

  @override
  void initState() {
    super.initState();
    _loadShader('seascape.frag');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final shader = _fragmentShader;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox.fromSize(
              size: Size(size.width, size.height),
              child: Builder(
                builder: (_) {
                  if (shader == null) return const CircularProgressIndicator();

                  _startTime = DateTime.now().millisecondsSinceEpoch;
                  shader
                    ..setFloat(1, size.width)
                    ..setFloat(2, size.height);

                  return AnimatedBuilder(
                    animation: _animationController,
                    builder: (_, _) {
                      shader.setFloat(0, _elapsedTimeInSeconds);
                      return CustomPaint(
                        painter: ShaderPainter(shader: shader),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  double get _elapsedTimeInSeconds {
    return (DateTime.now().millisecondsSinceEpoch - _startTime) / 1000;
  }

  Future<void> _loadShader(String fileName) async {
    final program = await FragmentProgram.fromAsset('shaders/$fileName');
    setState(() => _fragmentShader = program.fragmentShader());
  }
}
