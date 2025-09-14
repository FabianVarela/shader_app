import 'package:flutter/material.dart';
import 'package:shader_app/features/burn_effect/view/burn_effect_page.dart';
import 'package:shader_app/features/gradient_flow/view/gradient_flow_page.dart';
import 'package:shader_app/features/plasma/view/plasma_page.dart';
import 'package:shader_app/features/pyramid/view/pyramid_page.dart';
import 'package:shader_app/features/ripple_effect/view/ripple_effect_page.dart';
import 'package:shader_app/features/ripple_touch/view/ripple_touch_page.dart';
import 'package:shader_app/features/warp_counter/view/warp_counter_page.dart';
import 'package:shader_app/features/water_ripple/view/water_ripple_page.dart';
import 'package:shader_app/features/wave/view/wave_page.dart';
import 'package:shader_app/features/wavy_stripes/view/wavy_stripes_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainView();
  }
}

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonList = <({String text, Widget page})>[
      (text: 'Wave Shader', page: const WavePage()),
      (text: 'Pyramid fractal Shader', page: const PyramidPage()),
      (text: 'Watter ripple Shader', page: const WaterRipplePage()),
      (text: 'Ripple effect Shader', page: const RippleEffectPage()),
      (text: 'Ripple touch Shader', page: const RippleTouchPage()),
      (text: 'Gradient flow Shader', page: const GradientFlowPage()),
      (text: 'Wavy stripes Shader', page: const WavyStripesPage()),
      (text: 'Burn effect Shader', page: const BurnEffectPage()),
      (text: 'Warp effect Shader', page: const WarpCounterPage()),
      (text: 'Plasma effect Shader', page: const PlasmaPage()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Shaders example')),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (final item in buttonList)
              ElevatedButton(
                onPressed: () => _goToPage(context, item.page),
                child: Text(item.text),
              ),
          ],
        ),
      ),
    );
  }

  void _goToPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));
  }
}
