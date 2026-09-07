class CommunityReport {
  final String id;
  final String title;
  final String area;
  final int reportCount;
  final String reportedTimeAgo;
  final String status;
  final String type; // blockage, water, slope, etc.

  const CommunityReport({
    required this.id,
    required this.title,
    required this.area,
    required this.reportCount,
    required this.reportedTimeAgo,
    this.status = 'Active',
    required this.type,
  });

  factory CommunityReport.fromJson(Map<String, dynamic> json) {
    return CommunityReport(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Road blockage reported',
      area: json['area'] as String? ?? 'Chitral',
      reportCount: json['report_count'] as int? ?? 5,
      reportedTimeAgo: json['reported_time_ago'] as String? ?? 'Reported recently',
      status: json['status'] as String? ?? 'Active',
      type: json['type'] as String? ?? 'blockage',
    );
  }

  static const List<CommunityReport> sampleReports = [
    CommunityReport(
      id: 'rep_01',
      title: 'Road blockage reported',
      area: 'Area: Chitral',
      reportCount: 5,
      reportedTimeAgo: 'Reported recently',
      type: 'blockage',
    ),
    CommunityReport(
      id: 'rep_02',
      title: 'Water shortage reported',
      area: 'Area: Nearby settlement',
      reportCount: 4,
      reportedTimeAgo: 'Active',
      type: 'water',
    ),
  ];
}
