import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class PlasmaPage extends StatelessWidget {
  const PlasmaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlasmaView();
  }
}

class PlasmaView extends StatefulWidget {
  const PlasmaView({super.key});

  @override
  State<PlasmaView> createState() => _PlasmaViewState();
}

class _PlasmaViewState extends State<PlasmaView>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _time = 0;

  @override
  void initState() {
    super.initState();

    _ticker = createTicker((elapsed) {
      _time += 0.015;
      setState(() {});
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
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: ShaderBuilder(
        (_, shader, child) => AnimatedSampler(
          (_, size, canvas) {
            shader
              ..setFloat(0, _time)
              ..setFloat(1, size.width)
              ..setFloat(2, size.height);
            canvas.drawPaint(Paint()..shader = shader);
          },
          child: child!,
        ),
        assetKey: 'shaders/plasma_effect.frag',
        child: SizedBox(width: screenSize.width, height: screenSize.height),
      ),
    );
  }
}
