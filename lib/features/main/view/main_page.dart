import 'package:flutter/material.dart';
import 'package:shader_app/features/pyramid/view/pyramid_page.dart';
import 'package:shader_app/features/wave/view/wave_page.dart';

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
