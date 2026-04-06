import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class NebulosaPainter extends CustomPainter {
  const NebulosaPainter({
    required this.shader,
    required this.time,
    this.speed = .07,
    this.scale = 1.6,
    this.warp2 = 4.9,
    this.greenBright = .75,
    this.orange = 1,
    this.magenta = .24,
    this.contrast = 2,
    this.vig = 0,
  });

  final ui.FragmentShader shader;
  final double time;
  final double speed;
  final double scale;
  final double warp2;
  final double greenBright;
  final double orange;
  final double magenta;
  final double contrast;
  final double vig;

  @override
  void paint(Canvas c, Size s) {
    shader
      ..setFloat(0, s.width)
      ..setFloat(1, s.height)
      ..setFloat(2, time)
      ..setFloat(3, speed)
      ..setFloat(4, scale)
      ..setFloat(5, warp2)
      ..setFloat(6, greenBright)
      ..setFloat(7, orange)
      ..setFloat(8, magenta)
      ..setFloat(9, contrast)
      ..setFloat(10, vig);
    c.drawRect(Offset.zero & s, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(NebulosaPainter o) => o.time != time;
}

class ParticlesPainter extends CustomPainter {
  const ParticlesPainter({
    required this.shader,
    required this.time,
    this.speed = 0.75,
    this.density = 40,
    this.particleSize = 1.8,
    this.spread = 0.6,
    this.particleBright = 1,
    this.nebulosaBright = 0.75,
    this.nebulosaScale = 2,
    this.vig = 0,
  });

  final ui.FragmentShader shader;
  final double time;
  final double speed;
  final double density;
  final double particleSize;
  final double spread;
  final double particleBright;
  final double nebulosaBright;
  final double nebulosaScale;
  final double vig;

  @override
  void paint(Canvas c, Size s) {
    shader
      ..setFloat(0, s.width)
      ..setFloat(1, s.height)
      ..setFloat(2, time)
      ..setFloat(3, speed)
      ..setFloat(4, density)
      ..setFloat(5, particleSize)
      ..setFloat(6, spread)
      ..setFloat(7, particleBright)
      ..setFloat(8, nebulosaBright)
      ..setFloat(9, nebulosaScale)
      ..setFloat(10, vig);

    c.drawRect(Offset.zero & s, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(ParticlesPainter o) => o.time != time;
}
