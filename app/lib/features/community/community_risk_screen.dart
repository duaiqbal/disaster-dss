import 'package:flutter/material.dart';
import '../../core/models/community_report.dart';
import '../../core/services/disaster_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/localization/app_translations.dart';
import '../chat/chat_screen.dart';

class CommunityRiskScreen extends StatefulWidget {
  const CommunityRiskScreen({super.key});
  @override
  State<CommunityRiskScreen> createState() => _CommunityRiskScreenState();
}

class _CommunityRiskScreenState extends State<CommunityRiskScreen> {
  List<CommunityReport> _reports = [];
  bool _loading = true;
  bool _isListView = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final reports = await DisasterRepository().getCommunityReports();
    if (mounted) {
      setState(() {
        _reports = reports;
        _loading = false;
      });
    }
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
            Text(Tr.t('community_title'),
                style: AppTextStyles.cardTitle.copyWith(fontSize: 17)),
            Text(Tr.t('community_subtitle'),
                style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted, fontSize: 11)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_community',
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
                  _SectionHeader(
                    reportCount: _reports.length,
                    isListView: _isListView,
                    onToggle: (v) => setState(() => _isListView = v),
                  ),
                  const SizedBox(height: 12),
                  if (_isListView)
                    ..._reports.map((r) => _ReportCard(report: r))
                  else
                    const _CommunityMapPlaceholder(),
                  const SizedBox(height: 12),
                  _ReportCta(),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      Tr.t('prototype_data'),
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
                Text(Tr.t('community_privacy_title'),
                    style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary, height: 1.5),
                    children: [
                      TextSpan(
                          text: Tr.t('community_privacy_body')),
                      TextSpan(
                          text: Tr.t('community_privacy_threshold'),
                          style: const TextStyle(fontWeight: FontWeight.w700)),
                      const TextSpan(text: '.'),
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
  final bool isListView;
  final ValueChanged<bool> onToggle;

  const _SectionHeader({
    required this.reportCount,
    required this.isListView,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(Tr.t('verified_issues'),
            style: AppTextStyles.sectionLabel.copyWith(fontSize: 18)),
        const Spacer(),
        _ViewToggle(isListView: isListView, onToggle: onToggle),
      ],
    );
  }
}

class _ViewToggle extends StatelessWidget {
  final bool isListView;
  final ValueChanged<bool> onToggle;

  const _ViewToggle({required this.isListView, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _tab(Tr.t('view_list'), isListView, () => onToggle(true)),
          _tab(Tr.t('view_map_tab'), !isListView, () => onToggle(false)),
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

class _CommunityMapPlaceholder extends StatelessWidget {
  const _CommunityMapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.map_outlined,
                  size: 28, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            Text(
              Tr.t('map_view_soon'),
              style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              Tr.t('map_view_soon_desc'),
              style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final CommunityReport report;
  const _ReportCard({required this.report});

  String _translateType(String type) {
    final lower = type.toLowerCase();
    if (lower.contains('road') || lower.contains('block')) return Tr.t('issue_road_block');
    if (lower.contains('land')) return Tr.t('issue_landslide');
    if (lower.contains('flood')) return Tr.t('issue_flood');
    if (lower.contains('water')) return Tr.t('issue_water_shortage');
    if (lower.contains('infra')) return Tr.t('issue_infrastructure');
    return type;
  }

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
                    Text(_translateType(report.type),
                        style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
                    const SizedBox(height: 2),
                    Text('${Tr.t('report_area')}: ${report.area}',
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
                  report.area.contains('settlement')
                      ? Tr.t('report_status_recent')
                      : Tr.t('report_status_active'),
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
                  '${Tr.t('verified_by')} ${report.reportCount} ${Tr.t('independent_reports')}',
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
          Text(Tr.t('report_cta_title'),
              style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
              textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(Tr.t('report_cta_sub'),
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
              label: Text(Tr.t('report_issue_btn')),
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

  List<String> get _types => [
    Tr.t('issue_road_block'),
    Tr.t('issue_landslide'),
    Tr.t('issue_flood'),
    Tr.t('issue_water_shortage'),
    Tr.t('issue_infrastructure'),
    Tr.t('issue_other'),
  ];

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(Tr.t('report_what_type'))));
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
        title: Text(Tr.t('report_hazard_title'),
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
            Text(Tr.t('report_issue_title'),
                style: AppTextStyles.screenHeader.copyWith(fontSize: 24)),
            const SizedBox(height: 6),
            Text(Tr.t('report_issue_sub'),
                style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary, height: 1.5)),
            const SizedBox(height: 20),

            // Type card
            _Card(
              title: Tr.t('report_what_type'),
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
              title: Tr.t('report_where'),
              titleSuffix: Text(Tr.t('report_location_change'),
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
                    Text(Tr.t('location_chitral'),
                        style: AppTextStyles.body.copyWith(
                            color: AppColors.primary, fontSize: 14)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Description card
            _Card(
              title: Tr.t('report_details'),
              child: Column(
                children: [
                  TextField(
                    controller: _descController,
                    maxLines: 5,
                    style: AppTextStyles.body.copyWith(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: Tr.t('report_details_hint'),
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
                      SnackBar(
                          content: Text(Tr.t('photo_upload_soon'))),
                    ),
                    icon: const Icon(Icons.add_a_photo_outlined,
                        size: 16, color: AppColors.primary),
                    label: Text(Tr.t('report_add_photo'),
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
                      Text(Tr.t('report_privacy_title'),
                          style: AppTextStyles.caption.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Tr.t('report_privacy_full'),
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
                        Text(Tr.t('report_privacy_threshold'),
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
                label: Text(_submitting ? Tr.t('report_submitting') : Tr.t('report_submit_btn')),
                onPressed: _submitting ? null : _submit,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                Tr.t('report_proto_note'),
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
          Text(Tr.t('report_success_title'),
              style: AppTextStyles.cardTitle.copyWith(fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            Tr.t('report_success_sub'),
            style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            Tr.t('report_success_note'),
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
              label: Text(Tr.t('go_to_community_risk')),
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
              child: Text(Tr.t('close')),
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
