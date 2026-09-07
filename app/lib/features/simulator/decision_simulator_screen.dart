import 'package:flutter/material.dart';
import '../../core/localization/app_translations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../chat/chat_screen.dart';
import '../safety/safety_hub_screen.dart';
import '../feedback/feedback_screen.dart';

class DecisionSimulatorScreen extends StatefulWidget {
  const DecisionSimulatorScreen({super.key});
  @override
  State<DecisionSimulatorScreen> createState() =>
      _DecisionSimulatorScreenState();
}

class _DecisionSimulatorScreenState extends State<DecisionSimulatorScreen> {
  String? _selected; // 'evacuate' | 'wait'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
        title: Text(Tr.t('sim_appbar_title'),
            style: AppTextStyles.cardTitle.copyWith(
                color: AppColors.textPrimary, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Tr.t('sim_title'),
                style: AppTextStyles.screenHeader.copyWith(fontSize: 24)),
            const SizedBox(height: 6),
            Text(
              Tr.t('sim_subtitle'),
              style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
              ),
              icon: const Icon(Icons.smart_toy_outlined, size: 16),
              label: Text(Tr.t('sim_ask_ai')),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatScreen()),
              ),
            ),
            const SizedBox(height: 16),

            // Disclaimer
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
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      Tr.t('sim_disclaimer'),
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(Tr.t('sim_scenarios'), style: AppTextStyles.sectionLabel),
            const SizedBox(height: 12),

            // Evacuate card
            _ScenarioCard(
              icon: Icons.directions_run,
              title: Tr.t('sim_evacuate_title'),
              subtitle: Tr.t('sim_evacuate_sub'),
              selected: _selected == 'evacuate',
              onTap: () {
                setState(() => _selected = 'evacuate');
                _showEvacuateSheet(context);
              },
            ),
            const SizedBox(height: 10),

            // Wait card
            _ScenarioCard(
              icon: Icons.visibility_outlined,
              title: Tr.t('sim_wait_title'),
              subtitle: Tr.t('sim_wait_sub'),
              selected: _selected == 'wait',
              onTap: () {
                setState(() => _selected = 'wait');
                _showWaitSheet(context);
              },
            ),
            const SizedBox(height: 24),

            // Risk trajectory chart (simplified custom paint)
            _RiskTrajectoryCard(selected: _selected),
            const SizedBox(height: 24),

            // Factor breakdown
            _FactorBreakdownCard(selected: _selected),
            const SizedBox(height: 24),

            // XAI card
            _XaiCard(),
            const SizedBox(height: 16),
            Center(
              child: Text(
                Tr.t('sim_footer'),
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

  void _showEvacuateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Tr.t('sim_you_chose_evacuate'),
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textMuted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Text(
              Tr.t('sim_outcomes_subtitle'),
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Text(
              Tr.t('sim_current_conditions'),
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _conditionCell(Tr.t('sim_cond_flash_flood'), Tr.t('sim_cond_high'), AppColors.riskHigh)),
                const SizedBox(width: 8),
                Expanded(child: _conditionCell(Tr.t('sim_cond_landslide'), Tr.t('sim_cond_moderate'), AppColors.textPrimary)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _conditionCell(Tr.t('sim_cond_road'), Tr.t('sim_cond_at_risk'), AppColors.riskHigh)),
                const SizedBox(width: 8),
                Expanded(child: _conditionCell(Tr.t('sim_cond_rainfall'), Tr.t('sim_cond_heavy'), AppColors.primary)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              Tr.t('sim_simulated_outcome'),
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Tr.t('sim_risk_exposure'), style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      Text(Tr.t('sim_lower'), style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Tr.t('sim_route_difficulty'), style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      Text(Tr.t('sim_moderate_val'), style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const Divider(height: 16),
                  Text(Tr.t('sim_potential_benefit'),
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text(Tr.t('sim_potential_tradeoff'),
                      style: AppTextStyles.caption.copyWith(color: AppColors.textMuted)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedbackScreen()));
                    },
                    child: Text(Tr.t('sim_give_feedback')),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const SafetyHubScreen()));
                    },
                    child: Text(Tr.t('sim_view_safety')),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showWaitSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Tr.t('sim_simulation_result'),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      Tr.t('sim_you_chose_wait'),
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textMuted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Text(
              Tr.t('sim_outcomes_subtitle'),
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _conditionCell(Tr.t('sim_cond_flash_flood'), Tr.t('sim_cond_high'), AppColors.riskHigh)),
                const SizedBox(width: 8),
                Expanded(child: _conditionCell(Tr.t('sim_cond_landslide'), Tr.t('sim_cond_moderate'), AppColors.textPrimary)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _conditionCell(Tr.t('sim_cond_road'), Tr.t('sim_cond_at_risk'), AppColors.primary)),
                const SizedBox(width: 8),
                Expanded(child: _conditionCell(Tr.t('sim_cond_rainfall'), Tr.t('sim_cond_heavy'), AppColors.textPrimary)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
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
                      const Icon(Icons.bar_chart, size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(Tr.t('sim_simulated_outcome'), style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Tr.t('sim_risk_exposure'), style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      Text(Tr.t('sim_moderate_val'), style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Tr.t('sim_route_difficulty'), style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      Text(Tr.t('sim_manageable'), style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline, size: 14, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          Tr.t('sim_wait_avoid'),
                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.riskHigh),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          Tr.t('sim_wait_warning'),
                          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                Tr.t('sim_sim_note'),
                style: AppTextStyles.caption.copyWith(color: AppColors.textMuted, fontSize: 11),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.menu_book_outlined, size: 16),
                label: Text(Tr.t('sim_view_safety')),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SafetyHubScreen()));
                },
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedbackScreen()));
                },
                child: Text(Tr.t('sim_give_feedback')),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  static Widget _conditionCell(String label, String val, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10, color: AppColors.textMuted)),
          const SizedBox(height: 3),
          Text(val, style: AppTextStyles.cardTitle.copyWith(fontSize: 13, color: color)),
        ],
      ),
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  const _ScenarioCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryContainer : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: selected ? Colors.white : AppColors.textMuted,
                  size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 16)),
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiskTrajectoryCard extends StatelessWidget {
  final String? selected;
  const _RiskTrajectoryCard({required this.selected});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Tr.t('sim_risk_trajectory'), style: AppTextStyles.cardTitle),
          const SizedBox(height: 16),
          Row(
            children: [
              _LegendDot(color: AppColors.primary, label: Tr.t('sim_evacuate_legend')),
              const SizedBox(width: 16),
              _LegendDot(color: AppColors.riskHigh, label: Tr.t('sim_wait_legend')),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: CustomPaint(
              painter: _TrajectoryPainter(
                evacuateActive: selected == 'evacuate',
                waitActive: selected == 'wait',
              ),
              size: const Size(double.infinity, 100),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(Tr.t('sim_current_risk'),
                  style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted, fontSize: 11)),
              Text(Tr.t('sim_6_hours'),
                  style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted, fontSize: 11)),
              Text(Tr.t('sim_12_hours'),
                  style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 12,
            height: 3,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 5),
        Text(label,
            style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted, fontSize: 11)),
      ],
    );
  }
}

class _TrajectoryPainter extends CustomPainter {
  final bool evacuateActive;
  final bool waitActive;
  const _TrajectoryPainter({
    required this.evacuateActive,
    required this.waitActive,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final evacuatePaint = Paint()
      ..color = AppColors.primary.withAlpha(evacuateActive ? 255 : 140)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final waitPaint = Paint()
      ..color = AppColors.riskHigh.withAlpha(waitActive ? 255 : 140)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Evacuate: dips down (lower risk trajectory)
    final evacuatePath = Path();
    evacuatePath.moveTo(0, size.height * 0.5);
    evacuatePath.cubicTo(
      size.width * 0.33, size.height * 0.45,
      size.width * 0.66, size.height * 0.3,
      size.width, size.height * 0.2,
    );

    // Wait: curves up (higher risk trajectory)
    final waitPath = Path();
    waitPath.moveTo(0, size.height * 0.5);
    waitPath.cubicTo(
      size.width * 0.33, size.height * 0.55,
      size.width * 0.66, size.height * 0.75,
      size.width, size.height * 0.9,
    );

    // dashed wait path
    _drawDashed(canvas, waitPath, waitPaint, size.width);
    canvas.drawPath(evacuatePath, evacuatePaint);
  }

  void _drawDashed(Canvas canvas, Path path, Paint paint, double totalWidth) {
    final dashPath = Path();
    const dashWidth = 8.0;
    const gapWidth = 4.0;
    final pm = path.computeMetrics().first;
    double distance = 0;
    while (distance < pm.length) {
      dashPath.addPath(
        pm.extractPath(distance, distance + dashWidth),
        Offset.zero,
      );
      distance += dashWidth + gapWidth;
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(_TrajectoryPainter old) =>
      old.evacuateActive != evacuateActive || old.waitActive != waitActive;
}

class _FactorRow {
  final String factor;
  final String evacuate;
  final String wait;
  final bool evacuateBetter;
  const _FactorRow(this.factor, this.evacuate, this.wait, this.evacuateBetter);
}

class _FactorBreakdownCard extends StatelessWidget {
  final String? selected;
  const _FactorBreakdownCard({required this.selected});

  List<_FactorRow> get _factors => [
    _FactorRow(Tr.t('sim_f_household'), Tr.t('sim_f_lower'), Tr.t('sim_f_higher'), true),
    _FactorRow(Tr.t('sim_f_isolation'), Tr.t('sim_f_lower'), Tr.t('sim_f_pot_higher'), true),
    _FactorRow(Tr.t('sim_f_road'), Tr.t('sim_f_open'), Tr.t('sim_f_blockage'), true),
    _FactorRow(Tr.t('sim_f_prep'), Tr.t('sim_f_immediate'), Tr.t('sim_f_monitor'), false),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Tr.t('sim_factor_breakdown'), style: AppTextStyles.cardTitle),
          const SizedBox(height: 12),
          // Header row
          Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Text(Tr.t('sim_factor_label'),
                      style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w600))),
              Expanded(
                  flex: 2,
                  child: Text(Tr.t('sim_evacuate_now_col'),
                      style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center)),
              Expanded(
                  flex: 2,
                  child: Text(Tr.t('sim_wait_col'),
                      style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center)),
            ],
          ),
          const Divider(height: 16),
          ..._factors.map((f) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Text(f.factor,
                          style: AppTextStyles.caption.copyWith(
                              color: AppColors.textPrimary, fontSize: 13))),
                  Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(f.evacuate,
                            style: AppTextStyles.caption.copyWith(
                                color: f.evacuateBetter
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center),
                      )),
                  Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(f.wait,
                            style: AppTextStyles.caption.copyWith(
                                color: !f.evacuateBetter
                                    ? AppColors.primary
                                    : AppColors.riskHigh),
                            textAlign: TextAlign.center),
                      )),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _XaiCard extends StatefulWidget {
  @override
  State<_XaiCard> createState() => _XaiCardState();
}

class _XaiCardState extends State<_XaiCard> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.aiCardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.aiCardBorder),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.psychology_outlined,
                      color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(Tr.t('sim_xai_title'),
                        style: AppTextStyles.cardTitle.copyWith(
                            color: AppColors.primary, fontSize: 15)),
                  ),
                  Icon(
                    _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  _XaiRow(Tr.t('sim_xai_decision'), Tr.t('sim_xai_decision_val')),
                  const SizedBox(height: 8),
                  _XaiRow(Tr.t('sim_xai_evidence'), Tr.t('sim_xai_evidence_val')),
                  const SizedBox(height: 8),
                  _XaiRow(Tr.t('sim_xai_reason'), Tr.t('sim_xai_reason_val')),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(Tr.t('sim_xai_confidence'),
                                  style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textMuted,
                                      fontSize: 11)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.riskModerate,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(Tr.t('sim_xai_confidence_val'),
                                      style: AppTextStyles.caption.copyWith(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _XaiRow extends StatelessWidget {
  final String label;
  final String value;
  const _XaiRow(this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted, fontSize: 11)),
          const SizedBox(height: 4),
          Text(value,
              style: AppTextStyles.caption.copyWith(
                  color: AppColors.textPrimary, height: 1.4)),
        ],
      ),
    );
  }
}
