class CurrentConditions {
  final int temperature;
  final String condition;
  final int humidity;
  final int windSpeedKmh;
  final int rainProbPercent;
  final int feelsLike;

  const CurrentConditions({
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeedKmh,
    required this.rainProbPercent,
    this.feelsLike = 25,
  });

  factory CurrentConditions.fromJson(Map<String, dynamic> json) {
    return CurrentConditions(
      temperature: json['temperature'] as int? ?? 24,
      condition: json['condition'] as String? ?? 'Partly cloudy',
      humidity: json['humidity'] as int? ?? 65,
      windSpeedKmh: json['wind_speed_kmh'] as int? ?? 12,
      rainProbPercent: json['rain_prob_percent'] as int? ?? 15,
      feelsLike: json['feels_like'] as int? ?? 25,
    );
  }

  static const CurrentConditions defaultChitral = CurrentConditions(
    temperature: 24,
    condition: 'Partly cloudy',
    humidity: 65,
    windSpeedKmh: 12,
    rainProbPercent: 15,
    feelsLike: 25,
  );

  int get tempC => temperature;
  int get humidityPercent => humidity;
  int get windKph => windSpeedKmh;
  int get rainProbabilityPercent => rainProbPercent;
}

class DailyForecast {
  final String dayName;
  final int temp;
  final int? lowTemp;
  final int rainProbPercent;
  final String condition;

  const DailyForecast({
    required this.dayName,
    required this.temp,
    this.lowTemp,
    required this.rainProbPercent,
    required this.condition,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      dayName: json['day'] as String? ?? 'Mon',
      temp: json['temp'] as int? ?? 22,
      lowTemp: json['low_temp'] as int?,
      rainProbPercent: json['rain_prob'] as int? ?? 40,
      condition: json['condition'] as String? ?? 'Rain',
    );
  }

  static const List<DailyForecast> sample7Day = [
    DailyForecast(dayName: 'Mon', temp: 22, lowTemp: 18, rainProbPercent: 40, condition: 'Cloudy'),
    DailyForecast(dayName: 'Tue', temp: 20, lowTemp: 16, rainProbPercent: 80, condition: 'Rain'),
    DailyForecast(dayName: 'Wed', temp: 19, lowTemp: 15, rainProbPercent: 90, condition: 'Heavy Rain'),
    DailyForecast(dayName: 'Thu', temp: 23, lowTemp: 16, rainProbPercent: 10, condition: 'Partly Cloudy'),
    DailyForecast(dayName: 'Fri', temp: 28, lowTemp: 18, rainProbPercent: 0, condition: 'Sunny'),
    DailyForecast(dayName: 'Sat', temp: 29, lowTemp: 19, rainProbPercent: 0, condition: 'Sunny'),
    DailyForecast(dayName: 'Sun', temp: 27, lowTemp: 18, rainProbPercent: 5, condition: 'Clear'),
  ];

  int get rainProbabilityPercent => rainProbPercent;
  int get highTempC => temp;
  int get lowTempC => lowTemp ?? (temp - 4);
  String get conditionIcon {
    final c = condition.toLowerCase();
    if (c.contains('sun') || c.contains('clear')) return '☀️';
    if (c.contains('rain')) return '🌧';
    if (c.contains('partly')) return '🌤';
    if (c.contains('cloud')) return '☁️';
    return '⛅';
  }
}
