import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  
  Future<Map<String, dynamic>> fetchWeather(double latitude, double longitude) async {
    final url = Uri.parse(
  'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true&hourly=apparent_temperature,relative_humidity_2m,precipitation,cloud_cover',
);


    

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur lors de la récupération de la météo');
    }
  }
  
}
