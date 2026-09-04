// GPS -> nearest precomputed hazard_grid cell lookup (offline, no live GIS
// processing on device).
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/local_db/local_db.dart';

class HazardResult {
  final String hazardLevel;
  final List<String> factors;
  HazardResult(this.hazardLevel, this.factors);
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  HazardResult? _result;
  bool _loading = false;
  String? _error;

  Future<void> _checkHazard() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _error = 'Location permission denied';
          _loading = false;
        });
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      final db = await LocalDb.hazardDb;

      // Nearest-cell lookup by simple bounding distance (grid is coarse,
      // so this is sufficient — no need for spatial index at this scale).
      final rows = await db.rawQuery('''
        SELECT hazard_level, mean_slope_degrees, river_nearby,
               ((latitude - ?) * (latitude - ?) + (longitude - ?) * (longitude - ?)) AS dist
        FROM hazard_grid
        ORDER BY dist ASC
        LIMIT 1
      ''', [pos.latitude, pos.latitude, pos.longitude, pos.longitude]);

      if (rows.isEmpty) {
        setState(() {
          _error = 'No hazard grid data available for this location.';
          _loading = false;
        });
        return;
      }

      final row = rows.first;
      final slope = (row['mean_slope_degrees'] as num).toStringAsFixed(1);
      final nearRiver = (row['river_nearby'] as int) == 1;
      final factors = <String>[
        'slope: $slope degrees',
        if (nearRiver) 'near river' else 'not near river',
      ];

      setState(() {
        _result = HazardResult(row['hazard_level'] as String, factors);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Location Hazard Indicator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _loading ? null : _checkHazard,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('Check my location'),
            ),
            const SizedBox(height: 16),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_result != null) ...[
              Text(
                'Hazard indicator: ${_result!.hazardLevel}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Contributing factors:'),
              for (final f in _result!.factors) Text('- $f'),
              const SizedBox(height: 12),
              const Text(
                'This is a hazard INDICATOR based on simple geographic rules, '
                'NOT a validated prediction. Always follow official guidance.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
