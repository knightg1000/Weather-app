import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/weather.dart';

class WeatherService {
  final String apiKey = '9e9d1479331fc65dfff3fb64abbbb8fa';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchWeather(String city) async {
    final response = await http.get(Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Weather.fromJson(json);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
