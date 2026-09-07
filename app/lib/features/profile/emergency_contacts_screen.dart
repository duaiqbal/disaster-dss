import 'package:flutter/material.dart';
import '../../core/localization/app_translations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class _EmergencyContact {
  final String name;
  final String description;
  final String number;
  const _EmergencyContact({required this.name, required this.description, required this.number});
}

class EmergencyContactsScreen extends StatelessWidget {
  const EmergencyContactsScreen({super.key});

  List<_EmergencyContact> get _contacts => [
    _EmergencyContact(
      name: Tr.t('emergency_rescue_title'),
      description: Tr.t('emergency_rescue_sub'),
      number: '112',
    ),
    _EmergencyContact(
      name: Tr.t('emergency_police_title'),
      description: Tr.t('emergency_police_sub'),
      number: '100',
    ),
    _EmergencyContact(
      name: Tr.t('emergency_fire_title'),
      description: Tr.t('emergency_fire_sub'),
      number: '101',
    ),
    _EmergencyContact(
      name: Tr.t('emergency_disaster_title'),
      description: Tr.t('emergency_disaster_sub'),
      number: '1078',
    ),
    _EmergencyContact(
      name: Tr.t('emergency_district_title'),
      description: Tr.t('emergency_district_sub'),
      number: '1077',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          Tr.t('emergency_contacts_title'),
          style: AppTextStyles.cardTitle.copyWith(color: AppColors.primary),
        ),
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              Tr.t('emergency_contacts_sub'),
              style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _contacts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final c = _contacts[i];
                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.name, style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                      const SizedBox(height: 4),
                      Text(c.description,
                          style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary, fontSize: 13)),
                      const SizedBox(height: 10),
                      const Divider(height: 1),
                      const SizedBox(height: 10),
                      Text(
                        c.number,
                        style: AppTextStyles.screenHeader.copyWith(
                          color: AppColors.primary,
                          fontSize: 28,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.aiCardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.aiCardBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    Tr.t('emergency_note'),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
