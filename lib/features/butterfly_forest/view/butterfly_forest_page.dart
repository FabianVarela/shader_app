import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shader_app/app/gen/assets.gen.dart';
import 'package:shader_app/features/butterfly_forest/widget/butterfly_shader_widget.dart';

class ButterflyForestPage extends StatelessWidget {
  const ButterflyForestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ButterflyForestView();
  }
}

class ButterflyForestView extends StatelessWidget {
  const ButterflyForestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<_ButterflyAssets>(
        future: _loadAll(),
        builder: (_, snap) {
          if (snap.hasError) {
            return Center(
              child: Text(
                'Error cargando shader:\n${snap.error}',
                textAlign: .center,
              ),
            );
          }

          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ButterflyWidget(
            program: snap.data!.program,
            noiseImage: snap.data!.noiseImage,
            envImage: snap.data!.envImage,
          );
        },
      ),
    );
  }

  Future<_ButterflyAssets> _loadAll() async {
    final results = await Future.wait([
      ui.FragmentProgram.fromAsset('shaders/butterfly_flock.frag'),
      _loadImage(Assets.resources.noiseRgba),
      _loadImage(Assets.resources.forestSlope4k),
    ]);

    return _ButterflyAssets(
      program: results[0] as ui.FragmentProgram,
      noiseImage: results[1] as ui.Image,
      envImage: results[2] as ui.Image,
    );
  }

  Future<ui.Image> _loadImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());

    final frame = await codec.getNextFrame();
    return frame.image;
  }
}

class _ButterflyAssets {
  const _ButterflyAssets({
    required this.program,
    required this.noiseImage,
    required this.envImage,
  });

  final ui.FragmentProgram program;
  final ui.Image noiseImage;
  final ui.Image envImage;
}
