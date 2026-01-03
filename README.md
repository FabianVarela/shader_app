# Shader App

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

Flutter application showcasing various shader effects using Flutter's native shader support. Built with BLoC pattern and
supporting multiple environments.

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

### 3. Generate localization files

The project supports multiple languages (English and Spanish). Generate the localization files:

```bash
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

Translation files are located at:

- `lib/l10n/arb/app_en.arb` (English)
- `lib/l10n/arb/app_es.arb` (Spanish)

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
├── l10n/              # Localization files
│   ├── arb/          # .arb files for translations
│   └── gen/          # Generated localization files
├── app/              # App initialization and main widget
│   └── view/         # App view
├── features/         # Feature modules
│   ├── main/         # Main screen with shader list
│   ├── burn_effect/  # Burn effect shader
│   ├── gradient_flow/# Gradient flow shader
│   ├── plasma/       # Plasma effect shader
│   ├── pyramid/      # Pyramid fractal shader
│   ├── ripple_effect/# Ripple effect shader
│   ├── ripple_touch/ # Touch ripple shader
│   ├── warp_counter/ # Warp effect shader
│   ├── water_ripple/ # Water ripple shader
│   ├── wave/         # Seascape shader
│   └── wavy_stripes/ # Wavy stripes shader
shaders/              # GLSL shader files
├── burn_effect.frag
├── gradient_flow.frag
├── plasma_effect.frag
├── pyramid_fractal.frag
├── ripple_effect.frag
├── ripple_touch.frag
├── seascape.frag
├── warp_effect.frag
├── water_ripple.frag
└── wavy_stripes.frag
```

## Localization (l10n)

### Add new translations

1. Edit the `.arb` files in `lib/l10n/arb/`:
    - `app_en.arb` for English
    - `app_es.arb` for Spanish

2. Add new key/value pairs:
   ```json
   {
     "@@locale": "en",
     "newKey": "New translation",
     "@newKey": {
       "description": "Description of the new key"
     }
   }
   ```

3. Regenerate localization files:
   ```bash
   flutter gen-l10n --arb-dir="lib/l10n/arb"
   ```

4. Use the new string in your code:
   ```dart
   import 'package:shader_app/l10n/l10n.dart';

   @override
   Widget build(BuildContext context) {
     final l10n = context.l10n;
     return Text(l10n.newKey);
   }
   ```

### Add new language

1. Create a new `.arb` file in `lib/l10n/arb/`:
   ```
   app_fr.arb  # For French
   ```

2. Update iOS localization in `ios/Runner/Info.plist`:
   ```xml
   <key>CFBundleLocalizations</key>
   <array>
     <string>en</string>
     <string>es</string>
     <string>fr</string>
   </array>
   ```

3. Regenerate localization files

## Testing

### Run all tests

```bash
flutter test
```

### Run tests with coverage

```bash
very_good test --coverage --test-randomize-ordering-seed random
```

### View coverage report

```bash
# Generate coverage report
genhtml coverage/lcov.info -o coverage/

# Open coverage report in browser
open coverage/index.html
```

### Run specific test file

```bash
flutter test test/path/to/test_file.dart
```

## Code Quality

### Run code analysis

The project uses `very_good_analysis` to maintain code quality:

```bash
flutter analyze
```

### Format code

```bash
flutter format .
```

## Shaders

This project showcases the following shader effects:

1. **Seascape**: Realistic ocean wave simulation
2. **Pyramid Fractal**: Geometric fractal pattern
3. **Water Ripple**: Simple water ripple effect
4. **Ripple Effect**: Circular ripple animation
5. **Ripple Touch**: Interactive touch ripples
6. **Gradient Flow**: Flowing gradient colors
7. **Wavy Stripes**: Animated wavy stripe pattern
8. **Burn Effect**: Fire/burn animation effect
9. **Warp Effect**: Space warp distortion
10. **Plasma Effect**: Plasma energy effect

All shader files are located in the `shaders/` directory and are written in GLSL (OpenGL Shading Language).

## Main Dependencies

- **flutter_bloc**: State management using BLoC pattern
- **bloc**: Core BLoC library
- **flutter_shaders**: Flutter shader support
- **flutter_localizations**: Internationalization support
- **intl**: Internationalization and localization utilities
- **vector_math**: Vector and matrix math operations

### Dev Dependencies

- **bloc_test**: Testing utilities for BLoC
- **mocktail**: Mocking library for tests
- **very_good_analysis**: Strict lint rules

## Troubleshooting

### Error: "Flutter SDK not found"

Verify that Flutter is installed correctly and in your PATH:

```bash
flutter doctor
```

### Shader compilation errors

Make sure your device/platform supports shaders. Run:

```bash
flutter doctor -v
```

### l10n generation error

Regenerate localization files:

```bash
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

### Flavor not found error

Make sure you're specifying both the flavor and target:

```bash
flutter run --flavor development --target lib/main_development.dart
```

### iOS build fails

Clean and rebuild:

```bash
flutter clean
cd ios
pod install
cd ..
flutter build ios --flavor development --target lib/main_development.dart
```

### Tests failing

Run tests with verbose output:

```bash
flutter test --reporter=expanded
```

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
