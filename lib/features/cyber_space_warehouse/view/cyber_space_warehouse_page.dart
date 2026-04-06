import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:shader_app/features/cyber_space_warehouse/widgets/cyberspace_widget.dart';

class CyberSpaceWarehousePage extends StatelessWidget {
  const CyberSpaceWarehousePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CyberSpaceWarehouseView();
  }
}

class CyberSpaceWarehouseView extends StatelessWidget {
  const CyberSpaceWarehouseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ui.FragmentProgram>(
        future: ui.FragmentProgram.fromAsset(
          'shaders/cyberspace_warehouse.frag',
        ),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error cargando shader:\n${snapshot.error}',
                textAlign: .center,
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return CyberspaceWidget(program: snapshot.data!);
        },
      ),
    );
  }
}
