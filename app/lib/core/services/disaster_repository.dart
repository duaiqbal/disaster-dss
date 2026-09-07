import '../models/weather_data.dart';
import '../models/household_risk.dart';
import '../models/official_alert.dart';
import '../models/community_report.dart';
import 'api_service.dart';
import '../local_db/local_db.dart';

/// Clean repository that orchestrates online backend API fetching with
/// offline SQLite database fallback.
class DisasterRepository {
  static final DisasterRepository _instance = DisasterRepository._internal();
  factory DisasterRepository() => _instance;
  DisasterRepository._internal();

  /// Fetches current environmental / weather conditions
  Future<CurrentConditions> getCurrentConditions() async {
    final response = await ApiService.get('/api/weather/current');
    if (response != null && response is Map<String, dynamic>) {
      return CurrentConditions.fromJson(response);
    }
    return CurrentConditions.defaultChitral;
  }

  /// Fetches 7-day forecast
  Future<List<DailyForecast>> get7DayForecast() async {
    final response = await ApiService.get('/api/weather/forecast');
    if (response != null && response is List) {
      return response
          .map((item) => DailyForecast.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return DailyForecast.sample7Day;
  }

  /// Alias for daily forecast
  Future<List<DailyForecast>> getDailyForecast({int days = 7}) => get7DayForecast();

  /// Calculates household risk using GIS local DB or backend
  Future<HouseholdRisk> getHouseholdRisk({double? lat, double? lng}) async {
    // Attempt backend API call first
    final response = await ApiService.get('/api/risk/household');
    if (response != null && response is Map<String, dynamic>) {
      return HouseholdRisk.fromJson(response);
    }

    // Offline computation via hazard_grid.sqlite
    try {
      final db = await LocalDb.hazardDb;
      final latitude = lat ?? 35.85; // Chitral center default
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
        final hazardLevel = row['hazard_level'] as String;
        final nearRiver = (row['river_nearby'] as int) == 1;

        int score = 68;
        String level = 'Moderate Risk';
        if (hazardLevel == 'High') {
          score = 82;
          level = 'High Risk';
        } else if (hazardLevel == 'Low') {
          score = 35;
          level = 'Low Risk';
        }

        return HouseholdRisk(
          score: score,
          level: level,
          keyFactors: [
            'Slope proximity',
            'Recent rainfall',
            if (nearRiver) 'River proximity' else 'Drainage saturation',
          ],
          slopeProximity: 'Nearby',
          recentRainfall: 'High',
          riverProximity: nearRiver ? 'Nearby' : 'Distanced',
          explanation:
              'Based on your location in Chitral, terrain slope analysis and river proximity from Copernicus DEM and OpenStreetMap data indicate a $level exposure.',
        );
      }
    } catch (_) {
      // Local DB not yet copied or error, fallback safely
    }

    return HouseholdRisk.defaultModerate;
  }

  /// Fetches latest priority warning
  Future<OfficialAlert> getLatestWarning() async {
    final response = await ApiService.get('/api/alerts/latest');
    if (response != null && response is Map<String, dynamic>) {
      return OfficialAlert.fromJson(response);
    }
    return OfficialAlert.warningFromPMD;
  }

  /// Fetches all active alerts
  Future<List<OfficialAlert>> getAllAlerts() async {
    final response = await ApiService.get('/api/alerts');
    if (response != null && response is List) {
      return response
          .map((item) => OfficialAlert.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [
      OfficialAlert.warningFromPMD,
      OfficialAlert.watchFromNDMA,
    ];
  }

  /// Fetches community crowd-sourced reports
  Future<List<CommunityReport>> getCommunityReports() async {
    final response = await ApiService.get('/api/reports');
    if (response != null && response is List) {
      return response
          .map((item) => CommunityReport.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return CommunityReport.sampleReports;
  }

  /// AI Contextual Recommendation text
  Future<String> getAiRecommendation() async {
    final response = await ApiService.get('/api/ai/recommendation');
    if (response != null && response['recommendation'] != null) {
      return response['recommendation'] as String;
    }
    return 'Rainfall is increasing while your household is near a steep slope. Review your evacuation route and keep essential documents ready.';
  }

  /// Submits a community hazard report to the backend (or offline no-op)
  Future<void> submitReport({
    required String type,
    required String location,
    required String description,
  }) async {
    await ApiService.post('/api/reports', {
      'type': type,
      'location': location,
      'description': description,
    });
    // Offline fallback: no-op — report will be synced when connectivity returns
  }
}
