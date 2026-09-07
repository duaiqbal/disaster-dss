import 'package:flutter/material.dart';
import '../../core/models/weather_data.dart';
import '../../core/services/disaster_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/localization/app_translations.dart';
import '../../core/localization/language_service.dart';
import '../simulator/decision_simulator_screen.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});
  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  CurrentConditions? _current;
  List<DailyForecast> _forecast = [];
  bool _loading = true;


  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _hasError = false;
    });
    try {
      final repo = DisasterRepository();
      final results = await Future.wait([
        repo.getCurrentConditions(),
        repo.getDailyForecast(days: 7),
      ]);
      if (mounted) {
        setState(() {
          _current = results[0] as CurrentConditions;
          _forecast = results[1] as List<DailyForecast>;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _hasError = true;
        });
      }
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
        title: Row(
          children: [
            const Icon(Icons.location_on_outlined,
                color: AppColors.primary, size: 16),
            const SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Tr.t('location_chitral_pk'),
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                Text(Tr.t('forecast_label'),
                    style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.search, color: AppColors.textSecondary),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_forecast',
        backgroundColor: AppColors.primary,
        mini: true,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DecisionSimulatorScreen()),
        ),
        child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 20),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : _hasError
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.cloud_off_outlined,
                            size: 48, color: AppColors.textMuted),
                        const SizedBox(height: 12),
                        Text(
                          Tr.t('forecast_load_error'),
                          style: AppTextStyles.body,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _load,
                          child: Text(Tr.t('retry')),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  color: AppColors.primary,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _CurrentConditionsCard(current: _current!),
                      const SizedBox(height: 16),
                      _HourlyForecastCard(),
                      const SizedBox(height: 16),
                      _RiskRelevantCard(),
                      const SizedBox(height: 16),
                      _DecisionSimCard(),
                      const SizedBox(height: 16),
                      _SevenDayCard(forecast: _forecast),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
    );
  }
}

// ── Current conditions card ────────────────────────────────────────────────
class _CurrentConditionsCard extends StatelessWidget {
  final CurrentConditions current;
  const _CurrentConditionsCard({required this.current});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🌤', style: TextStyle(fontSize: 36)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${current.tempC.toStringAsFixed(0)}°C',
                      style: AppTextStyles.screenHeader.copyWith(fontSize: 36)),
                  Text(current.condition,
                      style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary)),
                  Text('${Tr.t('feels_like')} ${(current.tempC + 1).toStringAsFixed(0)}°C',
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ConditionPill('💧', '${current.humidityPercent}%', Tr.t('humidity')),
              _ConditionPill('💨', '${current.windKph}km/h', Tr.t('wind')),
              _ConditionPill('🌧', '${current.rainProbabilityPercent}%', Tr.t('rain')),
              _ConditionPill('☀️', Tr.t('uv_low'), Tr.t('uv')),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConditionPill extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  const _ConditionPill(this.icon, this.value, this.label);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text(value,
            style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
        Text(label,
            style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted, fontSize: 11)),
      ],
    );
  }
}

// ── Hourly forecast card ───────────────────────────────────────────────────
class _HourlyForecastCard extends StatelessWidget {
  static List<(String, String, String)> get _hourly {
    final now = DateTime.now();
    String formatHour(DateTime dt) {
      final h = dt.hour;
      final ampm = h >= 12
          ? (LanguageService.instance.isUrdu ? 'شام' : 'PM')
          : (LanguageService.instance.isUrdu ? 'صبح' : 'AM');
      final hour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
      return '$hour $ampm';
    }
    return [
      (Tr.t('now_label'), '🌤', '24°'),
      (formatHour(now.add(const Duration(hours: 1))), '🌥', '22°'),
      (formatHour(now.add(const Duration(hours: 2))), '☁️', '21°'),
      (formatHour(now.add(const Duration(hours: 3))), '☁️', '20°'),
      (formatHour(now.add(const Duration(hours: 4))), '🌧', '19°'),
      (formatHour(now.add(const Duration(hours: 5))), '🌧', '18°'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final hourly = _hourly;
    final nowLabel = Tr.t('now_label');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Tr.t('hourly_forecast'), style: AppTextStyles.sectionLabel),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: hourly.map((h) {
                final (time, icon, temp) = h;
                final isNow = time == nowLabel;
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isNow ? AppColors.primaryContainer : AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isNow ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(time,
                          style: AppTextStyles.caption.copyWith(
                              color: isNow ? AppColors.primary : AppColors.textMuted,
                              fontWeight: isNow ? FontWeight.w600 : FontWeight.normal,
                              fontSize: 12)),
                      const SizedBox(height: 8),
                      Text(icon, style: const TextStyle(fontSize: 22)),
                      const SizedBox(height: 8),
                      Text(temp,
                          style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Risk-relevant weather card ─────────────────────────────────────────────
class _RiskRelevantCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.aiCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.aiCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_outlined,
                  color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(Tr.t('risk_relevant_weather'),
                  style: AppTextStyles.cardTitle.copyWith(
                      color: AppColors.primary, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            Tr.t('risk_weather_para'),
            style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary, height: 1.5, fontSize: 13),
          ),
          const SizedBox(height: 16),
          // Risk chain
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ChainNode('🌧', Tr.t('rainfall_chain_label'), false),
              const Icon(Icons.arrow_forward,
                  color: AppColors.textMuted, size: 14),
              _ChainNode('🏔', Tr.t('slope_chain_label'), false),
              const Icon(Icons.arrow_forward,
                  color: AppColors.textMuted, size: 14),
              _ChainNode('⚠️', Tr.t('landslide_chain_label'), true),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChainNode extends StatelessWidget {
  final String emoji;
  final String label;
  final bool highlighted;
  const _ChainNode(this.emoji, this.label, this.highlighted);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: highlighted ? AppColors.riskHighBg : AppColors.surface,
            border: Border.all(
              color: highlighted ? AppColors.riskHigh : AppColors.border,
            ),
          ),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
        ),
        const SizedBox(height: 6),
        Text(label,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
                color: highlighted ? AppColors.riskHigh : AppColors.textSecondary,
                fontSize: 11,
                fontWeight: highlighted ? FontWeight.w600 : FontWeight.normal)),
      ],
    );
  }
}

// ── Decision Sim CTA card ──────────────────────────────────────────────────
class _DecisionSimCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.balance_outlined,
                color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Tr.t('explore_options'),
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  Tr.t('explore_options_sub'),
                  style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const DecisionSimulatorScreen()),
                    ),
                    child: Text(Tr.t('run_decision_simulation')),
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

// ── 7-day forecast card ────────────────────────────────────────────────────
class _SevenDayCard extends StatelessWidget {
  final List<DailyForecast> forecast;
  const _SevenDayCard({required this.forecast});

  static List<String> get _dayNames {
    final days = [
      Tr.t('day_mon'),
      Tr.t('day_tue'),
      Tr.t('day_wed'),
      Tr.t('day_thu'),
      Tr.t('day_fri'),
      Tr.t('day_sat'),
      Tr.t('day_sun'),
    ];
    // DateTime.weekday: 1=Mon, 2=Tue, ..., 7=Sun
    final todayIndex = DateTime.now().weekday - 1;
    return List.generate(
      7,
      (i) => i == 0 ? Tr.t('now_label') : days[(todayIndex + i) % 7],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dayNames = _dayNames;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Tr.t('seven_day_forecast_label'), style: AppTextStyles.sectionLabel),
          const SizedBox(height: 14),
          ...forecast.asMap().entries.map((e) {
            final i = e.key;
            final day = e.value;
            final isHighRain = day.rainProbabilityPercent >= 50;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 44,
                    child: Text(
                      i < dayNames.length ? dayNames[i] : 'Day ${i + 1}',
                      style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary, fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(day.conditionIcon, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    '${day.rainProbabilityPercent}%',
                    style: AppTextStyles.body.copyWith(
                        color: isHighRain
                            ? AppColors.primary
                            : AppColors.textMuted,
                        fontWeight: isHighRain
                            ? FontWeight.w700
                            : FontWeight.normal,
                        fontSize: 14),
                  ),
                  const Spacer(),
                  Text('${day.highTempC.toStringAsFixed(0)}°',
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 32,
                    child: Text('${day.lowTempC.toStringAsFixed(0)}°',
                        style: AppTextStyles.body.copyWith(
                            color: AppColors.textMuted, fontSize: 14),
                        textAlign: TextAlign.right),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
