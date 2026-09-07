import 'package:flutter/material.dart';
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
        title: Text('Climate Risk Assistant',
            style: AppTextStyles.cardTitle.copyWith(
                color: AppColors.textPrimary, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Decision Simulator',
                style: AppTextStyles.screenHeader.copyWith(fontSize: 24)),
            const SizedBox(height: 6),
            Text(
              'Compare possible actions using the current risk model.',
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
              label: const Text('Ask AI Assistant'),
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
                      'This tool explores scenarios. It is decision support, not a guaranteed forecast.',
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text('Scenarios', style: AppTextStyles.sectionLabel),
            const SizedBox(height: 12),

            // Evacuate card
            _ScenarioCard(
              icon: Icons.directions_run,
              title: 'Evacuate now',
              subtitle: 'Initiate immediate departure procedures.',
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
              title: 'Wait and monitor',
              subtitle: 'Maintain position and observe developments.',
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
                'Decision support — not a guaranteed prediction.',
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
                  'You chose: Evacuate Now',
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textMuted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Text(
              'Compare possible outcomes based on current conditions.',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Text(
              'CURRENT CONDITIONS',
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _conditionCell('Flash Flood Risk', 'High', AppColors.riskHigh)),
                const SizedBox(width: 8),
                Expanded(child: _conditionCell('Landslide Risk', 'Moderate', AppColors.textPrimary)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _conditionCell('Road Access', 'At Risk', AppColors.riskHigh)),
                const SizedBox(width: 8),
                Expanded(child: _conditionCell('Rainfall', 'Heavy', AppColors.primary)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'SIMULATED OUTCOME',
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
                      Text('Risk Exposure:', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      Text('Lower', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Route Difficulty:', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      Text('Moderate', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const Divider(height: 16),
                  Text('Potential Benefit: Reduced exposure if conditions worsen',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text('Potential Trade-off: Leaving may be difficult because roads are at risk.',
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
                    child: const Text('Give Feedback'),
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
                    child: const Text('View Safety Guide'),
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
                      'SIMULATION RESULT',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      'You chose: Wait & Monitor',
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
              'Compare possible outcomes based on current conditions.',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _conditionCell('Flash Flood Risk', 'High', AppColors.riskHigh)),
                const SizedBox(width: 8),
                Expanded(child: _conditionCell('Landslide Risk', 'Moderate', AppColors.textPrimary)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _conditionCell('Road Access', 'At Risk', AppColors.primary)),
                const SizedBox(width: 8),
                Expanded(child: _conditionCell('Rainfall', 'Heavy', AppColors.textPrimary)),
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
                      Text('Simulated Outcome', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Risk Exposure:', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      Text('Moderate', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Route Difficulty:', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      Text('Manageable', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
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
                          'Avoid unnecessary movement while conditions remain stable.',
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
                          'Risk may increase sharply if rainfall intensifies.',
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
                'Simulation result — not an emergency instruction.',
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
                label: const Text('View Safety Guide'),
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
                child: const Text('Give Feedback'),
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
          Text('Risk Trajectory', style: AppTextStyles.cardTitle),
          const SizedBox(height: 16),
          Row(
            children: [
              _LegendDot(color: AppColors.primary, label: 'Evacuate'),
              const SizedBox(width: 16),
              _LegendDot(color: AppColors.riskHigh, label: 'Wait'),
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
              Text('Current risk',
                  style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted, fontSize: 11)),
              Text('6 hours',
                  style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted, fontSize: 11)),
              Text('12 hours',
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
  static const _factors = [
    _FactorRow('Household exposure', 'Lower', 'Higher', true),
    _FactorRow('Isolation risk', 'Lower', 'Potentially higher', true),
    _FactorRow('Road accessibility', 'Open', 'Risk of blockage', true),
    _FactorRow('Preparation', 'Immediate', 'Monitor updates', false),
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
          Text('Factor Breakdown', style: AppTextStyles.cardTitle),
          const SizedBox(height: 12),
          // Header row
          Row(
            children: [
              const Expanded(
                  flex: 3,
                  child: Text('Factor',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w600))),
              Expanded(
                  flex: 2,
                  child: Text('EVACUATE\nNOW',
                      style: TextStyle(
                          fontSize: 10,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center)),
              const Expanded(
                  flex: 2,
                  child: Text('WAIT',
                      style: TextStyle(
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
                    child: Text('Why does the result change?',
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
                  _XaiRow('Decision', 'Scenario comparison'),
                  const SizedBox(height: 8),
                  _XaiRow('Evidence',
                      'Rainfall trend, Slope exposure, Road status'),
                  const SizedBox(height: 8),
                  _XaiRow('Reason',
                      'Increasing rainfall can increase slope saturation and the chance of road disruption.'),
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
                              Text('Confidence',
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
                                  Text('Moderate',
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
