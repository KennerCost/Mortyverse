import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final VoidCallback onThemeToggle;

  const AppHeader({required this.onThemeToggle, super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width.clamp(320.0, 430.0);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: width * 0.12,
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  isDark ? Colors.white : Colors.transparent,
                  isDark ? BlendMode.srcIn : BlendMode.dst,
                ),
                child: Image.asset(
                  'assets/images/logo_topo.png',
                  height: width * 0.105,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: isDark ? 'Tema claro' : 'Tema escuro',
            onPressed: onThemeToggle,
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: Theme.of(context).colorScheme.onSurface,
              size: width * 0.07,
            ),
          ),
        ],
      ),
    );
  }
}
