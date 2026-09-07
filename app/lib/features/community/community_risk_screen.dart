import 'package:flutter/material.dart';
import '../../core/models/community_report.dart';
import '../../core/services/disaster_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../chat/chat_screen.dart';

class CommunityRiskScreen extends StatefulWidget {
  const CommunityRiskScreen({super.key});
  @override
  State<CommunityRiskScreen> createState() => _CommunityRiskScreenState();
}

class _CommunityRiskScreenState extends State<CommunityRiskScreen> {
  List<CommunityReport> _reports = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final reports = await DisasterRepository().getCommunityReports();
    if (mounted) setState(() { _reports = reports; _loading = false; });
  }

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
        title: Column(
          children: [
            Text('Community Risk',
                style: AppTextStyles.cardTitle.copyWith(fontSize: 17)),
            Text('Aggregated reports from your area',
                style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted, fontSize: 11)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const ChatScreen())),
        child: const Icon(Icons.smart_toy_outlined, color: Colors.white),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : RefreshIndicator(
              onRefresh: _load,
              color: AppColors.primary,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _PrivacyCard(),
                  const SizedBox(height: 20),
                  _SectionHeader(reportCount: _reports.length),
                  const SizedBox(height: 12),
                  ..._reports.map((r) => _ReportCard(report: r)),
                  const SizedBox(height: 12),
                  _ReportCta(),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Prototype data may include simulated reports.',
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted, fontSize: 11),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }
}

class _PrivacyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.aiCardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Privacy & Aggregation Protocol',
                    style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary, height: 1.5),
                    children: const [
                      TextSpan(
                          text:
                              'Reports are only surfaced when enough independent reports indicate the same issue. Minimum report threshold: '),
                      TextSpan(
                          text: '3 independent reports',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      TextSpan(text: '.'),
                    ],
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

class _SectionHeader extends StatelessWidget {
  final int reportCount;
  const _SectionHeader({required this.reportCount});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Verified Issues',
            style: AppTextStyles.sectionLabel.copyWith(fontSize: 18)),
        const Spacer(),
        _ViewToggle(),
      ],
    );
  }
}

class _ViewToggle extends StatefulWidget {
  @override
  State<_ViewToggle> createState() => _ViewToggleState();
}

class _ViewToggleState extends State<_ViewToggle> {
  bool _list = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _tab('List', _list, () => setState(() => _list = true)),
          _tab('Map', !_list, () => setState(() => _list = false)),
        ],
      ),
    );
  }

  Widget _tab(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(label,
            style: AppTextStyles.caption.copyWith(
                color: active ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final CommunityReport report;
  const _ReportCard({required this.report});
  @override
  Widget build(BuildContext context) {
    final isHazard = report.type.toLowerCase().contains('road') ||
        report.type.toLowerCase().contains('block') ||
        report.type.toLowerCase().contains('land');
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isHazard
                      ? AppColors.riskHighBg
                      : const Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isHazard ? Icons.warning_amber_rounded : Icons.water_drop_outlined,
                  color: isHazard ? AppColors.riskHigh : const Color(0xFF2563EB),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(report.type,
                        style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
                    const SizedBox(height: 2),
                    Text('Area: ${report.area}',
                        style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  report.area.contains('settlement') ? 'Active' : 'Reported recently',
                  style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_outlined,
                    size: 13, color: AppColors.primary),
                const SizedBox(width: 5),
                Text(
                  'Verified by ${report.reportCount} independent reports',
                  style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportCta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          const Icon(Icons.add_location_alt_outlined,
              color: AppColors.textMuted, size: 36),
          const SizedBox(height: 10),
          Text('Notice something in your area?',
              style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
              textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text('Contribute to community intelligence.',
              style: AppTextStyles.body.copyWith(
                  color: AppColors.textMuted, fontSize: 13),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
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
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Report a local issue'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ReportHazardScreen()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// Report Hazard Screen (same file for brevity)
// ============================================================

class ReportHazardScreen extends StatefulWidget {
  const ReportHazardScreen({super.key});
  @override
  State<ReportHazardScreen> createState() => _ReportHazardScreenState();
}

class _ReportHazardScreenState extends State<ReportHazardScreen> {
  String? _selectedType;
  final _descController = TextEditingController();
  bool _submitting = false;

  static const _types = [
    'Blocked road',
    'Landslide / debris',
    'Flooding',
    'Water shortage',
    'Damaged infrastructure',
    'Other',
  ];

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please select what you are reporting.')));
      return;
    }
    setState(() => _submitting = true);
    // Fire-and-forget to backend, offline-safe
    await DisasterRepository().submitReport(
      type: _selectedType!,
      location: 'Chitral, Khyber Pakhtunkhwa',
      description: _descController.text.trim(),
    );
    setState(() => _submitting = false);
    if (mounted) _showSuccess();
  }

  void _showSuccess() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _ReportSuccessSheet(
        onBack: () {
          Navigator.pop(context); // close sheet
          Navigator.pop(context); // back to CommunityRisk
        },
      ),
    );
  }

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
        title: Text('Report Hazard',
            style: AppTextStyles.cardTitle.copyWith(color: AppColors.primary)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.info_outline,
                color: AppColors.textSecondary, size: 20),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Report a local issue',
                style: AppTextStyles.screenHeader.copyWith(fontSize: 24)),
            const SizedBox(height: 6),
            Text('Share information about a hazard or disruption in your area.',
                style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary, height: 1.5)),
            const SizedBox(height: 20),

            // Type card
            _Card(
              title: 'What are you reporting?',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _types.map((t) {
                  final sel = _selectedType == t;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedType = t),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.primaryContainer : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sel ? AppColors.primary : AppColors.border,
                          width: sel ? 1.5 : 1,
                        ),
                      ),
                      child: Text(t,
                          style: AppTextStyles.caption.copyWith(
                              color: sel ? AppColors.primary : AppColors.textSecondary,
                              fontWeight: sel ? FontWeight.w600 : FontWeight.normal)),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // Location card
            _Card(
              title: 'Where is the issue?',
              titleSuffix: Text('Change location',
                  style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary, fontWeight: FontWeight.w600)),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: AppColors.primary, size: 16),
                    const SizedBox(width: 8),
                    Text('Chitral, Khyber Pakhtunkhwa',
                        style: AppTextStyles.body.copyWith(
                            color: AppColors.primary, fontSize: 14)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Description card
            _Card(
              title: 'Description',
              titleSuffix: Text('(Optional)',
                  style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted)),
              child: Column(
                children: [
                  TextField(
                    controller: _descController,
                    maxLines: 5,
                    style: AppTextStyles.body.copyWith(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Briefly describe what you observed...',
                      hintStyle: AppTextStyles.body.copyWith(
                          color: AppColors.textDisabled, fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Photo upload coming soon.')),
                    ),
                    icon: const Icon(Icons.add_a_photo_outlined,
                        size: 16, color: AppColors.primary),
                    label: Text('Add photo',
                        style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary)),
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Privacy card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.aiCardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shield_outlined,
                          color: AppColors.primary, size: 18),
                      const SizedBox(width: 8),
                      Text('Privacy & aggregation',
                          style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your report is not displayed as an individual report. Community intelligence is surfaced only after enough independent reports indicate the same issue.',
                    style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary, height: 1.5),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withAlpha(180),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.people_outline,
                            size: 14, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text('Minimum aggregation threshold: 3 independent reports',
                            style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                icon: _submitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.send_outlined, size: 18),
                label: Text(_submitting ? 'Submitting...' : 'Submit Report'),
                onPressed: _submitting ? null : _submit,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Prototype may use simulated community reports.',
                style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted, fontSize: 11),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ── Success bottom sheet ───────────────────────────────────────────────────
class _ReportSuccessSheet extends StatelessWidget {
  final VoidCallback onBack;
  const _ReportSuccessSheet({required this.onBack});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.aiCardBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_outline,
                color: AppColors.primary, size: 30),
          ),
          const SizedBox(height: 16),
          Text('Report Submitted',
              style: AppTextStyles.cardTitle.copyWith(fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            'Thank you for helping improve community risk intelligence.',
            style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Your report will be aggregated with other independent reports and reviewed according to the community reporting protocol.',
            style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
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
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text('Back to Community Risk'),
              onPressed: onBack,
            ),
          ),
          const SizedBox(height: 10),
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
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Generic card wrapper ───────────────────────────────────────────────────
class _Card extends StatelessWidget {
  final String title;
  final Widget? titleSuffix;
  final Widget child;
  const _Card({required this.title, this.titleSuffix, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(title, style: AppTextStyles.cardTitle.copyWith(fontSize: 15))),
              if (titleSuffix != null) titleSuffix!,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
