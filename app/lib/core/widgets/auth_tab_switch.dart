import 'package:flutter/material.dart';
import '../localization/app_translations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum AuthTab { login, createAccount }

class AuthTabSwitch extends StatelessWidget {
  final AuthTab activeTab;
  final VoidCallback onLoginTap;
  final VoidCallback onCreateAccountTap;

  const AuthTabSwitch({
    super.key,
    required this.activeTab,
    required this.onLoginTap,
    required this.onCreateAccountTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onLoginTap,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  color: activeTab == AuthTab.login
                      ? AppColors.surface
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: activeTab == AuthTab.login
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: Text(
                  Tr.t('login'),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: activeTab == AuthTab.login
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: onCreateAccountTap,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  color: activeTab == AuthTab.createAccount
                      ? AppColors.surface
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: activeTab == AuthTab.createAccount
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: Text(
                  Tr.t('create_account'),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: activeTab == AuthTab.createAccount
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
