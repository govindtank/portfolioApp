import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';

class AmbientBackground extends StatelessWidget {
  final Widget child;

  const AmbientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final primary = themeProvider.accentColor;

    return Stack(
      children: [
        // Base Background
        Container(
          width: double.infinity,
          height: double.infinity,
          color: isDark ? const Color(0xFF070B14) : const Color(0xFFF0F4F8),
        ),
        
        // Animated Mesh Orbs
        Positioned(
          top: -150,
          right: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  primary.withOpacity(isDark ? 0.15 : 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).move(
            duration: const Duration(seconds: 8),
            begin: const Offset(0, 0),
            end: const Offset(-30, 50),
          ),
        ),
        
        Positioned(
          bottom: -150,
          left: -100,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  (isDark ? const Color(0xFF6366F1) : const Color(0xFF818CF8))
                      .withOpacity(isDark ? 0.12 : 0.06),
                  Colors.transparent,
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).move(
            duration: const Duration(seconds: 12),
            begin: const Offset(0, 0),
            end: const Offset(50, -30),
          ).scale(
            duration: const Duration(seconds: 10),
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.1, 1.1),
          ),
        ),

        // Foreground Content
        child,
      ],
    );
  }
}
