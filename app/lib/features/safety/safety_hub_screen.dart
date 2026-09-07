import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/localization/app_translations.dart';
import '../chat/chat_screen.dart';
import '../profile/emergency_contacts_screen.dart';

// ============================================================
// Safety Hub Screen
// ============================================================
class SafetyHubScreen extends StatelessWidget {
  const SafetyHubScreen({super.key});

  List<_GuideEntry> get _guides => [
    _GuideEntry(
      emoji: '🌊',
      title: Tr.t('guide_flood_title'),
      subtitle: Tr.t('guide_flood_sub'),
      doItems: [
        Tr.t('flood_do_1'),
        Tr.t('flood_do_2'),
        Tr.t('flood_do_3'),
        Tr.t('flood_do_4'),
      ],
      doNotItems: [
        Tr.t('flood_dont_1'),
        Tr.t('flood_dont_2'),
        Tr.t('flood_dont_3'),
      ],
      watchForItems: [
        Tr.t('flood_watch_1'),
        Tr.t('flood_watch_2'),
        Tr.t('flood_watch_3'),
        Tr.t('flood_watch_4'),
      ],
    ),
    _GuideEntry(
      emoji: '⛰️',
      title: Tr.t('guide_slope_title'),
      subtitle: Tr.t('guide_slope_sub'),
      doItems: [
        Tr.t('slope_do_1'),
        Tr.t('slope_do_2'),
        Tr.t('slope_do_3'),
        Tr.t('slope_do_4'),
      ],
      doNotItems: [
        Tr.t('slope_dont_1'),
        Tr.t('slope_dont_2'),
        Tr.t('slope_dont_3'),
      ],
      watchForItems: [
        Tr.t('slope_watch_1'),
        Tr.t('slope_watch_2'),
        Tr.t('slope_watch_3'),
        Tr.t('slope_watch_4'),
      ],
    ),
    _GuideEntry(
      emoji: '☀️',
      title: Tr.t('guide_heat_title'),
      subtitle: Tr.t('guide_heat_sub'),
      doItems: [
        Tr.t('heat_do_1'),
        Tr.t('heat_do_2'),
        Tr.t('heat_do_3'),
        Tr.t('heat_do_4'),
      ],
      doNotItems: [
        Tr.t('heat_dont_1'),
        Tr.t('heat_dont_2'),
        Tr.t('heat_dont_3'),
      ],
      watchForItems: [
        Tr.t('heat_watch_1'),
        Tr.t('heat_watch_2'),
        Tr.t('heat_watch_3'),
        Tr.t('heat_watch_4'),
      ],
    ),
    _GuideEntry(
      emoji: '💨',
      title: Tr.t('guide_wind_title'),
      subtitle: Tr.t('guide_wind_sub'),
      doItems: [
        Tr.t('wind_do_1'),
        Tr.t('wind_do_2'),
        Tr.t('wind_do_3'),
        Tr.t('wind_do_4'),
      ],
      doNotItems: [
        Tr.t('wind_dont_1'),
        Tr.t('wind_dont_2'),
        Tr.t('wind_dont_3'),
      ],
      watchForItems: [
        Tr.t('wind_watch_1'),
        Tr.t('wind_watch_2'),
        Tr.t('wind_watch_3'),
        Tr.t('wind_watch_4'),
      ],
    ),
    _GuideEntry(
      emoji: '🌫️',
      title: Tr.t('guide_dust_title'),
      subtitle: Tr.t('guide_dust_sub'),
      doItems: [
        Tr.t('dust_do_1'),
        Tr.t('dust_do_2'),
        Tr.t('dust_do_3'),
        Tr.t('dust_do_4'),
      ],
      doNotItems: [
        Tr.t('dust_dont_1'),
        Tr.t('dust_dont_2'),
        Tr.t('dust_dont_3'),
      ],
      watchForItems: [
        Tr.t('dust_watch_1'),
        Tr.t('dust_watch_2'),
        Tr.t('dust_watch_3'),
      ],
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
        leading: const BackButton(color: AppColors.textPrimary),
        title: Text(Tr.t('safety_hub_title'),
            style: AppTextStyles.cardTitle.copyWith(color: AppColors.primary)),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_safety',
        backgroundColor: AppColors.primary,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChatScreen()),
        ),
        child: const Icon(Icons.smart_toy_outlined, color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Emergency Safe Bag section
          Text(Tr.t('safety_bag_section'), style: AppTextStyles.sectionLabel),
          const SizedBox(height: 10),
          _HubCard(
            icon: Icons.backpack_outlined,
            title: Tr.t('safety_bag_title'),
            subtitle: Tr.t('safety_bag_subtitle'),
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
              builder: (_) => const _SafeBagBottomSheet(),
            ),
          ),
          const SizedBox(height: 24),

          // Safety guides section
          Text(Tr.t('safety_guides_section'), style: AppTextStyles.sectionLabel),
          const SizedBox(height: 10),
          ..._guides.map((g) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _HubCard(
                  emoji: g.emoji,
                  title: g.title,
                  subtitle: g.subtitle,
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    builder: (_) => _SafetyGuideBottomSheet(guide: g),
                  ),
                ),
              )),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.aiCardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.aiCardBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    size: 15, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    Tr.t('safety_info_note'),
                    style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _HubCard extends StatelessWidget {
  final String? emoji;
  final IconData? icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _HubCard({
    this.emoji,
    this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: emoji != null
                    ? Center(
                        child: Text(emoji!,
                            style: const TextStyle(fontSize: 22)))
                    : Icon(icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
                    const SizedBox(height: 3),
                    Text(subtitle,
                        style: AppTextStyles.caption.copyWith(
                            color: AppColors.textMuted, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: AppColors.textMuted, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Safe Bag Bottom Sheet
// ============================================================
class _SafeBagBottomSheet extends StatefulWidget {
  const _SafeBagBottomSheet();
  @override
  State<_SafeBagBottomSheet> createState() => _SafeBagBottomSheetState();
}

class _SafeBagBottomSheetState extends State<_SafeBagBottomSheet> {
  List<String> get _items => [
    Tr.t('bag_water'),
    Tr.t('bag_food'),
    Tr.t('bag_first_aid'),
    Tr.t('bag_medicines'),
    Tr.t('bag_flashlight'),
    Tr.t('bag_batteries'),
    Tr.t('bag_power_bank'),
    Tr.t('bag_documents'),
    Tr.t('bag_contacts'),
    Tr.t('bag_hygiene'),
    Tr.t('bag_clothing'),
    Tr.t('bag_whistle'),
    Tr.t('bag_map'),
  ];

  late final List<bool> _checked;

  @override
  void initState() {
    super.initState();
    _checked = List.filled(13, false);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (ctx, scrollController) {
        return Column(
          children: [
            // Handle + header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                       color: AppColors.border,
                       borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Text(Tr.t('safety_bag_title'),
                              style: AppTextStyles.cardTitle.copyWith(
                                  fontSize: 18))),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textMuted),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Tr.t('safety_bag_subtitle'),
                    style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Checklist
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _items.length,
                itemBuilder: (_, i) {
                  return CheckboxListTile(
                    value: _checked[i],
                    onChanged: (v) => setState(() => _checked[i] = v ?? false),
                    title: Text(_items[i],
                        style: AppTextStyles.body.copyWith(
                            decoration: _checked[i]
                                ? TextDecoration.lineThrough
                                : null,
                            color: _checked[i]
                                ? AppColors.textMuted
                                : AppColors.textPrimary)),
                    activeColor: AppColors.primary,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  );
                },
              ),
            ),
            // Info note
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.aiCardBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.aiCardBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      size: 14, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(Tr.t('safety_bag_hint'),
                        style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(Tr.t('done')),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: Text(Tr.t('close')),
                    ),
                  ),
                ],
              ),
            ),

            const SafeArea(top: false, child: SizedBox(height: 8)),
          ],
        );
      },
    );
  }
}

// ============================================================
// Safety Guide Entry Model
// ============================================================
class _GuideEntry {
  final String emoji;
  final String title;
  final String subtitle;
  final List<String> doItems;
  final List<String> doNotItems;
  final List<String> watchForItems;
  const _GuideEntry({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.doItems,
    required this.doNotItems,
    required this.watchForItems,
  });
}

// ============================================================
// Safety Guide Bottom Sheet
// ============================================================
class _SafetyGuideBottomSheet extends StatelessWidget {
  final _GuideEntry guide;
  const _SafetyGuideBottomSheet({required this.guide});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (ctx, scrollController) {
        return Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 12, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(guide.title,
                            style: AppTextStyles.cardTitle.copyWith(
                                fontSize: 18)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textMuted),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  Text(guide.subtitle,
                      style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Divider(height: 1),
            // Content
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  _GuideSection(
                    icon: Icons.check_circle_outline,
                    title: Tr.t('guide_do'),
                    color: AppColors.riskLow,
                    items: guide.doItems,
                  ),
                  const SizedBox(height: 12),
                  _GuideSection(
                    icon: Icons.warning_amber_outlined,
                    title: Tr.t('guide_do_not'),
                    color: AppColors.riskHigh,
                    items: guide.doNotItems,
                  ),
                  const SizedBox(height: 12),
                  _GuideSection(
                    icon: Icons.remove_red_eye_outlined,
                    title: Tr.t('guide_watch_for'),
                    color: AppColors.primary,
                    items: guide.watchForItems,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            // Action buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.contact_phone_outlined, size: 16),
                      label: Text(Tr.t('view_emergency_contacts')),
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const EmergencyContactsScreen()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.close, size: 16),
                      label: Text(Tr.t('close')),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ),
                ],
              ),
            ),

            const SafeArea(top: false, child: SizedBox(height: 8)),
          ],
        );
      },
    );
  }
}

class _GuideSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final List<String> items;
  const _GuideSection({
    required this.icon,
    required this.title,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(title,
                  style: AppTextStyles.caption.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14)),
            ],
          ),
          const SizedBox(height: 10),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(item,
                    style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary, height: 1.4)),
              )),
        ],
      ),
    );
  }
}
