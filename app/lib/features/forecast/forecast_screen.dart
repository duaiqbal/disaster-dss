import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text('Chitral, Pakistan', style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
              ],
            ),
            const Text('Forecast', style: AppTextStyles.caption),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current summary card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wb_sunny_outlined, size: 36, color: AppColors.riskModerateBar),
                      SizedBox(width: 12),
                      Text(
                        '24°C',
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text('Partly cloudy', style: TextStyle(color: AppColors.textSecondary)),
                  const Text('Feels like 25°C', style: AppTextStyles.caption),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.water_drop_outlined, size: 18, color: AppColors.textMuted),
                          SizedBox(height: 4),
                          Text('65%', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Humidity', style: AppTextStyles.caption),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.air, size: 18, color: AppColors.textMuted),
                          SizedBox(height: 4),
                          Text('12km/h', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Wind', style: AppTextStyles.caption),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.cloud_outlined, size: 18, color: AppColors.textMuted),
                          SizedBox(height: 4),
                          Text('15%', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Rain', style: AppTextStyles.caption),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.wb_sunny_outlined, size: 18, color: AppColors.textMuted),
                          SizedBox(height: 4),
                          Text('Low', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('UV', style: AppTextStyles.caption),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Risk-relevant weather banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.aiCardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.aiCardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: AppColors.primaryDark, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Risk-relevant weather',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Rainfall is expected to increase over the next 24 hours. Increased rainfall can raise slope saturation and flash-flood risk in vulnerable areas.',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildRiskStep(icon: Icons.grain, label: 'Rainfall', isRisk: false),
                      const Icon(Icons.arrow_forward, size: 16, color: AppColors.textMuted),
                      _buildRiskStep(icon: Icons.water_drop, label: 'Slope\nsaturation', isRisk: false),
                      const Icon(Icons.arrow_forward, size: 16, color: AppColors.textMuted),
                      _buildRiskStep(icon: Icons.landscape, label: 'Landslide\npotential', isRisk: true),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskStep({required IconData icon, required String label, required bool isRisk}) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isRisk ? AppColors.riskHighBg : AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(
              color: isRisk ? AppColors.riskHigh : AppColors.border,
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isRisk ? AppColors.riskHigh : AppColors.primary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
