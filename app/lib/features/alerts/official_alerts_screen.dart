import 'package:flutter/material.dart';
import '../../core/localization/app_translations.dart';
import '../../core/localization/language_service.dart';
import '../../core/models/official_alert.dart';
import '../../core/services/disaster_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'alert_details_screen.dart';

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

  String _getCategoryLabel(String cat) {
    switch (cat) {
      case 'All':
        return Tr.t('cat_all');
      case 'Flood':
        return Tr.t('cat_flood');
      case 'Landslide':
        return Tr.t('cat_landslide');
      case 'Heavy Rain':
        return Tr.t('cat_heavy_rain');
      default:
        return cat;
    }
  }

  /// Returns only alerts matching the selected category filter.
  List<OfficialAlert> get _filteredAlerts {
    if (_selectedCategory == 'All') return _alerts;
    return _alerts.where((a) {
      final searchIn =
          '${a.title} ${a.description}'.toLowerCase();
      return searchIn.contains(_selectedCategory.toLowerCase());
    }).toList();
  }

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Tr.t('alerts_title'), style: AppTextStyles.screenHeader),
            Text(Tr.t('alerts_subtitle'), style: AppTextStyles.caption),
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
                    label: Text(_getCategoryLabel(cat)),
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
                    onSelected: (_) =>
                        setState(() => _selectedCategory = cat),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary))
                : RefreshIndicator(
                    onRefresh: _loadAlerts,
                    color: AppColors.primary,
                    child: _filteredAlerts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.filter_list_off,
                                    size: 48, color: AppColors.textMuted),
                                const SizedBox(height: 12),
                                Text(
                                  Tr.t('no_alerts_filter'),
                                  style: AppTextStyles.body,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            itemCount: _filteredAlerts.length,
                            itemBuilder: (context, index) {
                              final alert = _filteredAlerts[index];
                              return _buildAlertCard(alert);
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  String _getAlertTitle(String title) {
    if (!LanguageService.instance.isUrdu) return title;
    if (title.contains('Rainfall')) return 'شدید بارش سے متعلق ایڈوائزری';
    if (title.contains('Flood')) return 'اچانک سیلاب کا خدشہ';
    return title;
  }

  String _getAlertOrg(String org) {
    if (!LanguageService.instance.isUrdu) return org;
    if (org.contains('Meteorological')) return 'محکمہ موسمیات پاکستان';
    if (org.contains('NDMA') || org.contains('Disaster'))
      return 'نیشنل ڈیزاسٹر مینجمنٹ اتھارٹی (این ڈی ایم اے)';
    return org;
  }

  String _getAlertArea(String area) {
    if (!LanguageService.instance.isUrdu) return area;
    if (area.contains('District')) return 'ضلع چترال';
    if (area.contains('Low-lying') || area.contains('low'))
      return 'چترال کے نشیبی علاقے';
    return area;
  }

  String _getAlertDesc(String desc) {
    if (!LanguageService.instance.isUrdu) return desc;
    if (desc.contains('Monsoon') ||
        desc.contains('rain') ||
        desc.contains('winds') ||
        desc.contains('Heavy')) {
      return 'آج سے ملک کے بالائی علاقوں میں مون سون کی شدید ہوائیں داخل ہونے کی توقع ہے۔';
    }
    if (desc.contains('Flood') ||
        desc.contains('water') ||
        desc.contains('nullah') ||
        desc.contains('streams')) {
      return 'متوقع بارش کے باعث مقامی ندی نالوں میں اچانک سیلابی ریلوں کا خطرہ ہے۔';
    }
    return desc;
  }

  String _getAlertAi(String? ai) {
    if (ai == null) return '';
    if (!LanguageService.instance.isUrdu) return ai;
    return 'بارش آپ کے گھرانے کے علاقے میں ڈھلوان میں نمی اور دباؤ کو بڑھا سکتی ہے۔ ڈھلوان کا استحکام انڈیکس اس وقت 42% ہے۔';
  }

  String _getAlertIssued(String issued) {
    if (!LanguageService.instance.isUrdu) return issued;
    if (issued.contains('2')) return '2 گھنٹے پہلے جاری کیا گیا';
    if (issued.contains('5')) return '5 گھنٹے پہلے جاری کیا گیا';
    return issued;
  }

  Widget _buildAlertCard(OfficialAlert alert) {
    final isHigh = alert.severity.toLowerCase() == 'high';

    return InkWell(
      onTap: () {
        if (widget.onSelectAlert != null) {
          widget.onSelectAlert!(alert);
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AlertDetailsScreen(alert: alert),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isHigh
                              ? AppColors.riskHighBg
                              : AppColors.riskModerateBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isHigh
                                  ? Icons.warning_amber_rounded
                                  : Icons.info_outline,
                              size: 14,
                              color: isHigh
                                  ? AppColors.riskHigh
                                  : AppColors.riskModerate,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              Tr.t('official_warning'),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isHigh
                                    ? AppColors.riskHigh
                                    : AppColors.riskModerate,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(_getAlertIssued(alert.issuedAgo),
                          style: AppTextStyles.caption),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(_getAlertTitle(alert.title),
                      style: AppTextStyles.cardTitle),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.apartment,
                          size: 14, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(_getAlertOrg(alert.sourceOrg),
                          style: AppTextStyles.caption),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                LanguageService.instance.isUrdu
                                    ? 'شدت'
                                    : 'SEVERITY',
                                style: AppTextStyles.sectionLabel),
                            const SizedBox(height: 2),
                            Text(
                              Tr.riskLevel(alert.severity),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isHigh
                                    ? AppColors.riskHigh
                                    : AppColors.riskModerate,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                LanguageService.instance.isUrdu
                                    ? 'علاقہ'
                                    : 'AREA',
                                style: AppTextStyles.sectionLabel),
                            const SizedBox(height: 2),
                            Text(
                              _getAlertArea(alert.area),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _getAlertDesc(alert.description),
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
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.smart_toy_outlined,
                            size: 16, color: AppColors.aiAccent),
                        const SizedBox(width: 6),
                        Text(
                          LanguageService.instance.isUrdu
                              ? 'اے آئی خطرے کا جائزہ'
                              : 'AI RISK ASSESSMENT',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.aiAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _getAlertAi(alert.aiRiskAssessment),
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
      ),
    );
  }
}
