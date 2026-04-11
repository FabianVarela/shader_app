# Shader App

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Flutter application showcasing various shader effects using Flutter's native shader support. Features a responsive
design that adapts to mobile, tablet, and desktop with an interactive shader gallery. Built with BLoC pattern, go_router
navigation, and supporting multiple environments.

## Prerequisites

Before getting started, make sure you have the following installed:

- **Flutter SDK**: >=3.10.0 <4.0.0
- **Dart SDK**: >=3.10.0 <4.0.0
- **IDE**: VSCode or Android Studio with Flutter extensions
- **Platforms**:
    - For iOS: Xcode (macOS only)
    - For Android: Android Studio or Android SDK
    - For Web: Google Chrome
    - For Windows: Visual Studio 2019 or later

## Initial Setup

### 1. Clone the repository

```bash
git clone <repository-url>
cd shader_app
```

### 2. Install dependencies

```bash
flutter pub get
```

## Development

### Available Flavors

This project contains 3 flavors for different environments:

- **development**: For local development and testing
- **staging**: For pre-production testing
- **production**: For production releases

### Run in development mode

#### Using VSCode/Android Studio

Use the launch configuration in your IDE to select the desired flavor.

#### Using command line

```bash
# Development
flutter run --flavor development --target lib/main_development.dart

# Staging
flutter run --flavor staging --target lib/main_staging.dart

# Production
flutter run --flavor production --target lib/main_production.dart
```

### Run on specific platforms

```bash
# iOS
flutter run --flavor development --target lib/main_development.dart -d iPhone

# Android
flutter run --flavor development --target lib/main_development.dart -d android

# Web
flutter run --flavor development --target lib/main_development.dart -d chrome

# Windows
flutter run --flavor development --target lib/main_development.dart -d windows
```

### Build for production

```bash
# iOS
flutter build ios --flavor production --target lib/main_production.dart

# Android
flutter build appbundle --flavor production --target lib/main_production.dart

# Web
flutter build web --target lib/main_production.dart

# Windows
flutter build windows --target lib/main_production.dart
```

## Project Structure

```
lib/
├── l10n/                    # Localization files
│   ├── arb/                # .arb files for translations
│   └── gen/                # Generated localization files
├── app/                    # App initialization and configuration
│   ├── gen/                # Generated assets
│   ├── models/             # App-wide models
│   │   ├── shader_model.dart  # Shader data model
│   │   └── shader_list.dart   # Shader gallery data
│   ├── router/             # Navigation configuration
│   │   └── app_router.dart    # go_router setup
│   └── view/               # App widget
├── features/               # Feature modules
│   ├── main/               # Responsive shader gallery
│   ├── burn_effect/        # Burn effect shader
│   ├── butterfly_forest/   # Butterfly flock animation
│   ├── cyber_space_warehouse/ # Cyberspace grid shader
│   ├── dive_cloud/         # Cloud diving shader
│   ├── gradient_flow/      # Gradient flow shader
│   ├── hail_mary_particles/# Particle system shader
│   ├── orb_effect/         # Orb prismatic effect
│   ├── plasma/             # Plasma effect shader
│   ├── pyramid/            # Pyramid fractal shader
│   ├── ripple_effect/      # Ripple effect shader
│   ├── ripple_touch/       # Touch ripple shader
│   ├── sun_vortex/         # Sun vortex ray-marching
│   ├── warp_counter/       # Warp effect shader
│   ├── water_ripple/       # Water ripple shader
│   ├── wave/               # Seascape shader
│   └── wavy_stripes/       # Wavy stripes shader
├── shaders/                # GLSL shader files
│   ├── burn_effect.frag
│   ├── gradient_flow.frag
│   ├── orb_effect.frag
│   ├── plasma_effect.frag
│   ├── pyramid_fractal.frag
│   ├── ripple_effect.frag
│   ├── ripple_touch.frag
│   ├── seascape.frag
│   ├── warp_effect.frag
│   ├── water_ripple.frag
│   └── wavy_stripes.frag
└── assets/                 # Static assets
    └── thumbnails/         # Shader preview thumbnails
```

## Features

### Responsive Design

The shader gallery adapts to different screen sizes:

- **Mobile (<600px)**: Vertical list view with full-width cards
- **Tablet (600-899px)**: 2-column grid layout
- **Desktop Small (900-1199px)**: 3-column grid layout
- **Desktop (≥1200px)**: 4-column grid layout

### Shaders

This project showcases the following shader effects:

1. **Seascape** (PROCEDURAL / NOISE): Realistic ocean wave simulation
2. **Pyramid Fractal** (FRACTAL / CINE SHADER): Geometric fractal pattern
3. **Water Ripple** (SIMULATION / WATER): Simple water ripple effect
4. **Ripple Effect** (SIMULATION / IMAGE): Circular ripple animation
5. **Ripple Touch** (INTERACTIVE / NEW): Interactive touch ripples
6. **Gradient Flow** (FEATURED / NEW): Flowing gradient colors
7. **Wavy Stripes** (SINE / POLAR ANGLE): Animated wavy stripe pattern
8. **Burn Effect** (EFFECTS / POPULAR): Fire/burn animation effect
9. **Warp Effect** (DISTORTION / POPULAR): Space warp distortion
10. **Plasma Effect** (PLASMA / GOLF): Plasma energy effect
11. **Sun Vortex** (RAY-MARCHING / ABSTRACT): Abstract sun vortex animation
12. **Dive Cloud** (CLOUD / CINE SHADER): Cloud diving experience
13. **Butterfly Flock** (BUTTERFLIES / FLOC): Butterfly flock simulation
14. **Cyberspace Warehouse** (GRID / HEXAGONAL): Hexagonal grid space
15. **Orb Effect** (PARTICLES / PRISMA): Prismatic orb particle effect
16. **Hail Mary** (PARTICLES / TRENDING): Trending particle system

All shader files are located in the `shaders/` directory and are written in GLSL (OpenGL Shading Language).

## Main Dependencies

- **flutter_bloc**: State management using BLoC pattern
- **bloc**: Core BLoC library
- **go_router**: Declarative routing and navigation
- **flutter_shaders**: Flutter shader support
- **flutter_localizations**: Internationalization support
- **intl**: Internationalization and localization utilities
- **vector_math**: Vector and matrix math operations

### Dev Dependencies

- **bloc_test**: Testing utilities for BLoC
- **mocktail**: Mocking library for tests
- **very_good_analysis**: Strict lint rules

## Contributing

1. Create a branch from `main`
2. Make your changes
3. Run tests: `flutter test`
4. Run analysis: `flutter analyze`
5. Format code: `flutter format .`
6. Create a Pull Request to `main`

## License

This project is licensed under the MIT License - see the [LICENSE](https://opensource.org/licenses/MIT) for details.

---

Generated by the [Very Good CLI][very_good_cli_link] 🤖

[coverage_badge]: coverage_badge.svg

[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html

[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg

[license_link]: https://opensource.org/licenses/MIT

[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg

[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis

[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
