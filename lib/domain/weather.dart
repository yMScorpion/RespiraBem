class Weather {
  final double temperature;
  final double windSpeed;
  final String weatherCode;
  final String city;
  
  Weather({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
    required this.city,
  });
  
  factory Weather.fromJson(Map<String, dynamic> json, String city) {
    final current = json['current'] ?? {};
    return Weather(
      temperature: (current['temperature_2m'] ?? 0).toDouble(),
      windSpeed: (current['wind_speed_10m'] ?? 0).toDouble(),
      weatherCode: (current['weather_code'] ?? 0).toString(),
      city: city,
    );
  }
  
  String get weatherDescription {
    switch (weatherCode) {
      case '0':
        return 'Céu limpo';
      case '1':
      case '2':
      case '3':
        return 'Parcialmente nublado';
      case '45':
      case '48':
        return 'Nevoeiro';
      case '51':
      case '53':
      case '55':
        return 'Chuvisco';
      case '61':
      case '63':
      case '65':
        return 'Chuva';
      case '71':
      case '73':
      case '75':
        return 'Neve';
      case '80':
      case '81':
      case '82':
        return 'Pancadas de chuva';
      case '95':
        return 'Tempestade';
      default:
        return 'Desconhecido';
    }
  }
}