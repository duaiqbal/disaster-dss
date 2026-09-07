import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../chat/chat_screen.dart';
import '../profile/emergency_contacts_screen.dart';

// ============================================================
// Safety Hub Screen
// ============================================================
class SafetyHubScreen extends StatelessWidget {
  const SafetyHubScreen({super.key});

  static const _guides = [
    _GuideEntry(
      emoji: '🌊',
      title: 'Flash Flood & River Rise',
      subtitle: 'What to do when flood risk increases.',
      doItems: [
        'Move to higher ground early.',
        'Stay away from rivers, streams, and drainage channels.',
        'Follow official evacuation instructions.',
        'Keep your phone charged and emergency contacts accessible.',
      ],
      doNotItems: [
        'Do not walk or drive through floodwater.',
        'Do not cross bridges with fast-moving water.',
        'Do not wait until water reaches your home to evacuate.',
      ],
      watchForItems: [
        'Rapidly rising water',
        'Overflowing drains',
        'Sudden changes in river level',
        'Official evacuation warnings',
      ],
    ),
    _GuideEntry(
      emoji: '⛰️',
      title: 'Slope Stability & Debris Flow',
      subtitle: 'What to do when landslide risk increases.',
      doItems: [
        'Evacuate immediately if you hear rumbling or cracking sounds.',
        'Move perpendicular to the flow path, not downhill.',
        'Alert neighbours and report to local authorities.',
        'Move livestock to safer ground.',
      ],
      doNotItems: [
        'Do not shelter in valleys or near hillsides.',
        'Do not return until authorities declare it safe.',
        'Do not cross areas with fresh debris.',
      ],
      watchForItems: [
        'Cracks or bulges in the ground',
        'Sudden increase in stream turbidity',
        'Trees leaning on slopes',
        'Unusual sounds from hillsides',
      ],
    ),
    _GuideEntry(
      emoji: '☀️',
      title: 'Extreme Heat Waves',
      subtitle: 'Staying safe during prolonged high temperatures.',
      doItems: [
        'Stay indoors during peak heat hours (11am–3pm).',
        'Drink plenty of water throughout the day.',
        'Check on elderly neighbours and vulnerable family members.',
        'Wear light, loose-fitting clothing.',
      ],
      doNotItems: [
        'Do not leave children or animals in parked vehicles.',
        'Do not do strenuous activity outdoors during peak heat.',
        'Do not ignore signs of heat stroke (confusion, no sweating).',
      ],
      watchForItems: [
        'Unusual thirst and dark urine',
        'Dizziness or fainting',
        'Official heat warnings from PMD',
        'Livestock distress',
      ],
    ),
    _GuideEntry(
      emoji: '💨',
      title: 'Wind & Heavy Precipitation',
      subtitle: 'Preparing for strong winds and storms.',
      doItems: [
        'Secure loose objects outdoors before the storm.',
        'Stay indoors away from windows during high winds.',
        'Keep gutters and drains clear to prevent waterlogging.',
        'Have a battery-powered radio for official updates.',
      ],
      doNotItems: [
        'Do not shelter under trees during lightning.',
        'Do not attempt to drive in reduced-visibility conditions.',
        'Do not use candles near flammable materials during power cuts.',
      ],
      watchForItems: [
        'PMD severe weather advisories',
        'Rapidly darkening skies',
        'Flash flood risk after heavy rain',
        'Damaged power lines',
      ],
    ),
    _GuideEntry(
      emoji: '🌫️',
      title: 'Dust & Air Quality',
      subtitle: 'How to reduce exposure when air quality deteriorates.',
      doItems: [
        'Stay indoors when AQI is poor.',
        'Keep windows and doors closed.',
        'Avoid unnecessary outdoor activity.',
        'Drink water regularly.',
      ],
      doNotItems: [
        'Do not engage in strenuous outdoor activity.',
        'Do not keep ventilation open during dust storms.',
        'Do not ignore respiratory symptoms.',
      ],
      watchForItems: [
        'AQI Levels (PM2.5 deterioration)',
        'Reduced surface visibility',
        'Official dust & air quality advisories',
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
        title: Text('Safety Hub',
            style: AppTextStyles.cardTitle.copyWith(color: AppColors.primary)),
      ),
      floatingActionButton: FloatingActionButton(
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
          Text('Emergency Safe Bag', style: AppTextStyles.sectionLabel),
          const SizedBox(height: 10),
          _HubCard(
            icon: Icons.backpack_outlined,
            title: 'Emergency Safe Bag Checklist',
            subtitle: 'Essential items to keep ready for rapid evacuation.',
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
          Text('Safety Guides', style: AppTextStyles.sectionLabel),
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
                    'Safety information is sourced from official NDMA and PMD guidelines.',
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
  static const _items = [
    'Drinking water',
    'Ready-to-eat food',
    'First-aid supplies',
    'Essential medicines',
    'Flashlight',
    'Extra batteries',
    'Power bank',
    'Copies of important documents',
    'Emergency contact information',
    'Basic hygiene supplies',
    'Warm/light clothing',
    'Whistle',
    'Local map',
  ];

  late final List<bool> _checked;

  @override
  void initState() {
    super.initState();
    _checked = List.filled(_items.length, false);
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
                          child: Text('Emergency Safe Bag',
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
                    'Essential items to keep ready for rapid evacuation.',
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
                    child: Text('Keep the bag somewhere easy to access.',
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
                      child: const Text('Done'),
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
                      child: const Text('Close'),
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
                    title: 'Do',
                    color: AppColors.riskLow,
                    items: guide.doItems,
                  ),
                  const SizedBox(height: 12),
                  _GuideSection(
                    icon: Icons.warning_amber_outlined,
                    title: 'Do Not',
                    color: AppColors.riskHigh,
                    items: guide.doNotItems,
                  ),
                  const SizedBox(height: 12),
                  _GuideSection(
                    icon: Icons.remove_red_eye_outlined,
                    title: 'Watch For',
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
                      label: const Text('View Emergency Contacts'),
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
                      label: const Text('Close'),
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
