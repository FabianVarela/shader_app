import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shader_app/app/models/shader_list.dart';
import 'package:shader_app/app/models/shader_model.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.dashboard, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text(
          'Shader Feed',
          style: TextStyle(color: Colors.white, fontWeight: .bold),
        ),
      ),
      body: ListView.separated(
        padding: const .all(16),
        itemCount: shaderList.length,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (_, index) => _ShaderCard(
          shader: shaderList[index],
          onTap: () => context.push(shaderList[index].path),
        ),
      ),
    );
  }
}

class _ShaderCard extends StatelessWidget {
  const _ShaderCard({required this.shader, required this.onTap});

  final ShaderModel shader;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      clipBehavior: .antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: .circular(16)),
      child: ClipRRect(
        borderRadius: .circular(16),
        child: Stack(
          children: <Widget>[
            AspectRatio(
              aspectRatio: .8,
              child: Image.asset(shader.thumbnail, fit: .cover),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: .topCenter,
                    end: .bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: .3),
                      Colors.black.withValues(alpha: .7),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: const .all(16),
                child: Row(
                  spacing: 8,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        spacing: 4,
                        crossAxisAlignment: .start,
                        children: <Widget>[
                          _CategoryTag(text: shader.category),
                          Text(
                            shader.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: .bold,
                            ),
                          ),
                          Text(
                            'By ${shader.author}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: .8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      style: IconButton.styleFrom(
                        iconSize: 28,
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF7B68EE),
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(100),
                        ),
                      ),
                      onPressed: onTap,
                      icon: const Icon(Icons.play_arrow),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTag extends StatelessWidget {
  const _CategoryTag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: .circular(12),
        color: Colors.white.withValues(alpha: .2),
      ),
      child: Padding(
        padding: const .symmetric(horizontal: 8, vertical: 4),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            letterSpacing: .5,
          ),
        ),
      ),
    );
  }
}
