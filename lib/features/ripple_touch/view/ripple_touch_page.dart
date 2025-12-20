import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class RippleTouchPage extends StatelessWidget {
  const RippleTouchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RippleTouchView();
  }
}

class RippleTouchView extends StatefulWidget {
  const RippleTouchView({super.key});

  @override
  State<RippleTouchView> createState() => _RippleTouchViewState();
}

class _RippleTouchViewState extends State<RippleTouchView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Offset _pointer = .zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const .all(24),
          child: Listener(
            onPointerMove: _updatePointer,
            onPointerDown: _updatePointer,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, child) => ShaderBuilder(
                (context, shader, child) {
                  return AnimatedSampler(
                    (image, size, canvas) {
                      shader
                        ..setFloat(0, size.width)
                        ..setFloat(1, size.height)
                        ..setFloat(2, _pointer.dx)
                        ..setFloat(3, _pointer.dy)
                        ..setFloat(4, _controller.value * 10)
                        ..setImageSampler(0, image);

                      canvas.drawRect(
                        Rect.fromLTWH(0, 0, size.width, size.height),
                        Paint()..shader = shader,
                      );
                    },
                    child: child!,
                  );
                },
                assetKey: 'shaders/ripple_touch.frag',
                child: child,
              ),
              child: Padding(
                padding: const .all(8),
                child: AspectRatio(
                  aspectRatio: .7,
                  child: ClipRRect(
                    borderRadius: .circular(8),
                    child: Image.asset('assets/dash.jpg', fit: .cover),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updatePointer(PointerEvent details) {
    _controller.reset();
    unawaited(_controller.forward());

    setState(() => _pointer = details.localPosition);
  }
}
