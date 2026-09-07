import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/models/official_alert.dart';
import '../../core/services/disaster_repository.dart';

class OfficialAlertsScreen extends StatefulWidget {
  final Function(OfficialAlert)? onSelectAlert;

  const OfficialAlertsScreen({super.key, this.onSelectAlert});

  @override
  State<OfficialAlertsScreen> createState() => _OfficialAlertsScreenState();
}

class _OfficialAlertsScreenState extends State<OfficialAlertsScreen> {
  final DisasterRepository _repository = DisasterRepository();
  List<OfficialAlert> _alerts = [];
  bool _loading = true;
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Flood', 'Landslide', 'Heavy Rain'];

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    setState(() => _loading = true);
    final alerts = await _repository.getAllAlerts();
    if (mounted) {
      setState(() {
        _alerts = alerts;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Alerts', style: AppTextStyles.screenHeader),
            Text('Official warnings and important risk updates', style: AppTextStyles.caption),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          // Category filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: _categories.map((cat) {
                final selected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: selected,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.surface,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: selected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : RefreshIndicator(
                    onRefresh: _loadAlerts,
                    color: AppColors.primary,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: _alerts.length,
                      itemBuilder: (context, index) {
                        final alert = _alerts[index];
                        return _buildAlertCard(alert);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(OfficialAlert alert) {
    final isHigh = alert.severity.toLowerCase() == 'high';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isHigh ? AppColors.riskHighBg : AppColors.riskModerateBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isHigh ? Icons.warning_amber_rounded : Icons.info_outline,
                            size: 14,
                            color: isHigh ? AppColors.riskHigh : AppColors.riskModerate,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'OFFICIAL WARNING',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isHigh ? AppColors.riskHigh : AppColors.riskModerate,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(alert.issuedAgo, style: AppTextStyles.caption),
                  ],
                ),
                const SizedBox(height: 12),
                Text(alert.title, style: AppTextStyles.cardTitle),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.apartment, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(alert.sourceOrg, style: AppTextStyles.caption),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('SEVERITY', style: AppTextStyles.sectionLabel),
                          const SizedBox(height: 2),
                          Text(
                            alert.severity,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isHigh ? AppColors.riskHigh : AppColors.riskModerate,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('AREA', style: AppTextStyles.sectionLabel),
                          const SizedBox(height: 2),
                          Text(
                            alert.area,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  alert.description,
                  style: AppTextStyles.body.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
          if (alert.aiRiskAssessment != null)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.aiCardBg,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.smart_toy_outlined, size: 16, color: AppColors.aiAccent),
                      SizedBox(width: 6),
                      Text(
                        'AI RISK ASSESSMENT',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.aiAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    alert.aiRiskAssessment!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      height: 1.35,
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
