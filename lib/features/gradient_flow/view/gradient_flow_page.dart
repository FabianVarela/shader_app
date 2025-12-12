import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shader_app/features/gradient_flow/widgets/shader_painter.dart';

class GradientFlowPage extends StatelessWidget {
  const GradientFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GradientFlowView();
  }
}

class GradientFlowView extends StatefulWidget {
  const GradientFlowView({super.key});

  @override
  State<GradientFlowView> createState() => _GradientFlowViewState();
}

class _GradientFlowViewState extends State<GradientFlowView> {
  late Timer _timer;
  final List<Color> _colors = [];

  FragmentShader? _shader;
  double _delta = 0;

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
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: _shader == null
          ? const Center(child: CircularProgressIndicator())
          : SizedBox.fromSize(
              size: Size(size.width, size.height),
              child: CustomPaint(
                painter: ShaderPainter(
                  shader: _shader!,
                  colors: _colors,
                  time: _delta,
                ),
              ),
            ),
    );
  }

  Future<void> _loadMyShader() async {
    final program = await FragmentProgram.fromAsset(
      'shaders/gradient_flow.frag',
    );

    _shader = program.fragmentShader();
    _colors.addAll(
      [_generateColor, _generateColor, _generateColor, _generateColor],
    );

    setState(() {});

    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() => _delta += 1 / 60);
    });
  }

  Color get _generateColor {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }
}
