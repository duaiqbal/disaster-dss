import 'package:flutter/material.dart';
import '../../core/localization/language_service.dart';
import '../../core/localization/app_translations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'login_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  late AppLanguage _selected;

  @override
  void initState() {
    super.initState();
    _selected = LanguageService.instance.current;
  }

  void _selectLanguage(AppLanguage lang) {
    setState(() => _selected = lang);
    LanguageService.instance.setLanguage(lang);
  }

  void _continue() {
    LanguageService.instance.setLanguage(_selected);
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      return;
    }
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, animation, __) => const LoginScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.03),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 32,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (Navigator.of(context).canPop())
                        InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: () => Navigator.of(context).maybePop(),
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.arrow_back,
                                color: AppColors.textPrimary),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        Tr.t('choose_language'),
                        style: AppTextStyles.screenHeader.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        Tr.t('select_language_subtitle'),
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 28),
                      _LanguageCard(
                        title: 'English',
                        subtitle: 'English guidance and interface',
                        selected: _selected == AppLanguage.english,
                        onTap: () => _selectLanguage(AppLanguage.english),
                      ),
                      const SizedBox(height: 14),
                      _LanguageCard(
                        title: 'اردو',
                        titleAlignment: TextAlign.right,
                        subtitle: 'اردو میں رہنمائی اور معلومات',
                        subtitleAlignment: TextAlign.right,
                        selected: _selected == AppLanguage.urdu,
                        onTap: () => _selectLanguage(AppLanguage.urdu),
                      ),
                      const SizedBox(height: 14),
                      _LanguageCard(
                        title: 'Roman Urdu',
                        subtitle: 'Roman Urdu mein rehnumai aur maloomat',
                        selected: _selected == AppLanguage.romanUrdu,
                        onTap: () => _selectLanguage(AppLanguage.romanUrdu),
                      ),
                      const SizedBox(height: 16),
                      const Spacer(),
                      const Divider(color: AppColors.border),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _continue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            Tr.t('continue'),
                            style: AppTextStyles.button,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          Tr.t('language_can_change_later'),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LanguageCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final TextAlign titleAlignment;
  final TextAlign subtitleAlignment;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.titleAlignment = TextAlign.left,
    this.subtitleAlignment = TextAlign.left,
  });

  @override
  State<_LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<_LanguageCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryContainer : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.6 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: widget.titleAlignment == TextAlign.right
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      textAlign: widget.titleAlignment,
                      style: AppTextStyles.cardTitle.copyWith(fontSize: 17),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      textAlign: widget.subtitleAlignment,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 22,
                height: 22,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedOpacity(
                      opacity: selected ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 150),
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border, width: 1.4),
                        ),
                      ),
                    ),
                    AnimatedScale(
                      scale: selected ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutBack,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}