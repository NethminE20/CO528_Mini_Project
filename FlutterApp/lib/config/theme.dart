import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFFA5B4FC);
  static const Color accent = Color(0xFF06B6D4);
  static const Color accentLight = Color(0xFF67E8F9);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerDark = Color(0xFFDC2626);

  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF1F5F9);
  static const Color text = Color(0xFF0F172A);
  static const Color textMuted = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);

  static const Color sidebarStart = Color(0xFF0F172A);
  static const Color sidebarEnd = Color(0xFF1E293B);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
  );

  static const LinearGradient sidebarGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
  );

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF818CF8), Color(0xFF06B6D4)],
  );

  static const LinearGradient dangerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
  );

  static const LinearGradient authBgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0F172A),
      Color(0xFF1E1B4B),
      Color(0xFF164E63),
      Color(0xFF0F172A),
    ],
  );
}

class AppShadows {
  static List<BoxShadow> sm = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> md = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> lg = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 40,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> xl = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 60,
      offset: const Offset(0, 20),
    ),
  ];
}
