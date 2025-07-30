import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shader_app/features/burn_effect/widgets/shader_painter.dart';

class BurnEffectPage extends StatelessWidget {
  const BurnEffectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BurnEffectView();
  }
}

class BurnEffectView extends StatefulWidget {
  const BurnEffectView({super.key});

  @override
  State<BurnEffectView> createState() => _BurnEffectViewState();
}

class _BurnEffectViewState extends State<BurnEffectView> {
  Timer? _timer;
  ui.FragmentShader? _shader;

  ui.Image? _image;

  var _deltaTime = 0.0;

  bool _isPlaying = false;
  bool _isCompleted = false;
  bool _isRestored = false;

  @override
  void initState() {
    super.initState();
    _loadShader();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _shader == null || _image == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                spacing: 8,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: AspectRatio(
                        aspectRatio: _image!.width / _image!.height,
                        child: CustomPaint(
                          painter: ShaderPainter(shader: _shader!),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isCompleted && !_isRestored
                        ? _restore
                        : _startAnimation,
                    child: AnimatedSwitcher(
                      duration: Durations.medium4,
                      child: _isCompleted && !_isRestored
                          ? Text('Restore', key: UniqueKey())
                          : Text('Burn it!!!', key: UniqueKey()),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _loadShader() async {
    final program = await ui.FragmentProgram.fromAsset(
      'shaders/burn_effect.frag',
    );
    _shader = program.fragmentShader();

    _image = await _decodeImage();
    if (_image == null && !mounted) return;

    final canvas = await _takeCanvasPicture(
      (_image!.width, _image!.height),
      Theme.of(context).scaffoldBackgroundColor,
    );

    _shader!
      ..setImageSampler(0, _image!)
      ..setImageSampler(1, canvas)
      ..setFloat(2, _deltaTime);

    setState(() {});
  }

  Future<ui.Image> _decodeImage() async {
    final bundleImage = await DefaultAssetBundle.of(
      context,
    ).load('assets/dash_vertical.jpg');

    final bytes = bundleImage.buffer.asUint8List();
    final codec = await ui.instantiateImageCodec(Uint8List.fromList(bytes));
    final frame = await codec.getNextFrame();

    return frame.image;
  }

  Future<ui.Image> _takeCanvasPicture((int, int) size, Color color) async {
    final (width, height) = size;

    final paint = Paint()..color = color;
    final recorder = ui.PictureRecorder();

    final rect = Rect.fromLTRB(0, 0, width.toDouble(), height.toDouble());
    Canvas(recorder).drawRect(rect, paint);

    final picture = recorder.endRecording();
    return picture.toImage(width, height);
  }

  void _startAnimation() {
    if (_isPlaying) return;

    setState(() {
      _isCompleted = false;
      _isPlaying = true;
      _deltaTime = 0;
      _isRestored = false;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      setState(() {
        _deltaTime += 0.016;
        _shader!.setFloat(2, _deltaTime);
      });
      if (_deltaTime >= 3) _stopAnimation();
    });
  }

  void _stopAnimation() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _isCompleted = true;
    });
  }

  void _restore() {
    setState(() => _isRestored = true);
    _shader!.setFloat(2, 0);
  }
}
