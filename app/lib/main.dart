import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/language_service.dart';
import 'features/auth/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Restore persisted language before first frame
  await LanguageService.instance.init();
  runApp(const DisasterDssApp());
}

class DisasterDssApp extends StatelessWidget {
  const DisasterDssApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LanguageService.instance.currentLanguage,
      builder: (context, language, _) {
        return MaterialApp(
          title: 'Disaster DSS',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          locale: LanguageService.instance.locale,
          builder: (context, child) {
            return Directionality(
              textDirection: LanguageService.instance.isRtl
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: KeyedSubtree(
                key: ValueKey(language),
                child: child ?? const SizedBox.shrink(),
              ),
            );
          },
          home: const SplashScreen(),
        );
      },
    );
  }
}
