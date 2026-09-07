import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/models/household_risk.dart';

class HouseholdRiskCard extends StatelessWidget {
  final HouseholdRisk risk;
  final VoidCallback onViewFactors;

  const HouseholdRiskCard({
    super.key,
    required this.risk,
    required this.onViewFactors,
  });

  @override
  Widget build(BuildContext context) {
    final isHigh = risk.score >= 75;
    final isModerate = risk.score >= 50 && risk.score < 75;

    final badgeColor = isHigh
        ? AppColors.riskHigh
        : (isModerate ? AppColors.riskModerate : AppColors.riskLow);
    final badgeBg = isHigh
        ? AppColors.riskHighBg
        : (isModerate ? AppColors.riskModerateBg : AppColors.riskLowBg);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Tr.t('household_risk'),
                style: AppTextStyles.sectionLabel.copyWith(
                  color: AppColors.riskModerate,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  Tr.riskLevel(risk.level),
                  style: AppTextStyles.badge.copyWith(
                    color: badgeColor,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${risk.score}',
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '/ 100',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: risk.score / 100.0,
              minHeight: 8,
              backgroundColor: AppColors.progressTrack,
              valueColor: AlwaysStoppedAnimation<Color>(
                isHigh
                    ? AppColors.riskHigh
                    : (isModerate ? AppColors.riskModerateBar : AppColors.riskLow),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            Tr.t('key_factors'),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          for (final factor in risk.keyFactors)
            Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 16),
              child: Text(
                factor,
                style: AppTextStyles.body.copyWith(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onViewFactors,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 1.2),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(Tr.t('view_risk_factors')),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
