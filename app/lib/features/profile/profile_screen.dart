import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/localization/language_service.dart';
import '../../core/localization/app_translations.dart';
import 'risk_profile_screen.dart';
import 'emergency_contacts_screen.dart';
import '../safety/safety_hub_screen.dart';
import '../feedback/feedback_screen.dart';
import '../auth/language_selection_screen.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onLogout;

  const ProfileScreen({super.key, this.onLogout});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _userName;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _userName = prefs.getString('user_name');
        _userEmail = prefs.getString('user_email');
      });
    }
  }

  String get _displayName {
    if (_userName != null && _userName!.isNotEmpty) return _userName!;
    return LanguageService.instance.isUrdu ? 'حفصہ احمد' : 'Hafsa Ahmad';
  }

  String get _displayEmail {
    if (_userEmail != null && _userEmail!.isNotEmpty) return _userEmail!;
    return LanguageService.instance.isUrdu ? 'حفصہ@ایگزامپل.کام' : 'hafsa@example.com';
  }

  String get _displayInitials {
    final name = _displayName.trim();
    final parts = name.split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (name.isNotEmpty) {
      return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
    }
    return 'HA';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(Tr.t('tab_profile'), style: AppTextStyles.screenHeader),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // User Avatar & Name
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  _displayInitials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _displayName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              _displayEmail,
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(Tr.t('location_chitral_pk'), style: AppTextStyles.caption),
              ],
            ),
            const SizedBox(height: 24),
            // Household Risk preview card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Tr.t('household_risk'),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.home_outlined, color: Colors.grey[700]),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.riskModerateBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${Tr.riskLevel('Moderate Risk')} (68/100)',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.riskModerate,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Tr.t('household_risk_desc'),
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RiskProfileScreen()),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(Tr.t('view_risk_profile')),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Settings menu card
            Material(
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    context: context,
                    icon: Icons.person_search_outlined,
                    title: Tr.t('menu_risk_profile'),
                    subtitle: Tr.t('menu_risk_profile_sub'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RiskProfileScreen()),
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.contact_phone_outlined,
                    title: Tr.t('menu_emergency_contacts'),
                    subtitle: Tr.t('menu_emergency_contacts_sub'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const EmergencyContactsScreen()),
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.health_and_safety_outlined,
                    title: Tr.t('menu_safety_hub'),
                    subtitle: Tr.t('menu_safety_hub_sub'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const SafetyHubScreen()),
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.rate_review_outlined,
                    title: Tr.t('menu_feedback'),
                    subtitle: Tr.t('menu_feedback_sub'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const FeedbackScreen()),
                    ),
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.language,
                    title: Tr.t('menu_language'),
                    subtitle: LanguageService.instance.displayName,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LanguageSelectionScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _showLogoutDialog(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.riskHigh,
                  side: const BorderSide(color: AppColors.riskHigh),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(Tr.t('log_out')),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.surface,
        title: Text(
          Tr.t('logout_dialog_title'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Text(
          Tr.t('logout_dialog_desc'),
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(Tr.t('cancel')),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (widget.onLogout != null) {
                      widget.onLogout!();
                    }
                  },
                  child: Text(Tr.t('log_out')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryDark),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      subtitle: Text(subtitle, style: AppTextStyles.caption.copyWith(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.textMuted),
      onTap: onTap,
    );
  }
}
