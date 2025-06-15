import 'package:flutter/material.dart';
import 'weather_service.dart';
import 'weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: WeatherPage(),
    );
  }
}



class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService weatherService = WeatherService();
  Weather? weather;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Future<void> loadWeather() async {
    try {
      final data = await weatherService.fetchWeather(48.85, 44.35); // Exemple: Paris
      setState(() {
        weather = Weather.fromJson(data);
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Météo actuelle')),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : weather != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Température : ${weather!.temperature}°C'),
                      Text('Température ressentie : ${weather!.temperatureResentie}°C'),
                      Text('Humidité : ${weather!.humidite}%'),
                      Text('Vitesse du vent : ${weather!.windspeed} km/h'),
                      Text('Précipitations : ${weather!.precipitation} mm'),
                      Text('Couverture nuageuse : ${weather!.couvertureNuageuse}%'),
                    ],
                  )
                : Text('Erreur lors du chargement des données'),
      ),
    );
  }
}

