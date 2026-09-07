import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/models/weather_data.dart';

class SevenDayForecastPreview extends StatelessWidget {
  final List<DailyForecast> forecasts;
  final VoidCallback onViewFull;

  const SevenDayForecastPreview({
    super.key,
    required this.forecasts,
    required this.onViewFull,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Tr.t('seven_day_forecast'),
                style: AppTextStyles.sectionLabel,
              ),
              InkWell(
                onTap: onViewFull,
                child: Text(
                  Tr.t('view_full'),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: forecasts.take(4).map((f) => _buildDayCard(f)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(DailyForecast forecast) {
    return Container(
      width: 72,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            Tr.dayName(forecast.dayName),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          _getForecastIcon(forecast.condition),
          const SizedBox(height: 8),
          Text(
            '${forecast.temp}°',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${forecast.rainProbPercent}%',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getForecastIcon(String condition) {
    final lower = condition.toLowerCase();
    if (lower.contains('heavy') || lower.contains('90%')) {
      return const Icon(Icons.thunderstorm_outlined, size: 22, color: AppColors.primary);
    } else if (lower.contains('rain')) {
      return const Icon(Icons.grain, size: 22, color: AppColors.primary);
    } else if (lower.contains('cloud')) {
      return const Icon(Icons.cloud_outlined, size: 22, color: AppColors.primary);
    } else {
      return const Icon(Icons.wb_sunny_outlined, size: 22, color: AppColors.riskModerateBar);
    }
  }
}
