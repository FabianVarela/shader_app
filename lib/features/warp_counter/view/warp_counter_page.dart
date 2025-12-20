import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class WarpCounterPage extends StatelessWidget {
  const WarpCounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WarpCounterView();
  }
}

class WarpCounterView extends StatefulWidget {
  const WarpCounterView({super.key});

  @override
  State<WarpCounterView> createState() => _WarpCounterViewState();
}

class _WarpCounterViewState extends State<WarpCounterView>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;

  int _counter = 0;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();

    _ticker = createTicker((elapsed) {
      setState(() => _elapsed = elapsed);
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
    return Scaffold(
      body: ShaderBuilder(
        (_, shader, _) => Center(
          child: ShaderMask(
            shaderCallback: (bounds) {
              shader
                ..setFloat(0, bounds.width * 5)
                ..setFloat(1, bounds.height * 5)
                ..setFloat(2, _elapsed.inMilliseconds.toDouble() / 1000);
              return shader;
            },
            blendMode: .srcIn,
            child: Text(
              '$_counter',
              style: const TextStyle(fontWeight: .w900, fontSize: 200),
            ),
          ),
        ),
        assetKey: 'shaders/warp_effect.frag',
      ),
      floatingActionButton: Column(
        spacing: 8,
        mainAxisAlignment: .end,
        crossAxisAlignment: .end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'Increment',
            onPressed: _increment,
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            heroTag: 'Decrement',
            onPressed: _decrement,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }

  void _increment() => setState(() => _counter++);

  void _decrement() => setState(() => _counter--);
}
