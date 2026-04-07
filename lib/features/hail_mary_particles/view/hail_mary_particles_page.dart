import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:shader_app/features/hail_mary_particles/widgets/hail_mary_painter.dart';

class HailMaryParticlesPage extends StatelessWidget {
  const HailMaryParticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HailMaryParticlesView();
  }
}

class HailMaryParticlesView extends StatefulWidget {
  const HailMaryParticlesView({super.key});

  @override
  State<HailMaryParticlesView> createState() => _HailMaryParticlesViewState();
}

class _HailMaryParticlesViewState extends State<HailMaryParticlesView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _transitionController;
  late Animation<double> _fadeAnimation;

  List<ui.FragmentShader>? _shaders;
  bool _showParticles = false;
  bool _needsShaderSwitch = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(hours: 1),
    );
    unawaited(_controller.repeat());

    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 1,
              end: 0,
            ).chain(CurveTween(curve: Curves.easeOut)),
            weight: 50,
          ),
          TweenSequenceItem(
            tween: Tween<double>(
              begin: 0,
              end: 1,
            ).chain(CurveTween(curve: Curves.easeIn)),
            weight: 50,
          ),
        ]).animate(_transitionController)..addListener(() {
          if (_fadeAnimation.value <= 0.01 && _needsShaderSwitch) {
            setState(() {
              _showParticles = !_showParticles;
              _needsShaderSwitch = false;
            });
          }
        });

    unawaited(_loadShaders());
  }

  @override
  void dispose() {
    _controller.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasShaders = _shaders != null && (_shaders ?? []).isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.black,
      body: !hasShaders
          ? const Center(child: CircularProgressIndicator())
          : AnimatedBuilder(
              animation: Listenable.merge([_controller, _transitionController]),
              builder: (_, _) => Opacity(
                opacity: _fadeAnimation.value,
                child: SizedBox.expand(
                  child: CustomPaint(
                    painter: switch (_showParticles) {
                      true => ParticlesPainter(
                        shader: _shaders![1],
                        time: _controller.value * 3600,
                      ),
                      false => NebulosaPainter(
                        shader: _shaders![0],
                        time: _controller.value * 3600,
                      ),
                    },
                  ),
                ),
              ),
            ),
      floatingActionButton: switch (hasShaders) {
        true => FloatingActionButton(
          onPressed: _startTransition,
          child: _showParticles
              ? const Icon(Icons.public)
              : const Icon(Icons.snowing),
        ),
        false => const SizedBox.shrink(),
      },
    );
  }

  void _startTransition() {
    if (_transitionController.isAnimating) return;
    _needsShaderSwitch = true;

    unawaited(
      _transitionController.forward(from: 0).then((_) {
        _transitionController.reset();
      }),
    );
  }

  Future<void> _loadShaders() async {
    final shaders = await Future.wait([
      ui.FragmentProgram.fromAsset('shaders/hail_mary_nebulosa.frag'),
      ui.FragmentProgram.fromAsset('shaders/hail_mary_particles.frag'),
    ]);

    if (mounted) {
      setState(() {
        _shaders = shaders.map((e) => e.fragmentShader()).toList();
      });
    }
  }
}
