class HouseholdRisk {
  final int score;
  final String level;
  final List<String> keyFactors;
  final String slopeProximity;
  final String recentRainfall;
  final String riverProximity;
  final String explanation;

  const HouseholdRisk({
    required this.score,
    required this.level,
    required this.keyFactors,
    required this.slopeProximity,
    required this.recentRainfall,
    required this.riverProximity,
    required this.explanation,
  });

  factory HouseholdRisk.fromJson(Map<String, dynamic> json) {
    return HouseholdRisk(
      score: json['score'] as int? ?? 68,
      level: json['level'] as String? ?? 'Moderate Risk',
      keyFactors: (json['key_factors'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          const ['Slope proximity', 'Recent rainfall', 'River proximity'],
      slopeProximity: json['slope_proximity'] as String? ?? 'Nearby',
      recentRainfall: json['recent_rainfall'] as String? ?? 'High',
      riverProximity: json['river_proximity'] as String? ?? 'Nearby',
      explanation: json['explanation'] as String? ??
          'Your household risk combines your location-based hazard exposure with household characteristics such as construction type, proximity to rivers and slopes, vulnerable members, livestock, and transport access.',
    );
  }

  static const HouseholdRisk defaultModerate = HouseholdRisk(
    score: 68,
    level: 'Moderate Risk',
    keyFactors: [
      'Slope proximity',
      'Recent rainfall',
      'River proximity',
    ],
    slopeProximity: 'Nearby',
    recentRainfall: 'High',
    riverProximity: 'Nearby',
    explanation:
        'Your household risk combines your location-based hazard exposure with household characteristics such as construction type, proximity to rivers and slopes, vulnerable members, livestock, and transport access.',
  );
}
