import 'package:flutter/material.dart';
import 'package:meteo_app/widget/coordinates.dart';
import 'api/weather_service.dart';
import 'mapping/weather.dart';
import 'widget/detailWeather.dart';
import 'widget/hourlyDetail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Api Météo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService weatherService = WeatherService();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  Weather? weather;
  bool isLoading = true;
  DateTime? _startDate;
  DateTime? _endDate;

  String formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  void initState() {
    super.initState();
    loadWeather();
  }
  
  Future<void> _getWeather() async {
    final latitude = double.tryParse(_latitudeController.text);
    final longitude = double.tryParse(_longitudeController.text);
    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer des coordonnées valides.')),
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      final data = await weatherService.fetchWeather(
        latitude,
        longitude,
        startDate: _startDate != null ? formatDate(_startDate!) : null,
        endDate: _endDate != null ? formatDate(_endDate!) : null,
      );
      setState(() {
        weather = Weather.fromJson(data);
        isLoading = false;
      });
    } catch (e) {
      print('Erreur : $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la récupération des données météo.')),
      );
    }
  }

  Future<void> loadWeather() async {
    try {
      // Exemple: Paris
      final data = await weatherService.fetchWeather(48.85, 44.35);
      setState(() {
        weather = Weather.fromJson(data);
        isLoading = false;
      });
      // Mise à jour des controllers avec les coordonnées par défaut
      _latitudeController.text = '48.85';
      _longitudeController.text = '44.35';
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _selectDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  // Returns a background image path based on weather conditions.
  String getBackgroundImage() {
    if (weather == null) return 'sunny.jpg';
    if (weather!.precipitation > 0) return 'rainy.jpg';
    if (weather!.couvertureNuageuse > 50) return 'cloudy.jpg';
    return 'sunny.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Météo actuelle')),
      body: Stack(
        children: [
          // Background image (make sure to add your assets in pubspec.yaml)
          if (weather != null)
            SizedBox.expand(
              child: Image.asset(
                getBackgroundImage(),
                fit: BoxFit.cover,
              ),
            )
          else
            Container(color: Colors.grey),
          // Foreground content with transparent background
          Container(
            color: Colors.black.withOpacity(0.3),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : weather != null
                    ? SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Temperature & details at the top
                            Text(
                              '${weather!.temperature}°C',
                              style: const TextStyle(fontSize: 100, height: 1, color: Colors.white),
                            ),
                            Detailweather(
                              temperatureResentie: weather!.temperatureResentie,
                              humidite: weather!.humidite,
                              vent: weather!.windspeed,
                              precipitation: weather!.precipitation,
                              couvertureNuageuse: weather!.couvertureNuageuse,
                            ),
                            const SizedBox(height: 20),
                            // Coordinates and get weather button
                            Coordinates(
                              latitudeController: _latitudeController,
                              longitudeController: _longitudeController,
                              onGetWeather: _getWeather,
                            ),
                            const SizedBox(height: 10),
                            // Date selection buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () => _selectDate(isStart: true),
                                  child: Text(_startDate == null
                                      ? 'Date de début'
                                      : 'Start: ${formatDate(_startDate!)}'),
                                ),
                                ElevatedButton(
                                  onPressed: () => _selectDate(isStart: false),
                                  child: Text(_endDate == null
                                      ? 'Date de fin'
                                      : 'End: ${formatDate(_endDate!)}'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Hourly details widget
                            if (weather!.hourlyTimes.isNotEmpty)
                              HourlyDetail(
                                hourlyTimes: weather!.hourlyTimes,
                                hourlyApparentTemperature: weather!.hourlyApparentTemperature,
                                hourlyHumidity: weather!.hourlyHumidity,
                                hourlyPrecipitation: weather!.hourlyPrecipitation,
                                hourlyCloudCover: weather!.hourlyCloudCover,
                              ),
                          ],
                        ),
                      )
                    : const Center(child: Text('Erreur lors du chargement des données', style: TextStyle(color: Colors.white))),
          ),
        ],
      ),
    );
  }
}

