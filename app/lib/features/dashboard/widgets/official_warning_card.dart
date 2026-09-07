import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/localization/language_service.dart';
import '../../../core/models/official_alert.dart';

class OfficialWarningCard extends StatelessWidget {
  final OfficialAlert alert;
  final VoidCallback onViewAlert;

  const OfficialWarningCard({
    super.key,
    required this.alert,
    required this.onViewAlert,
  });

  String _getDescription(String desc) {
    if (!LanguageService.instance.isUrdu) return desc;
    return 'شدید بارش سے پہاڑی ندی نالوں میں طغیانی اور لینڈ سلائیڈنگ کا خطرہ بڑھ سکتا ہے۔ بالائی علاقوں میں مون سون ہوائیں داخل ہونے کا امکان ہے۔';
  }

  String _getOrg(String org) {
    if (!LanguageService.instance.isUrdu) return org;
    if (org.contains('Meteorological')) return 'محکمہ موسمیات پاکستان';
    if (org.contains('NDMA') || org.contains('Disaster')) return 'نیشنل ڈیزاسٹر مینجمنٹ اتھارٹی';
    return org;
  }

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
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.riskHigh,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                Tr.t('official_warning'),
                style: const TextStyle(
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
            _getDescription(alert.description),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${Tr.t('source_prefix')}${_getOrg(alert.sourceOrg)}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 14),
          InkWell(
            onTap: onViewAlert,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  Tr.t('view_alert'),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.riskHigh,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
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
