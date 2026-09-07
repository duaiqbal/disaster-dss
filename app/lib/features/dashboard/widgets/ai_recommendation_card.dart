import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class AiRecommendationCard extends StatelessWidget {
  final String recommendation;
  final VoidCallback onAskAi;

  const AiRecommendationCard({
    super.key,
    required this.recommendation,
    required this.onAskAi,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.aiCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.aiCardBorder),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColors.aiAccent,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'AI Recommendation',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.aiAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            recommendation,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textPrimary,
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onAskAi,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ask AI Assistant'),
                  SizedBox(width: 8),
                  Icon(Icons.smart_toy_outlined, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
