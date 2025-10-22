import 'package:http/http.dart' as http;
import 'dart:convert';
import '../domain/weather.dart';

class WeatherApi {
  final String baseUrl = 'https://api.open-meteo.com/v1/forecast';

  // Coordenadas de Maceió, AL
  final double latitude = -9.6658;
  final double longitude = -35.7353;

  Future<Weather> getCurrentWeather() async {
    try {
      final url = Uri.parse(
          '$baseUrl?latitude=$latitude&longitude=$longitude&current=temperature_2m,wind_speed_10m,weather_code');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Weather.fromJson(data, 'Maceió');
      } else {
        throw Exception('Falha ao carregar dados do clima');
      }
    } catch (e) {
      throw Exception('Erro ao buscar clima: $e');
    }
  }

  Future<Weather> getWeatherByCoordinates(
      double lat, double lon, String city) async {
    try {
      final url = Uri.parse(
          '$baseUrl?latitude=$lat&longitude=$lon&current=temperature_2m,wind_speed_10m,weather_code');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Weather.fromJson(data, city);
      } else {
        throw Exception('Falha ao carregar dados do clima');
      }
    } catch (e) {
      throw Exception('Erro ao buscar clima: $e');
    }
  }
}
