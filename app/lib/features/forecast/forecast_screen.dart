import 'package:flutter/material.dart';
import '../../core/models/weather_data.dart';
import '../../core/services/disaster_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
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


  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final results = await Future.wait([
      DisasterRepository().getCurrentConditions(),
      DisasterRepository().get7DayForecast(),
    ]);
    if (mounted) {
      setState(() {
        _current = results[0] as CurrentConditions;
        _forecast = results[1] as List<DailyForecast>;
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
        title: Row(
          children: [
            const Icon(Icons.location_on_outlined,
                color: AppColors.primary, size: 16),
            const SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Chitral, Pakistan',
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                Text('Forecast',
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
                  Text('Feels like ${(current.tempC + 1).toStringAsFixed(0)}°C',
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
              _ConditionPill('💧', '${current.humidityPercent}%', 'Humidity'),
              _ConditionPill('💨', '${current.windKph}km/h', 'Wind'),
              _ConditionPill('🌧', '${current.rainProbabilityPercent}%', 'Rain'),
              _ConditionPill('☀️', 'Low', 'UV'),
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
  static const _hourly = [
    ('Now', '🌤', '24°'),
    ('6 PM', '🌥', '22°'),
    ('7 PM', '☁️', '21°'),
    ('8 PM', '☁️', '20°'),
    ('9 PM', '🌧', '19°'),
    ('10 PM', '🌧', '18°'),
  ];
  @override
  Widget build(BuildContext context) {
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
          Text('Hourly Forecast', style: AppTextStyles.sectionLabel),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _hourly.map((h) {
                final (time, icon, temp) = h;
                final isNow = time == 'Now';
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
              Text('Risk-relevant weather',
                  style: AppTextStyles.cardTitle.copyWith(
                      color: AppColors.primary, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Rainfall is expected to increase over the next 24 hours. Increased rainfall can raise slope saturation and flash-flood risk in vulnerable areas.',
            style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary, height: 1.5, fontSize: 13),
          ),
          const SizedBox(height: 16),
          // Risk chain
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ChainNode('🌧', 'Rainfall', false),
              const Icon(Icons.arrow_forward,
                  color: AppColors.textMuted, size: 14),
              _ChainNode('🏔', 'Slope\nsaturation', false),
              const Icon(Icons.arrow_forward,
                  color: AppColors.textMuted, size: 14),
              _ChainNode('⚠️', 'Landslide\npotential', true),
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
                Text('Explore Your Options',
                    style: AppTextStyles.cardTitle.copyWith(fontSize: 14)),
                const SizedBox(height: 4),
                Text(
                  'Compare Evacuate Now with Wait & Monitor based on your current risk conditions.',
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
                    child: const Text('Run Decision Simulation'),
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

  static const _dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
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
          Text('7-Day Forecast', style: AppTextStyles.sectionLabel),
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
                    width: 40,
                    child: Text(
                      i < _dayNames.length ? _dayNames[i] : 'Day ${i + 1}',
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
