class OfficialAlert {
  final String id;
  final String title;
  final String sourceOrg;
  final String severity; // High, Moderate, Low
  final String area;
  final String description;
  final String issuedAgo;
  final String? aiRiskAssessment;
  final List<String> whatToDo;

  const OfficialAlert({
    required this.id,
    required this.title,
    required this.sourceOrg,
    required this.severity,
    required this.area,
    required this.description,
    required this.issuedAgo,
    this.aiRiskAssessment,
    this.whatToDo = const [],
  });

  String get source => sourceOrg;

  factory OfficialAlert.fromJson(Map<String, dynamic> json) {
    return OfficialAlert(
      id: json['id'] as String? ?? 'alert_001',
      title: json['title'] as String? ?? 'Heavy Rainfall Advisory',
      sourceOrg: json['source_org'] as String? ?? 'Pakistan Meteorological Department',
      severity: json['severity'] as String? ?? 'High',
      area: json['area'] as String? ?? 'Chitral District',
      description: json['description'] as String? ??
          'Strong monsoon currents are expected to penetrate in upper parts of the country from today.',
      issuedAgo: json['issued_ago'] as String? ?? 'Issued 2 hours ago',
      aiRiskAssessment: json['ai_risk_assessment'] as String? ??
          "Rainfall may increase slope saturation in your household's area. Slope stability index is currently at 42%.",
      whatToDo: (json['what_to_do'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          const [
            'Monitor official updates.',
            'Keep essential documents and medicines ready.',
            'Avoid river channels and unstable slopes.',
            'Keep an evacuation route available.',
            'Move livestock to a safer location if advised.',
          ],
    );
  }

  static const OfficialAlert warningFromPMD = OfficialAlert(
    id: 'pmd_rain_01',
    title: 'Heavy Rainfall Advisory',
    sourceOrg: 'Pakistan Meteorological Department',
    severity: 'High',
    area: 'Chitral District',
    description:
        'Heavy rainfall may increase flash-flood and landslide risk. Strong monsoon currents are expected to penetrate in upper parts of the country.',
    issuedAgo: 'Issued 2 hours ago',
    aiRiskAssessment:
        "Rainfall may increase slope saturation in your household's area. Slope stability index is currently at 42%.",
    whatToDo: [
      'Monitor official updates.',
      'Keep essential documents and medicines ready.',
      'Avoid river channels and unstable slopes.',
      'Keep an evacuation route available.',
      'Move livestock to a safer location if advised.',
    ],
  );

  static const OfficialAlert watchFromNDMA = OfficialAlert(
    id: 'ndma_flood_02',
    title: 'Flash Flood Watch',
    sourceOrg: 'National Disaster Management Authority (NDMA)',
    severity: 'Moderate',
    area: 'Lowlying areas of Chitral',
    description: 'Risk of flash flooding in local nullahs and streams due to expected rainfall.',
    issuedAgo: 'Issued 5 hours ago',
    aiRiskAssessment:
        'Local water levels may rise rapidly. Keep away from river embankments.',
    whatToDo: [
      'Stay away from waterways and low-lying ground.',
      'Prepare emergency go-bag.',
      'Identify nearest high ground shelter.',
    ],
  );
}
