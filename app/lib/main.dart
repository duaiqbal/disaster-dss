// UNVERIFIED DRAFT — not run/tested against a real Flutter build.

import 'package:flutter/material.dart';
import 'features/chat/chat_screen.dart';
import 'features/map/map_screen.dart';
import 'features/auth/splash_screen.dart';

void main() {
  runApp(const DisasterDssApp());
}

class DisasterDssApp extends StatelessWidget {
  const DisasterDssApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disaster DSS',
      theme: ThemeData(primarySwatch: Colors.blue),
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
