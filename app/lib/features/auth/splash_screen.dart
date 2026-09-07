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
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();

    // 3.5s splash display duration gives user time to see the screen and animation
    Future.delayed(const Duration(milliseconds: 3500), _navigateToNext);
  }

  void _navigateToNext() {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, animation, __) => const LanguageSelectionScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToNext,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FA),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const Spacer(flex: 3),
                        FadeTransition(
                          opacity: _fade,
                          child: ScaleTransition(
                            scale: _scale,
                            child: Container(
                              width: 104,
                              height: 104,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(26),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomPaint(
                                      size: const Size(34, 42),
                                      painter: _ContourPinPainter(),
                                    ),
                                    const SizedBox(width: 5),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Climate',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF007A87),
                                            height: 1.1,
                                          ),
                                        ),
                                        Text(
                                          'Risk',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF007A87),
                                            height: 1.1,
                                          ),
                                        ),
                                        Text(
                                          'Assistant',
                                          style: TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF007A87),
                                            height: 1.1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        FadeTransition(
                          opacity: _fade,
                          child: const Text(
                            'Climate Risk Assistant',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FadeTransition(
                          opacity: _fade,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              'Explainable AI for climate hazard risk and preparedness',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 15,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(flex: 4),
                        const _PulsingLoadingBar(),
                        const SizedBox(height: 14),
                        const Text(
                          'LOADING ENVIRONMENT DATA',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 1.5,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ContourPinPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const teal = Color(0xFF007A87);
    final strokePaint = Paint()
      ..color = teal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    final fillPaint = Paint()
      ..color = teal
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height * 0.38);
    final r = size.width * 0.44;

    // Outer pin outline
    final path = Path();
    path.moveTo(center.dx - r, center.dy);
    path.arcTo(
      Rect.fromCircle(center: center, radius: r),
      3.14159,
      3.14159,
      false,
    );
    path.cubicTo(
      center.dx + r, center.dy + r * 0.7,
      center.dx + r * 0.4, size.height * 0.78,
      center.dx, size.height,
    );
    path.cubicTo(
      center.dx - r * 0.4, size.height * 0.78,
      center.dx - r, center.dy + r * 0.7,
      center.dx - r, center.dy,
    );
    path.close();
    canvas.drawPath(path, strokePaint);

    // Inner contour 1
    final innerPath1 = Path();
    final r1 = r * 0.65;
    innerPath1.addOval(Rect.fromCenter(center: center, width: r1 * 2, height: r1 * 2.2));
    canvas.drawPath(innerPath1, strokePaint..strokeWidth = 1.2);

    // Inner contour 2
    final innerPath2 = Path();
    final r2 = r * 0.35;
    innerPath2.addOval(Rect.fromCenter(center: center, width: r2 * 2, height: r2 * 2));
    canvas.drawPath(innerPath2, strokePaint..strokeWidth = 1.0);

    // Center star point
    canvas.drawCircle(center, 2.0, fillPaint);
  }

  @override
  bool shouldRepaint(_ContourPinPainter old) => false;
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