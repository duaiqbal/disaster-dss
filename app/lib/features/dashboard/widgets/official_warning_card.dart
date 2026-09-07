import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/models/official_alert.dart';

class OfficialWarningCard extends StatelessWidget {
  final OfficialAlert alert;
  final VoidCallback onViewAlert;

  const OfficialWarningCard({
    super.key,
    required this.alert,
    required this.onViewAlert,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.riskHighCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.riskHighCardBorder),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.riskHigh,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'OFFICIAL WARNING',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.riskHigh,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            alert.description,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Source: ${alert.sourceOrg}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),
          InkWell(
            onTap: onViewAlert,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View alert',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.riskHigh,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.open_in_new,
                  size: 14,
                  color: AppColors.riskHigh,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
