import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/official_alert.dart';
import '../../core/localization/app_translations.dart';
import '../dashboard/screens/main_risk_dashboard_screen.dart';
import '../forecast/forecast_screen.dart';
import '../map/map_screen.dart';
import '../alerts/official_alerts_screen.dart';
import '../alerts/alert_details_screen.dart';
import '../community/community_risk_screen.dart';
import '../profile/profile_screen.dart';
import '../chat/chat_screen.dart';
import '../auth/login_screen.dart';

class MainNavigationShell extends StatefulWidget {
  final int initialTab;

  const MainNavigationShell({
    super.key,
    this.initialTab = 0,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  void _navigateToTab(int index) {
    setState(() => _currentIndex = index);
  }

  void _openAiAssistant() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ChatScreen()),
    );
  }

  void _handleLogout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      MainRiskDashboardScreen(
        onNavigateToTab: _navigateToTab,
        onOpenAiAssistant: _openAiAssistant,
        onOpenAlertDetails: (OfficialAlert alert) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AlertDetailsScreen(alert: alert),
            ),
          );
        },
        onOpenCommunityReports: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CommunityRiskScreen(),
            ),
          );
        },
      ),
      const ForecastScreen(),
      const MapScreen(),
      OfficialAlertsScreen(
        onSelectAlert: (OfficialAlert alert) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AlertDetailsScreen(alert: alert),
            ),
          );
        },
      ),
      ProfileScreen(onLogout: _handleLogout),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_main',
        onPressed: _openAiAssistant,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.smart_toy_outlined, size: 26),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.border, width: 1),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_outlined, Icons.home, Tr.t('tab_home')),
                _buildNavItem(1, Icons.wb_sunny_outlined, Icons.wb_sunny, Tr.t('tab_forecast')),
                _buildNavItem(2, Icons.map_outlined, Icons.map, Tr.t('tab_map')),
                _buildNavItem(3, Icons.notifications_none_outlined, Icons.notifications, Tr.t('tab_alerts')),
                _buildNavItem(4, Icons.person_outline, Icons.person, Tr.t('tab_profile')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData unselectedIcon, IconData selectedIcon, String label) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () => _navigateToTab(index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 12 : 8,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : unselectedIcon,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
