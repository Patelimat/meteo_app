import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<Map<String, dynamic>> fetchWeather(
    double latitude,
    double longitude, {
    String? startDate,
    String? endDate,
  }) async {
    final queryParameters = {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'current_weather': 'true',
      'hourly': 'apparent_temperature,relative_humidity_2m,precipitation,cloud_cover',
      'timezone': 'auto',
    };

    // Ajout de start_date et end_date si fournis
    if (startDate != null) {
      queryParameters['start_date'] = startDate;
    }
    if (endDate != null) {
      queryParameters['end_date'] = endDate;
    }

    final url = Uri.https('api.open-meteo.com', '/v1/forecast', queryParameters);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur lors de la récupération de la météo');
    }
  }
}
