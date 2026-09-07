import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/models/weather_data.dart';

class CurrentConditionsCard extends StatelessWidget {
  final CurrentConditions conditions;

  const CurrentConditionsCard({
    super.key,
    required this.conditions,
  });

  @override
  Widget build(BuildContext context) {
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
          Text(
            Tr.t('current_conditions'),
            style: AppTextStyles.sectionLabel,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildConditionIcon(conditions.condition),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${conditions.temperature}°C',
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Tr.weatherCondition(conditions.condition),
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricItem(
                icon: Icons.water_drop_outlined,
                value: '${conditions.humidity}%',
              ),
              _buildMetricItem(
                icon: Icons.air,
                value: '${conditions.windSpeedKmh}km/h',
              ),
              _buildMetricItem(
                icon: Icons.cloud_outlined,
                value: '${conditions.rainProbPercent}%',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConditionIcon(String condition) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
        ),
        Icon(
          condition.toLowerCase().contains('rain')
              ? Icons.grain
              : Icons.wb_sunny_outlined,
          color: AppColors.primary,
          size: 32,
        ),
      ],
    );
  }

  Widget _buildMetricItem({required IconData icon, required String value}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
