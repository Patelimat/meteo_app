import 'package:flutter/material.dart';
import 'package:meteo_app/widget/appColors.dart';
import 'package:meteo_app/widget/coordinates.dart';
import 'api/weather_service.dart';
import 'mapping/weather.dart';
import 'widget/detailWeather.dart';
import 'widget/hourlyDetail.dart';
import 'widget/timeInterval.dart';
import 'package:meteo_app/widget/backgroundImage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

  Weather? currentWeather;
  Weather? hourlyWeather;
  bool isLoading = true;
  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _latitudeController.text = '48.85';
    _longitudeController.text = '44.35';
    final now = DateTime.now();
    _startDate = now;
    _endDate = now.add(const Duration(days: 1));
    _getCurrentWeather();
    _getHourlyWeather();
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentWeather() async {
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
      // Appel sans les dates pour obtenir la météo actuelle
      final data = await weatherService.fetchWeather(latitude, longitude);
      setState(() {
        currentWeather = Weather.fromJson(data);
        isLoading = false;
      });
    } catch (e) {
      setState(() { isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la récupération de la météo actuelle.')),
      );
    }
  }
  
  Future<void> _getHourlyWeather() async {
    final latitude = double.tryParse(_latitudeController.text);
    final longitude = double.tryParse(_longitudeController.text);
    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer des coordonnées valides.')),
      );
      return;
    }
    setState(() { isLoading = true; });
    try {
      // Appel en passant les dates pour obtenir les prévisions horaires
      final data = await weatherService.fetchWeather(
        latitude,
        longitude,
        startDate: TimeInterval.formatDate(_startDate),
        endDate: TimeInterval.formatDate(_endDate),
      );
      setState(() {
        hourlyWeather = Weather.fromJson(data);
        isLoading = false;
      });
    } catch (e) {
      setState(() { isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de la récupération des prévisions horaires.')),
      );
    }
  }
  
  Future<void> loadWeather() async {
    try {
      
      final data = await weatherService.fetchWeather(48.85, 44.35);
      setState(() {
        currentWeather = Weather.fromJson(data);
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

  String getBackgroundImage(Weather weather) {
    if (weather.precipitation > 0) return 'rainy.jpg';
    if (weather.couvertureNuageuse > 50) return 'cloudy.jpg';
    return 'sunny.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (currentWeather != null)
            BackgroundImage(imagePath: getBackgroundImage(currentWeather!)),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : currentWeather != null
                  ? LayoutBuilder(
                      builder: (context, constraints) {
                        // Si largeur > 800px : 30% de marge, sinon 5%
                        double widthFactor = constraints.maxWidth > 1024 ? 0.4 : 0.9;
                        return Center(
                          child: FractionallySizedBox(
                            widthFactor: widthFactor,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(0, 80.0, 0, 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 45.0),
                                    child: Text(
                                      '${currentWeather!.temperature}°C',
                                      style: const TextStyle(
                                        fontSize: 100,
                                        height: 1,
                                        color: AppColors.text,
                                      ),
                                    ),
                                  ),
                                  Detailweather(
                                    temperatureResentie: currentWeather!.temperatureResentie,
                                    humidite: currentWeather!.humidite,
                                    vent: currentWeather!.vent,
                                    precipitation: currentWeather!.precipitation,
                                    couvertureNuageuse: currentWeather!.couvertureNuageuse,
                                  ),
                                  const SizedBox(height: 20),
                                  Coordinates(
                                    latitudeController: _latitudeController,
                                    longitudeController: _longitudeController,
                                    onGetWeather: _getCurrentWeather,
                                  ),
                                  const SizedBox(height: 20),
                                  if (hourlyWeather != null && hourlyWeather!.hourlyTimes.isNotEmpty)
                                    HourlyDetail(
                                      hourlyTimes: hourlyWeather!.hourlyTimes,
                                      hourlyApparentTemperature: hourlyWeather!.hourlyApparentTemperature,
                                      hourlyHumidity: hourlyWeather!.hourlyHumidity,
                                      hourlyPrecipitation: hourlyWeather!.hourlyPrecipitation,
                                      hourlyCloudCover: hourlyWeather!.hourlyCloudCover,
                                      onGetHourlyWeather: _getHourlyWeather,
                                      initialStartDate: _startDate,
                                      initialEndDate: _endDate,
                                      onDateRangeChanged: (start, end) {
                                        setState(() {
                                          _startDate = start;
                                          _endDate = end;
                                        });
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'Erreur lors du chargement des données',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
        ],
      ),
    );
  }
}

