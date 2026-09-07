import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/localization/app_translations.dart';
import '../../../core/localization/language_service.dart';
import '../../../core/models/weather_data.dart';
import '../../../core/models/household_risk.dart';
import '../../../core/models/official_alert.dart';
import '../../../core/services/disaster_repository.dart';
import '../widgets/current_conditions_card.dart';
import '../widgets/household_risk_card.dart';
import '../widgets/official_warning_card.dart';
import '../widgets/community_risk_card.dart';
import '../widgets/ai_recommendation_card.dart';
import '../widgets/seven_day_forecast_preview.dart';
import '../widgets/household_risk_bottom_sheet.dart';

class MainRiskDashboardScreen extends StatefulWidget {
  final Function(int)? onNavigateToTab;
  final VoidCallback? onOpenAiAssistant;
  final Function(OfficialAlert)? onOpenAlertDetails;
  final VoidCallback? onOpenCommunityReports;
  final DisasterRepository? repository;

  const MainRiskDashboardScreen({
    super.key,
    this.onNavigateToTab,
    this.onOpenAiAssistant,
    this.onOpenAlertDetails,
    this.onOpenCommunityReports,
    this.repository,
  });

  @override
  State<MainRiskDashboardScreen> createState() => _MainRiskDashboardScreenState();
}

class _MainRiskDashboardScreenState extends State<MainRiskDashboardScreen> {
  late final DisasterRepository _repository;

  bool _isLoading = true;
  String? _errorMessage;
  String? _userInitials;

  CurrentConditions _conditions = CurrentConditions.defaultChitral;
  HouseholdRisk _risk = HouseholdRisk.defaultModerate;
  OfficialAlert _alert = OfficialAlert.warningFromPMD;
  String get _aiRecommendationDefault => Tr.t('ai_recommendation_text');
  late String _aiRecommendation;

  List<DailyForecast> _forecasts = DailyForecast.sample7Day;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? DisasterRepository();
    _aiRecommendation = _aiRecommendationDefault;
    _loadUserInitials();
    _loadData();
  }

  Future<void> _loadUserInitials() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name');
    if (name != null && name.trim().isNotEmpty) {
      final parts = name.trim().split(RegExp(r'\s+'));
      String initials;
      if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else {
        initials = name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
      }
      if (mounted) {
        setState(() => _userInitials = initials);
      }
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        _repository.getCurrentConditions(),
        _repository.getHouseholdRisk(),
        _repository.getLatestWarning(),
        _repository.getAiRecommendation(),
        _repository.get7DayForecast(),
      ]);

      if (mounted) {
        setState(() {
          _conditions = results[0] as CurrentConditions;
          _risk = results[1] as HouseholdRisk;
          _alert = results[2] as OfficialAlert;
          _aiRecommendation = results[3] as String;
          _forecasts = results[4] as List<DailyForecast>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = Tr.t('dashboard_load_error');
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                if (_errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.riskHighBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.riskHigh, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(fontSize: 13, color: AppColors.riskHigh),
                          ),
                        ),
                        TextButton(
                          onPressed: _loadData,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            Tr.t('retry'),
                            style: const TextStyle(
                              color: AppColors.riskHigh,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      child: LinearProgressIndicator(
                        minHeight: 3,
                        color: AppColors.primary,
                        backgroundColor: AppColors.primaryContainer,
                      ),
                    ),
                  ),
                CurrentConditionsCard(conditions: _conditions),
                const SizedBox(height: 16),
                HouseholdRiskCard(
                    risk: _risk,
                    onViewFactors: () {
                      HouseholdRiskBottomSheet.show(context, _risk);
                    },
                  ),
                  const SizedBox(height: 16),
                  OfficialWarningCard(
                    alert: _alert,
                    onViewAlert: () {
                      if (widget.onOpenAlertDetails != null) {
                        widget.onOpenAlertDetails!(_alert);
                      } else if (widget.onNavigateToTab != null) {
                        widget.onNavigateToTab!(3); // Alerts tab
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  CommunityRiskCard(
                    onViewReports: () {
                      if (widget.onOpenCommunityReports != null) {
                        widget.onOpenCommunityReports!();
                      } else if (widget.onNavigateToTab != null) {
                        widget.onNavigateToTab!(2); // Map or Community tab
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  AiRecommendationCard(
                    recommendation: _aiRecommendation,
                    onAskAi: () {
                      if (widget.onOpenAiAssistant != null) {
                        widget.onOpenAiAssistant!();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  SevenDayForecastPreview(
                    forecasts: _forecasts,
                    onViewFull: () {
                      if (widget.onNavigateToTab != null) {
                        widget.onNavigateToTab!(1); // Forecast tab
                      }
                    },
                  ),
                  const SizedBox(height: 80), // Padding above floating button / bottom bar
                ],
              ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Tr.t('greeting'),
                style: AppTextStyles.screenHeader,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 15,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    Tr.t('location_chitral'),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            if (widget.onNavigateToTab != null) {
              widget.onNavigateToTab!(4); // Profile tab
            }
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              _userInitials ?? (LanguageService.instance.isUrdu ? 'ح ا' : 'HA'),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
