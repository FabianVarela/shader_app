import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shader_app/features/dive_cloud/widgets/shader_painter.dart';

class DiveCloudPage extends StatelessWidget {
  const DiveCloudPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DiveCloudView();
  }
}

class DiveCloudView extends StatefulWidget {
  const DiveCloudView({super.key});

  @override
  State<DiveCloudView> createState() => _DiveCloudViewState();
}

class _DiveCloudViewState extends State<DiveCloudView> {
  late Timer _timer;

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
                painter: ShaderPainter(shader: _shader!, time: _delta),
              ),
            ),
    );
  }

  Future<void> _loadMyShader() async {
    final program = await FragmentProgram.fromAsset(
      'shaders/dive_cloud.frag',
    );

    _shader = program.fragmentShader();
    setState(() {});

    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      setState(() => _delta += 1 / 60);
    });
  }
}
