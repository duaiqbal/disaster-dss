import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:disaster_dss/core/theme/app_theme.dart';
import 'package:disaster_dss/core/models/official_alert.dart';
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
}

