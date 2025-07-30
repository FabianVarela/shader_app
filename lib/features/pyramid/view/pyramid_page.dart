import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class PyramidPage extends StatelessWidget {
  const PyramidPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PyramidView();
  }
}

class PyramidView extends StatefulWidget {
  const PyramidView({super.key});

  @override
  State<PyramidView> createState() => _PyramidViewState();
}

class _PyramidViewState extends State<PyramidView>
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
    _ticker.start();
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
        assetKey: 'shaders/pyramid_fractal.frag',
        child: SizedBox(width: screenSize.width, height: screenSize.height),
      ),
    );
  }
}
