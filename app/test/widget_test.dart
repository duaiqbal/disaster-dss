import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:disaster_dss/core/theme/app_theme.dart';
import 'package:disaster_dss/core/models/official_alert.dart';
import 'package:disaster_dss/core/localization/language_service.dart';
import 'package:disaster_dss/features/dashboard/screens/main_risk_dashboard_screen.dart';
import 'package:disaster_dss/features/navigation/main_navigation_shell.dart';
import 'package:disaster_dss/features/chat/chat_screen.dart';
import 'package:disaster_dss/features/alerts/alert_details_screen.dart';
import 'package:disaster_dss/features/safety/safety_hub_screen.dart';
import 'package:disaster_dss/features/profile/emergency_contacts_screen.dart';
import 'package:disaster_dss/features/simulator/decision_simulator_screen.dart';

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

  testWidgets('ChatScreen renders assistant header, greeting, chips, and input', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const ChatScreen(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Climate Assistant'), findsOneWidget);
    expect(find.text('Chitral, KP'), findsOneWidget);
    expect(find.text('Context: Heavy Rainfall Alert'), findsOneWidget);
    expect(find.text('Why is my risk moderate?'), findsOneWidget);
    expect(find.text('What should I pack?'), findsOneWidget);
  });

  testWidgets('AlertDetailsScreen renders official warning details and action buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const AlertDetailsScreen(alert: OfficialAlert.warningFromPMD),
      ),
    );

    await tester.pump();

    expect(find.text('Alert Details'), findsOneWidget);
    expect(find.text('Heavy Rainfall Advisory'), findsOneWidget);
    expect(find.text('What is happening'), findsOneWidget);
    expect(find.text('What to do now'), findsOneWidget);
    expect(find.text('View on Map'), findsOneWidget);
    expect(find.text('Safety Guide'), findsOneWidget);
    expect(find.text('Emergency Contacts'), findsOneWidget);
  });

  testWidgets('SafetyHubScreen renders emergency checklist and hazard guides', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const SafetyHubScreen(),
      ),
    );

    await tester.pump();

    expect(find.text('Safety Hub'), findsOneWidget);
    expect(find.text('Emergency Safe Bag Checklist'), findsOneWidget);
    expect(find.text('Flash Flood & River Rise'), findsOneWidget);
    expect(find.text('Slope Stability & Debris Flow'), findsOneWidget);
    expect(find.text('Extreme Heat Waves'), findsOneWidget);
  });

  testWidgets('EmergencyContactsScreen renders all local helpline numbers', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const EmergencyContactsScreen(),
      ),
    );

    await tester.pump();

    expect(find.text('Emergency Contacts'), findsOneWidget);
    expect(find.text('Rescue Service'), findsOneWidget);
    expect(find.text('112'), findsOneWidget);
    expect(find.text('100'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pump();

    expect(find.text('1078'), findsOneWidget);
  });

  testWidgets('DecisionSimulatorScreen renders scenarios and comparisons', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const DecisionSimulatorScreen(),
      ),
    );

    await tester.pump();

    expect(find.text('Decision Simulator'), findsOneWidget);
    expect(find.text('Evacuate now'), findsOneWidget);
    expect(find.text('Wait and monitor'), findsOneWidget);
    expect(find.text('Risk Trajectory'), findsOneWidget);
    expect(find.text('Factor Breakdown'), findsOneWidget);
  });

  testWidgets('Language switching dynamically translates navigation and dashboard to Urdu and Roman Urdu', (WidgetTester tester) async {
    // Reset to English first
    LanguageService.instance.setLanguage(AppLanguage.english);

    await tester.pumpWidget(
      ValueListenableBuilder<AppLanguage>(
        valueListenable: LanguageService.instance.currentLanguage,
        builder: (context, language, _) {
          return MaterialApp(
            theme: AppTheme.lightTheme,
            builder: (context, child) => Directionality(
              textDirection: LanguageService.instance.isRtl
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: KeyedSubtree(
                key: ValueKey(language),
                child: child!,
              ),
            ),
            home: const MainNavigationShell(),
          );
        },
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify initial English tabs & dashboard
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Forecast'), findsOneWidget);
    expect(find.text('Map'), findsOneWidget);
    expect(find.text('Alerts'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Good evening, Hafsa'), findsOneWidget);
    expect(find.text('CURRENT CONDITIONS'), findsOneWidget);
    expect(find.text('HOUSEHOLD RISK'), findsOneWidget);
    expect(find.text('OFFICIAL WARNING'), findsOneWidget);

    // Switch to Urdu
    LanguageService.instance.setLanguage(AppLanguage.urdu);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(LanguageService.instance.isRtl, isTrue);
    expect(find.text('ہوم'), findsOneWidget);
    expect(find.text('پیشن گوئی'), findsOneWidget);
    expect(find.text('نقشہ'), findsOneWidget);
    expect(find.text('اطلاعات'), findsOneWidget);
    expect(find.text('پروفائل'), findsOneWidget);
    expect(find.text('شب بخیر، حفصہ'), findsOneWidget);
    expect(find.text('موجودہ موسمی صورتحال'), findsOneWidget);
    expect(find.text('گھر کا خطرہ'), findsOneWidget);
    expect(find.text('سرکاری تنبیہ'), findsOneWidget);

    // Switch to Roman Urdu
    LanguageService.instance.setLanguage(AppLanguage.romanUrdu);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(LanguageService.instance.isRtl, isFalse);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Peshangoi'), findsOneWidget);
    expect(find.text('Naqsha'), findsOneWidget);
    expect(find.text('Ittilayein'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Shab-ba-khair, Hafsa'), findsOneWidget);
    expect(find.text('MOJOODA MOUSAM'), findsOneWidget);
    expect(find.text('GHAR KA KHATRA'), findsOneWidget);
    expect(find.text('SARKARI ITTILA'), findsOneWidget);

    // Reset back to English
    LanguageService.instance.setLanguage(AppLanguage.english);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Good evening, Hafsa'), findsOneWidget);
  });
}

