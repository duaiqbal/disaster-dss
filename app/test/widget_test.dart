import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:disaster_dss/core/theme/app_theme.dart';
import 'package:disaster_dss/features/dashboard/screens/main_risk_dashboard_screen.dart';
import 'package:disaster_dss/features/navigation/main_navigation_shell.dart';

void main() {
  testWidgets('MainRiskDashboardScreen renders all key Figma sections', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const MainRiskDashboardScreen(),
      ),
    );

    // Initial frame
    await tester.pump();
    // Allow async repository futures to resolve
    await tester.pump(const Duration(milliseconds: 100));

    // Verify header and user greeting
    expect(find.text('Good evening, Hafsa'), findsOneWidget);
    expect(find.text('Chitral, Khyber Pakhtunkhwa'), findsOneWidget);

    // Verify sections matching Main Risk Dashboard.png
    expect(find.text('CURRENT CONDITIONS'), findsOneWidget);
    expect(find.text('HOUSEHOLD RISK'), findsOneWidget);
    expect(find.text('OFFICIAL WARNING'), findsOneWidget);
    expect(find.text('COMMUNITY RISK'), findsOneWidget);
    expect(find.text('AI Recommendation'), findsOneWidget);
    expect(find.text('7-DAY FORECAST'), findsOneWidget);

    // Verify buttons and interactive CTAs
    expect(find.text('View risk factors'), findsOneWidget);
    expect(find.text('View Community Reports'), findsOneWidget);
    expect(find.text('Ask AI Assistant'), findsOneWidget);
  });

  testWidgets('MainNavigationShell renders 5 bottom tabs and floating action button', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const MainNavigationShell(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify bottom navigation items
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Forecast'), findsOneWidget);
    expect(find.text('Map'), findsOneWidget);
    expect(find.text('Alerts'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Verify Floating Action Button for AI assistant
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}

