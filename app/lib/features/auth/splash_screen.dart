import 'package:flutter/material.dart';
import 'language_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (_, animation, __) => const LanguageSelectionScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 3),
            FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.shield_outlined, color: Colors.teal, size: 36),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _fade,
              child: const Text(
                'Climate Risk Assistant',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            FadeTransition(
              opacity: _fade,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  'Explainable AI for climate hazard risk and preparedness',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
            const Spacer(flex: 4),
            const _PulsingLoadingBar(),
            const SizedBox(height: 12),
            const Text(
              'LOADING ENVIRONMENT DATA',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 1,
                color: Colors.black45,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _PulsingLoadingBar extends StatefulWidget {
  const _PulsingLoadingBar();

  @override
  State<_PulsingLoadingBar> createState() => _PulsingLoadingBarState();
}

class _PulsingLoadingBarState extends State<_PulsingLoadingBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 3,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Container(color: Colors.black12),
                Align(
                  alignment: Alignment(-1 + 2 * _controller.value, 0),
                  child: FractionallySizedBox(
                    widthFactor: 0.4,
                    child: Container(color: Colors.teal[700]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}