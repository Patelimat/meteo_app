class Weather {
  final double temperature;
  final double temperatureResentie;
  final double humidite;
  final double windspeed;
  final double precipitation;
  final double couvertureNuageuse;

  Weather({required this.temperature, required this.temperatureResentie,required this.humidite , required this.windspeed, required this.precipitation, required this.couvertureNuageuse});

  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = json['current_weather'];
    final hourly = json['hourly'];
    
    // Récupération de la date/heure actuelle (format compatible API)
    final now = DateTime.now().toUtc().toIso8601String().substring(0, 13); // Ex: "2025-06-13T10"

    // Trouver l'index de l'heure actuelle dans la liste
    final timeList = List<String>.from(hourly['time']);
    final apparentTempList = List<double>.from(hourly['apparent_temperature'].map((e) => e.toDouble()));
    final precipitationList = List<double>.from(hourly['precipitation'].map((e) => e.toDouble()));
    final cloudCoverList = List<double>.from(hourly['cloud_cover'].map((e) => e.toDouble()));

    int index = timeList.indexWhere((time) => time.startsWith(now));
    double apparentTemperature = index != -1 ? apparentTempList[index] : 0.0;
    double precipitation = index != -1 ? precipitationList[index] : 0.0;
    double cloudCover = index != -1 ? cloudCoverList[index] : 0.0;    

    return Weather(
      temperature: current['temperature'].toDouble(),
      temperatureResentie: apparentTemperature,
      humidite: hourly['relative_humidity_2m'][index].toDouble(),
      windspeed: current['windspeed'].toDouble(),
      precipitation: precipitation,
      couvertureNuageuse: cloudCover,
    );
  }
}
