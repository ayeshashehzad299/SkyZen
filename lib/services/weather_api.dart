import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherApi {
  static const String _apiKey = '512b6a50376f65f238058a03381db9a3';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  static Future<Weather> fetchWeather(String city) async {
    final url = '$_baseUrl?q=$city&units=metric&appid=$_apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return Weather.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
