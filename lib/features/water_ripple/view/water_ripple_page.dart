import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shader_app/features/water_ripple/widgets/shader_painter.dart';

class WaterRipplePage extends StatelessWidget {
  const WaterRipplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WaterRippleView();
  }
}

class WaterRippleView extends StatefulWidget {
  const WaterRippleView({super.key});

  @override
  State<WaterRippleView> createState() => _WaterRippleViewState();
}

class _WaterRippleViewState extends State<WaterRippleView> {
  late Ticker _ticker;
  late double _delta;

  @override
  void initState() {
    super.initState();

    _delta = 0;
    _ticker = Ticker((elapsedTime) {
      setState(() => _delta += 1 / 60);
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

    return Scaffold(
      body: FutureBuilder<FragmentShader>(
        future: _loadShader('water_ripple.frag'),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return const Offstage();

          return CustomPaint(
            size: Size(size.width, size.height),
            painter: ShaderPainter(
              shader: snapshot.data!
                ..setFloat(0, _delta)
                ..setFloat(1, size.width)
                ..setFloat(2, size.height),
            ),
          );
        },
      ),
    );
  }

  Future<FragmentShader> _loadShader(String fileName) async {
    final program = await FragmentProgram.fromAsset('shaders/$fileName');
    return program.fragmentShader();
  }
}
