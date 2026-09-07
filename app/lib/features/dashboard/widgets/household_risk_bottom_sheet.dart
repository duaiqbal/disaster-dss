import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/localization/language_service.dart';
import '../../../core/models/household_risk.dart';

class HouseholdRiskBottomSheet extends StatelessWidget {
  final HouseholdRisk risk;

  const HouseholdRiskBottomSheet({super.key, required this.risk});

  String _localizeProximity(String val) {
    if (!LanguageService.instance.isUrdu) return val;
    if (val.toLowerCase().contains('near')) return 'قریب';
    if (val.toLowerCase().contains('close')) return 'انتہائی قریب';
    if (val.toLowerCase().contains('far') || val.toLowerCase().contains('distanc')) return 'دور';
    return val;
  }

  String _localizeExplanation(String exp) {
    if (!LanguageService.instance.isUrdu) return exp;
    return 'چترال میں آپ کے مقام، ڈی ای ایم ڈیٹا کے تحت کھڑی ڈھلوان اور دریا کی قربت کے تجزیے سے معتدل خطرے کا تعین کیا گیا ہے۔';
  }

  static void show(BuildContext context, HouseholdRisk risk) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HouseholdRiskBottomSheet(risk: risk),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Tr.t('household_risk_factors'),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        Tr.t('household_risk_factors_sub'),
                        style: AppTextStyles.caption.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textPrimary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: AppColors.primary, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          Tr.riskLevel(risk.level),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${risk.score} / 100',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildFactorRow(
                icon: Icons.home_outlined,
                title: Tr.t('factor_house_const'),
                subtitle: Tr.t('factor_house_const_sub'),
                badgeText: Tr.t('badge_moderate'),
                badgeColor: AppColors.primary,
                badgeBg: AppColors.primaryLight,
              ),
              _buildFactorRow(
                icon: Icons.waves,
                title: Tr.t('factor_river'),
                subtitle: _localizeProximity(risk.riverProximity),
                badgeText: Tr.t('badge_high'),
                badgeColor: AppColors.riskHigh,
                badgeBg: AppColors.riskHighBg,
              ),
              _buildFactorRow(
                icon: Icons.landscape_outlined,
                title: Tr.t('factor_slope'),
                subtitle: _localizeProximity(risk.slopeProximity),
                badgeText: Tr.t('badge_high'),
                badgeColor: AppColors.riskHigh,
                badgeBg: AppColors.riskHighBg,
              ),
              _buildFactorRow(
                icon: Icons.people_outline,
                title: Tr.t('factor_vulnerable'),
                subtitle: Tr.t('factor_vulnerable_sub'),
                badgeText: Tr.t('badge_moderate'),
                badgeColor: AppColors.primary,
                badgeBg: AppColors.primaryLight,
              ),
              _buildFactorRow(
                icon: Icons.pets_outlined,
                title: Tr.t('factor_livestock'),
                subtitle: Tr.t('factor_livestock_sub'),
                badgeText: Tr.t('badge_low'),
                badgeColor: AppColors.riskLow,
                badgeBg: AppColors.riskLowBg,
              ),
              _buildFactorRow(
                icon: Icons.directions_car_outlined,
                title: Tr.t('factor_transport'),
                subtitle: Tr.t('factor_transport_sub'),
                badgeText: Tr.t('badge_moderate'),
                badgeColor: AppColors.primary,
                badgeBg: AppColors.primaryLight,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Tr.t('calc_risk_title'),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _localizeExplanation(risk.explanation),
                      style: AppTextStyles.body.copyWith(fontSize: 13, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFactorRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
    required Color badgeBg,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 22, color: AppColors.textSecondary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: badgeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
