import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/chat/chat_screen.dart';
import 'features/map/map_screen.dart';
import 'features/auth/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DisasterDssApp());
}

class DisasterDssApp extends StatelessWidget {
  const DisasterDssApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disaster DSS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Disaster DSS — Chitral/KP')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatScreen()),
              ),
              child: const Text('Ask a question'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MapScreen()),
              ),
              child: const Text('Check my location hazard'),
            ),
          ],
        ),
      ),
    );
  }
}
