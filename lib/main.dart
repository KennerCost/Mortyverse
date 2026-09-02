import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home/home_screen.dart';
import 'theme/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(const MortyverseApp());
}

class MortyverseApp extends StatefulWidget {
  const MortyverseApp({super.key});

  @override
  State<MortyverseApp> createState() => _MortyverseAppState();
}

class _MortyverseAppState extends State<MortyverseApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mortyverse',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: _themeMode,
      home: AnimatedSplashScreen(onThemeToggle: _toggleTheme),
    );
  }
}

ThemeData _buildTheme(Brightness brightness) {
  final isDark = brightness == Brightness.dark;

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    fontFamily: 'Arial',
    scaffoldBackgroundColor: isDark
        ? AppColors.darkBackground
        : AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.portalGreen,
      brightness: brightness,
      surface: isDark ? AppColors.darkSurface : AppColors.surface,
      onSurface: isDark ? Colors.white : AppColors.text,
      outlineVariant: isDark ? AppColors.darkBorder : AppColors.border,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark ? AppColors.darkSurface : AppColors.surface,
    ),
    textTheme: ThemeData(brightness: brightness).textTheme.copyWith(
      displaySmall: const TextStyle(
        fontSize: 27,
        fontWeight: FontWeight.w700,
        height: 1.08,
      ),
      headlineSmall: const TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.w700,
        height: 1.12,
      ),
    ),
  );
}

class AnimatedSplashScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const AnimatedSplashScreen({required this.onThemeToggle, super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen> {
  bool _showApp = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _showApp = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showApp) return HomeScreen(onThemeToggle: widget.onThemeToggle);

    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(
          image: AssetImage('assets/gifs/rick-morty-portal.gif'),
          width: 88,
          height: 88,
        ),
      ),
    );
  }
}

class MyApp extends MortyverseApp {
  const MyApp({super.key});
}
