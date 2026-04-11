import 'package:go_router/go_router.dart';
import 'package:shader_app/features/burn_effect/view/burn_effect_page.dart';
import 'package:shader_app/features/butterfly_forest/view/butterfly_forest_page.dart';
import 'package:shader_app/features/cyber_space_warehouse/view/cyber_space_warehouse_page.dart';
import 'package:shader_app/features/dive_cloud/view/dive_cloud_page.dart';
import 'package:shader_app/features/gradient_flow/view/gradient_flow_page.dart';
import 'package:shader_app/features/hail_mary_particles/view/hail_mary_particles_page.dart';
import 'package:shader_app/features/main/view/main_page.dart';
import 'package:shader_app/features/orb_effect/view/orb_effect_page.dart';
import 'package:shader_app/features/plasma/view/plasma_page.dart';
import 'package:shader_app/features/pyramid/view/pyramid_page.dart';
import 'package:shader_app/features/ripple_effect/view/ripple_effect_page.dart';
import 'package:shader_app/features/ripple_touch/view/ripple_touch_page.dart';
import 'package:shader_app/features/sun_vortex/view/sun_vortex_page.dart';
import 'package:shader_app/features/warp_counter/view/warp_counter_page.dart';
import 'package:shader_app/features/water_ripple/view/water_ripple_page.dart';
import 'package:shader_app/features/wave/view/wave_page.dart';
import 'package:shader_app/features/wavy_stripes/view/wavy_stripes_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (_, _) => const MainPage(),
      routes: <RouteBase>[
        GoRoute(
          path: 'wave',
          builder: (_, _) => const WavePage(),
        ),
        GoRoute(
          path: 'pyramid-fractal',
          builder: (_, _) => const PyramidPage(),
        ),
        GoRoute(
          path: 'water-ripple',
          builder: (_, _) => const WaterRipplePage(),
        ),
        GoRoute(
          path: 'ripple-effect',
          builder: (_, _) => const RippleEffectPage(),
        ),
        GoRoute(
          path: 'ripple-touch',
          builder: (_, _) => const RippleTouchPage(),
        ),
        GoRoute(
          path: 'gradient-flow',
          builder: (_, _) => const GradientFlowPage(),
        ),
        GoRoute(
          path: 'wavy-stripes',
          builder: (_, _) => const WavyStripesPage(),
        ),
        GoRoute(
          path: 'burn-effect',
          builder: (_, _) => const BurnEffectPage(),
        ),
        GoRoute(
          path: 'warp-effect',
          builder: (_, _) => const WarpCounterPage(),
        ),
        GoRoute(
          path: 'plasma-effect',
          builder: (_, _) => const PlasmaPage(),
        ),
        GoRoute(
          path: 'sun-vortex',
          builder: (_, _) => const SunVortexPage(),
        ),
        GoRoute(
          path: 'dive-cloud',
          builder: (_, _) => const DiveCloudPage(),
        ),
        GoRoute(
          path: 'butterfly-flock',
          builder: (_, _) => const ButterflyForestPage(),
        ),
        GoRoute(
          path: 'cyberspace-warehouse',
          builder: (_, _) => const CyberSpaceWarehousePage(),
        ),
        GoRoute(
          path: 'orb-effect',
          builder: (_, _) => const OrbEffectPage(),
        ),
        GoRoute(
          path: 'hail-mary',
          builder: (_, _) => const HailMaryParticlesPage(),
        ),
      ],
    ),
  ],
);
