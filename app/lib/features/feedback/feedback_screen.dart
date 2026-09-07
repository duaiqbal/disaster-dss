import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/localization/app_translations.dart';
import '../chat/chat_screen.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  // Was the recommendation useful?
  bool? _helpful; // true = helpful, false = not helpful

  // Did you follow?
  String? _followedOption; // 'Yes' | 'Partially' | 'No'

  // What made it difficult (multi-select)
  final Set<String> _difficulties = {};
  List<String> get _difficultyOptions => [
    Tr.t('feedback_d_expensive'),
    Tr.t('feedback_d_time'),
    Tr.t('feedback_d_unclear'),
    Tr.t('feedback_d_transport'),
    Tr.t('feedback_d_prepared'),
    Tr.t('feedback_d_other'),
  ];

  bool _submitting = false;

  Future<void> _submit() async {
    if (_helpful == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(Tr.t('feedback_required')),
          backgroundColor: AppColors.primary,
        ),
      );
      return;
    }
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _submitting = false);
    if (mounted) _showSuccess();
  }

  void _showSuccess() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _FeedbackSuccessSheet(
        onDone: () {
          Navigator.pop(context); // close sheet
          Navigator.pop(context); // back
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
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab_feedback',
        backgroundColor: AppColors.primary,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChatScreen()),
        ),
        child: const Icon(Icons.smart_toy_outlined, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Tr.t('feedback_title'),
                style: AppTextStyles.screenHeader.copyWith(fontSize: 26)),
            const SizedBox(height: 8),
            Text(
              Tr.t('feedback_subtitle'),
              style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),

            // Was it useful?
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Tr.t('feedback_q1'),
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _ThumbBtn(
                          icon: Icons.thumb_up_outlined,
                          label: Tr.t('feedback_helpful'),
                          active: _helpful == true,
                          onTap: () => setState(() => _helpful = true),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ThumbBtn(
                          icon: Icons.thumb_down_outlined,
                          label: Tr.t('feedback_not_helpful'),
                          active: _helpful == false,
                          onTap: () => setState(() => _helpful = false),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Did you follow?
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Tr.t('feedback_q2'),
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                  const SizedBox(height: 14),
                  ...[
                    (Tr.t('feedback_yes'), 'Yes'),
                    (Tr.t('feedback_partially'), 'Partially'),
                    (Tr.t('feedback_no'), 'No'),
                  ].map((pair) {
                    final label = pair.$1;
                    final optKey = pair.$2;
                    final selected = _followedOption == optKey;
                    return GestureDetector(
                      onTap: () => setState(() => _followedOption = optKey),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primaryContainer
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selected ? AppColors.primary : AppColors.border,
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(label,
                              style: AppTextStyles.body.copyWith(
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.normal)),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // What made it difficult?
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Tr.t('feedback_q3'),
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(Tr.t('feedback_q3_sub'),
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _difficultyOptions.map((opt) {
                      final sel = _difficulties.contains(opt);
                      return GestureDetector(
                        onTap: () => setState(() {
                          if (sel) {
                            _difficulties.remove(opt);
                          } else {
                            _difficulties.add(opt);
                          }
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: sel
                                ? AppColors.primaryContainer
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: sel ? AppColors.primary : AppColors.border,
                              width: sel ? 1.5 : 1,
                            ),
                          ),
                          child: Text(opt,
                              style: AppTextStyles.caption.copyWith(
                                  color: sel
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  fontWeight: sel
                                      ? FontWeight.w600
                                      : FontWeight.normal)),
                        ),
                      );
                    }).toList(),
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
                    : const Icon(Icons.send_outlined, size: 16),
                label: Text(_submitting ? Tr.t('feedback_submitting') : Tr.t('feedback_submit')),
                onPressed: _submitting ? null : _submit,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline,
                      size: 13, color: AppColors.textMuted),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      Tr.t('feedback_disclaimer'),
                      style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 11,
                          height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
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
      child: child,
    );
  }
}

class _ThumbBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _ThumbBtn({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: active ? AppColors.primaryContainer : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.border,
            width: active ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                size: 24,
                color: active ? AppColors.primary : AppColors.textMuted),
            const SizedBox(height: 6),
            Text(label,
                style: AppTextStyles.caption.copyWith(
                    color: active ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: active ? FontWeight.w600 : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}

// ── Success bottom sheet ───────────────────────────────────────────────────
class _FeedbackSuccessSheet extends StatelessWidget {
  final VoidCallback onDone;
  const _FeedbackSuccessSheet({required this.onDone});
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
            child: const Icon(Icons.check,
                color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: 16),
          Text(Tr.t('feedback_success_title'),
              style: AppTextStyles.cardTitle.copyWith(fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            Tr.t('feedback_success_sub'),
            style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            Tr.t('feedback_success_note'),
            style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted, height: 1.4),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
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
              onPressed: onDone,
              child: Text(Tr.t('done')),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
