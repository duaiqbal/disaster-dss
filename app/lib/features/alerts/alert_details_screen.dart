import 'package:flutter/material.dart';
import '../../core/models/official_alert.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/localization/app_translations.dart';
import '../../core/localization/language_service.dart';
import '../chat/chat_screen.dart';
import '../safety/safety_hub_screen.dart';
import '../profile/emergency_contacts_screen.dart';

class AlertDetailsScreen extends StatefulWidget {
  final OfficialAlert alert;
  const AlertDetailsScreen({super.key, required this.alert});

  @override
  State<AlertDetailsScreen> createState() => _AlertDetailsScreenState();
}

class _AlertDetailsScreenState extends State<AlertDetailsScreen> {
  bool _xaiExpanded = false;

  String _getDescription(String desc) {
    if (!LanguageService.instance.isUrdu) return desc;
    return 'شدید بارش سے خاص طور پر دریاؤں اور کھڑی ڈھلوانوں کے قریب اچانک سیلاب اور لینڈ سلائیڈنگ کا خطرہ بڑھ سکتا ہے۔';
  }

  List<String> _getActions(List<String> actions) {
    if (!LanguageService.instance.isUrdu) return actions;
    return [
      'سرکاری اپ ڈیٹس کی باقاعدگی سے نگرانی کریں۔',
      'ضروری دستاویزات اور ادویات تیار رکھیں۔',
      'دریا کے راستوں اور غیر مستحکم ڈھلوانوں سے دور رہیں۔',
      'انخلاء کا راستہ کھلا اور تیار رکھیں۔',
      'اگر مشورہ دیا جائے تو مویشیوں کو محفوظ مقام پر منتقل کریں۔',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final alert = widget.alert;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          Tr.t('alert_details_title'),
          style: AppTextStyles.cardTitle.copyWith(color: AppColors.primary),
        ),
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_alert_details',
        backgroundColor: AppColors.primary,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChatScreen()),
        ),
        child: const Icon(Icons.smart_toy_outlined, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _AlertHeaderCard(alert: alert),
            const SizedBox(height: 12),
            _InfoCard(
              title: Tr.t('what_is_happening'),
              body: _getDescription(alert.description),
            ),
            const SizedBox(height: 12),
            _WhatToDoCard(actions: _getActions(alert.whatToDo)),
            const SizedBox(height: 12),
            _XaiAccordionCard(
              expanded: _xaiExpanded,
              onToggle: () => setState(() => _xaiExpanded = !_xaiExpanded),
            ),
            const SizedBox(height: 20),
            _ActionButtons(alert: alert),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

// ── Header card ────────────────────────────────────────────────────────────
class _AlertHeaderCard extends StatelessWidget {
  final OfficialAlert alert;
  const _AlertHeaderCard({required this.alert});

  String _getTitle(String t) {
    if (!LanguageService.instance.isUrdu) return t;
    return 'شدید بارش سے متعلق ایڈوائزری';
  }

  String _getSource(String s) {
    if (!LanguageService.instance.isUrdu) return s;
    if (s.contains('Meteorological')) return 'محکمہ موسمیات پاکستان';
    return s;
  }

  String _getArea(String a) {
    if (!LanguageService.instance.isUrdu) return a;
    if (a.contains('Chitral')) return 'ضلع چترال';
    return a;
  }

  @override
  Widget build(BuildContext context) {
    final isHigh = alert.severity == 'high';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isHigh ? AppColors.riskHighBg : AppColors.riskModerateBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 13,
                  color: isHigh ? AppColors.riskHigh : AppColors.riskModerate,
                ),
                const SizedBox(width: 5),
                Text(
                  Tr.t('official_warning_badge'),
                  style: AppTextStyles.caption.copyWith(
                    color: isHigh ? AppColors.riskHigh : AppColors.riskModerate,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(_getTitle(alert.title), style: AppTextStyles.screenHeader.copyWith(fontSize: 22)),
          const SizedBox(height: 6),
          Text(
            _getSource(alert.source),
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          _MetaRow(icon: Icons.location_on_outlined, text: _getArea(alert.area)),
          const SizedBox(height: 6),
          _MetaRow(icon: Icons.access_time_outlined, text: Tr.t('issued_label')),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// ── Info card ──────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final String title;
  final String body;
  const _InfoCard({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.cardTitle),
          const SizedBox(height: 10),
          Text(
            body,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ── What to do card ────────────────────────────────────────────────────────
class _WhatToDoCard extends StatelessWidget {
  final List<String> actions;
  const _WhatToDoCard({required this.actions});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Tr.t('what_to_do_now'), style: AppTextStyles.cardTitle),
          const SizedBox(height: 14),
          ...actions.asMap().entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.primary, width: 1.5),
                        ),
                        child: Icon(Icons.check,
                            size: 13, color: AppColors.primary),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${e.key + 1}. ${e.value}',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          const Divider(height: 20),
          Row(
            children: [
              const Icon(Icons.verified_outlined,
                  size: 13, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text(
                Tr.t('safety_validated'),
                style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── XAI accordion card ─────────────────────────────────────────────────────
class _XaiAccordionCard extends StatelessWidget {
  final bool expanded;
  final VoidCallback onToggle;
  const _XaiAccordionCard({required this.expanded, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      Tr.t('why_seeing_actions'),
                      style: AppTextStyles.cardTitle,
                    ),
                  ),
                  Icon(
                    expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
          if (expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: Text(
                LanguageService.instance.isUrdu
                    ? 'یہ تجویز کردہ اقدامات ضلع چترال کے لیے سرکاری NDMA اور PMD کی ہنگامی ہدایات سے لیے گئے ہیں۔ یہ آپ کے محل وقوع، الرٹ لیول اور گھریلو خطرے کے کوائف سے مماثل ہیں۔ AI کا نظام نیا مشورہ پیدا نہیں کرتا بلکہ تصدیق شدہ سرکاری رہنمائی کو تلاش اور پیش کرتا ہے۔'
                    : 'These recommended actions are derived from official NDMA and PMD emergency guidelines for Chitral District. They are matched to your location, the current alert level, and your household risk profile. The AI system does not generate new advice — it retrieves and ranks verified official guidance.',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Action buttons ─────────────────────────────────────────────────────────
class _ActionButtons extends StatelessWidget {
  final OfficialAlert alert;
  const _ActionButtons({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.map_outlined, size: 18),
            label: Text(Tr.t('view_on_map')),
            onPressed: () {
              // Pop back to nav shell at map tab
              Navigator.popUntil(context, (r) => r.isFirst);
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const SafetyHubScreen()),
                ),
                child: Text(Tr.t('safety_guide')),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const EmergencyContactsScreen()),
                ),
                child: Text(
                  Tr.t('emergency_contacts'),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
