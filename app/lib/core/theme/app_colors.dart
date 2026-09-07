import 'package:flutter/material.dart';

/// Centralized color palette derived from Figma screen designs in `assets/designs/`.
class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primary = Color(0xFF007A87);
  static const Color primaryDark = Color(0xFF00616C);
  static const Color primaryLight = Color(0xFFE0F2F1);
  static const Color primaryContainer = Color(0xFFE6F4F6);

  // Background & Surfaces
  static const Color background = Color(0xFFF6F8FA);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF3F4F6);
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderSubtle = Color(0xFFF0F2F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF9CA3AF);

  // Severity / Risk Indicator Colors
  // High Risk (Red)
  static const Color riskHigh = Color(0xFFDC2626);
  static const Color riskHighBg = Color(0xFFFEE2E2);
  static const Color riskHighCardBg = Color(0xFFFFF5F5);
  static const Color riskHighCardBorder = Color(0xFFFED7D7);

  // Moderate Risk (Amber / Orange)
  static const Color riskModerate = Color(0xFFD97706);
  static const Color riskModerateBar = Color(0xFFF59E0B);
  static const Color riskModerateBg = Color(0xFFFEF3C7);

  // Low Risk / Safe (Teal / Green)
  static const Color riskLow = Color(0xFF059669);
  static const Color riskLowBg = Color(0xFFD1FAE5);

  // AI Recommendation Card
  static const Color aiCardBg = Color(0xFFF0FDFA);
  static const Color aiCardBorder = Color(0xFFCCFBF1);
  static const Color aiAccent = Color(0xFF0F766E);

  // Status & Accents
  static const Color onlineGreen = Color(0xFF10B981);
  static const Color weatherPillBg = Color(0xFFF9FAFB);
  static const Color progressTrack = Color(0xFFE5E7EB);
}
