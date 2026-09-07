// Interactive Hazard Map screen — matches Interactive Hazard Map.png Figma design.
// No live mapping SDK (none declared in pubspec). Uses a terrain-image placeholder
// with filter chips, zoom controls, a location pin overlay, and a draggable
// bottom sheet showing the nearest-grid hazard data from hazard_grid.sqlite.
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/local_db/local_db.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../chat/chat_screen.dart';
import '../safety/safety_hub_screen.dart';

class _HazardInfo {
  final String hazardLevel;
  final double slope;
  final bool riverNearby;

  _HazardInfo({
    required this.hazardLevel,
    required this.slope,
    required this.riverNearby,
  });

  static _HazardInfo get defaultChitral => _HazardInfo(
        hazardLevel: 'High',
        slope: 38.5,
        riverNearby: false,
      );
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<String> _filterChips = [
    'Landslide',
    'Flood',
    'Rainfall',
    'Terrain',
  ];
  String _activeFilter = 'Landslide';
  _HazardInfo? _hazardInfo;
  bool _loading = false;
  bool _bottomSheetVisible = true;
  double _zoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    _loadHazardData();
  }

  Future<void> _loadHazardData({double? lat, double? lng}) async {
    setState(() => _loading = true);
    try {
      final db = await LocalDb.hazardDb;
      final latitude = lat ?? 35.85;
      final longitude = lng ?? 71.78;

      final rows = await db.rawQuery('''
        SELECT hazard_level, mean_slope_degrees, river_nearby,
               ((latitude - ?) * (latitude - ?) + (longitude - ?) * (longitude - ?)) AS dist
        FROM hazard_grid
        ORDER BY dist ASC
        LIMIT 1
      ''', [latitude, latitude, longitude, longitude]);

      if (rows.isNotEmpty) {
        final row = rows.first;
        setState(() {
          _hazardInfo = _HazardInfo(
            hazardLevel: row['hazard_level'] as String,
            slope: (row['mean_slope_degrees'] as num).toDouble(),
            riverNearby: (row['river_nearby'] as int) == 1,
          );
        });
      } else {
        setState(() => _hazardInfo = _HazardInfo.defaultChitral);
      }
    } catch (_) {
      setState(() => _hazardInfo = _HazardInfo.defaultChitral);
    }
    setState(() => _loading = false);
  }

  Future<void> _locateMe() async {
    setState(() => _loading = true);
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => _loading = false);
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      await _loadHazardData(lat: pos.latitude, lng: pos.longitude);
      setState(() => _bottomSheetVisible = true);
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  String get _hazardLabel {
    return 'High Landslide Risk Zone';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Map placeholder ──────────────────────────────────────────────
          _buildMapPlaceholder(),

          // ── App bar overlay ──────────────────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                _buildMapAppBar(),
                const SizedBox(height: 8),
                _buildFilterChips(),
              ],
            ),
          ),

          // ── Zoom controls ────────────────────────────────────────────────
          Positioned(
            right: 12,
            top: 160,
            child: _buildZoomControls(),
          ),

          // ── Locate me button ─────────────────────────────────────────────
          Positioned(
            right: 12,
            top: 230,
            child: _buildLocateButton(),
          ),

          // ── Risk pin overlay ─────────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            top: 230,
            child: Center(child: _buildRiskPin()),
          ),

          // ── Bottom info sheet ────────────────────────────────────────────
          if (_bottomSheetVisible)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomInfoSheet(),
            ),

          // ── Loading overlay ──────────────────────────────────────────────
          if (_loading)
            Container(
              color: Colors.black.withValues(alpha: 0.25),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }

  // ── Map placeholder (terrain aesthetic) ──────────────────────────────────
  Widget _buildMapPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF8B9B6A), // olive highland
            Color(0xFF6B7A50),
            Color(0xFF5A6B45),
            Color(0xFF4A5A38),
          ],
        ),
      ),
      child: CustomPaint(
        painter: _TerrainPainter(),
      ),
    );
  }

  // ── App bar overlaid on map ───────────────────────────────────────────────
  Widget _buildMapAppBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybeOf(context)?.pop(),
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chitral, Pakistan',
                  style: AppTextStyles.cardTitle.copyWith(
                    color: AppColors.primary,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Hazard Map',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.search, color: AppColors.textSecondary, size: 22),
        ],
      ),
    );
  }

  // ── Filter chips ──────────────────────────────────────────────────────────
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: _filterChips.map((chip) {
          final isActive = chip == _activeFilter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _activeFilter = chip),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? AppColors.primary : AppColors.border,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _filterIcon(chip),
                      size: 14,
                      color: isActive ? Colors.white : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      chip,
                      style: AppTextStyles.caption.copyWith(
                        color: isActive
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _filterIcon(String chip) {
    switch (chip) {
      case 'Landslide':
        return Icons.landscape;
      case 'Flood':
        return Icons.water;
      case 'Rainfall':
        return Icons.water_drop_outlined;
      case 'Terrain':
        return Icons.terrain;
      default:
        return Icons.layers_outlined;
    }
  }

  // ── Zoom controls ─────────────────────────────────────────────────────────
  Widget _buildZoomControls() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _zoomButton(Icons.add, () {
            setState(() => _zoomLevel = (_zoomLevel + 0.25).clamp(0.5, 3.0));
          }),
          Container(height: 1, color: AppColors.border),
          _zoomButton(Icons.remove, () {
            setState(() => _zoomLevel = (_zoomLevel - 0.25).clamp(0.5, 3.0));
          }),
        ],
      ),
    );
  }

  Widget _zoomButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: Icon(icon, size: 20, color: AppColors.textPrimary),
      ),
    );
  }

  // ── Locate me button ──────────────────────────────────────────────────────
  Widget _buildLocateButton() {
    return GestureDetector(
      onTap: _locateMe,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.my_location,
          size: 20,
          color: AppColors.primary,
        ),
      ),
    );
  }

  // ── Risk pin on map ───────────────────────────────────────────────────────
  Widget _buildRiskPin() {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.riskHigh,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.riskHigh.withValues(alpha: 0.4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.warning_amber_rounded,
              color: Colors.white, size: 22),
        ),
        CustomPaint(
          size: const Size(12, 10),
          painter: _PinTailPainter(color: AppColors.riskHigh),
        ),
      ],
    );
  }

  // ── Bottom info sheet ─────────────────────────────────────────────────────
  Widget _buildBottomInfoSheet() {
    final info = _hazardInfo ?? _HazardInfo.defaultChitral;
    final level = info.hazardLevel;
    final isHigh = level == 'High';

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 16),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isHigh
                            ? AppColors.riskHighBg
                            : AppColors.riskModerateBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${level.toUpperCase()} RISK',
                        style: AppTextStyles.caption.copyWith(
                          color: isHigh
                              ? AppColors.riskHigh
                              : AppColors.riskModerate,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.remove_red_eye_outlined,
                        size: 13, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      'Moderate Confidence',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(() => _bottomSheetVisible = false),
                      child: const Icon(Icons.close,
                          size: 18, color: AppColors.textMuted),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  _hazardLabel,
                  style: AppTextStyles.screenHeader.copyWith(fontSize: 22),
                ),

                const SizedBox(height: 14),

                // Why flagged card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Why this area is flagged',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _flagReason(
                        icon: Icons.landscape,
                        text:
                            'Steep terrain (gradient > ${info.slope.toStringAsFixed(0)}°)',
                      ),
                      _flagReason(
                        icon: Icons.water_drop_outlined,
                        text: 'Heavy rainfall saturation over past 72h',
                      ),
                      _flagReason(
                        icon: Icons.waves,
                        text: info.riverNearby
                            ? 'Proximity to river channel'
                            : 'Proximity to compromised natural drainage',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Sources
                Row(
                  children: [
                    Text(
                      'Sources: ',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    _sourceTag('SRTM DEM'),
                    const SizedBox(width: 6),
                    _sourceTag('PMD Data'),
                  ],
                ),

                const SizedBox(height: 16),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _showRiskFactorSheet(context),
                        child: const Text('View risk factors'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChatScreen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.smart_toy_outlined,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRiskFactorSheet(BuildContext context) {
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
                  'High Landslide Risk Zone',
                  style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textMuted),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Text(
              'Current risk factors for this area.',
              style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.aiCardBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.aiCardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.insert_chart_outlined, size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        'Key Indicators',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _indicatorBox('Landslide Risk', 'High', AppColors.riskHigh)),
                      const SizedBox(width: 8),
                      Expanded(child: _indicatorBox('Rainfall', 'Heavy', AppColors.textPrimary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _indicatorBox('Slope Stability', 'Low', AppColors.riskHigh)),
                      const SizedBox(width: 8),
                      Expanded(child: _indicatorBox('Road Access', 'At Risk', AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        'Why this area is at risk',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Heavy rainfall can increase soil saturation and slope instability. Roads near steep terrain may become difficult to access.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.shield_outlined, size: 16, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        'What to do',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('• Avoid unstable slopes.', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text('• Monitor official alerts.', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text('• Keep evacuation routes ready.', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                ],
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
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.close, size: 16),
                label: const Text('Close'),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  static Widget _indicatorBox(String title, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.caption.copyWith(fontSize: 11, color: AppColors.textMuted)),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.cardTitle.copyWith(fontSize: 14, color: valueColor)),
        ],
      ),
    );
  }

  Widget _flagReason({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sourceTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Custom painters ────────────────────────────────────────────────────────

class _TerrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw simple terrain contour lines
    paint.color = Colors.white.withValues(alpha: 0.06);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.0;

    for (int i = 0; i < 8; i++) {
      final path = Path();
      final y = size.height * (0.1 + i * 0.1);
      path.moveTo(0, y + 20 * (i % 3 == 0 ? 1 : -1));
      path.cubicTo(
        size.width * 0.25, y - 30 * (i % 2 == 0 ? 1 : -0.5),
        size.width * 0.5, y + 20 * (i % 3 == 1 ? 1 : -1),
        size.width * 0.75, y - 10,
      );
      path.lineTo(size.width, y + 15 * (i % 2));
      canvas.drawPath(path, paint);
    }

    // Red highlight zone
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFFDC2626).withValues(alpha: 0.15);
    final zone = Path();
    zone.addOval(Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.45),
      width: 100,
      height: 80,
    ));
    canvas.drawPath(zone, paint);
  }

  @override
  bool shouldRepaint(_TerrainPainter oldDelegate) => false;
}

class _PinTailPainter extends CustomPainter {
  final Color color;
  const _PinTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_PinTailPainter oldDelegate) => false;
}
