class Weather {
  final double temperature;
  final double temperatureResentie;
  final double humidite;
  final double windspeed;
  final double precipitation;
  final double couvertureNuageuse;

  // Nouveaux champs pour les données horaires
  final List<String> hourlyTimes;
  final List<double> hourlyApparentTemperature;
  final List<double> hourlyHumidity;
  final List<double> hourlyPrecipitation;
  final List<double> hourlyCloudCover;

  Weather({
    required this.temperature,
    required this.temperatureResentie,
    required this.humidite,
    required this.windspeed,
    required this.precipitation,
    required this.couvertureNuageuse,
    required this.hourlyTimes,
    required this.hourlyApparentTemperature,
    required this.hourlyHumidity,
    required this.hourlyPrecipitation,
    required this.hourlyCloudCover,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = json['current_weather'];
    final hourly = json['hourly'];

    List<String> times = List<String>.from(hourly['time']);
    List<double> apparentTemps = List<double>.from(
        hourly['apparent_temperature'].map((e) => (e as num).toDouble()));
    List<double> humidities = List<double>.from(
        hourly['relative_humidity_2m'].map((e) => (e as num).toDouble()));
    List<double> precipitations = List<double>.from(
        hourly['precipitation'].map((e) => (e as num).toDouble()));
    List<double> cloudCovers = List<double>.from(
        hourly['cloud_cover'].map((e) => (e as num).toDouble()));

    // Pour le "current" on prend la première valeur de chaque liste (pour simplifier)
    double temperatureResentie = apparentTemps.isNotEmpty ? apparentTemps.first : 0.0;
    double precipitationCurrent = precipitations.isNotEmpty ? precipitations.first : 0.0;
    double couvertureNuageuseCurrent = cloudCovers.isNotEmpty ? cloudCovers.first : 0.0;
    double humiditeCurrent = humidities.isNotEmpty ? humidities.first : 0.0;

    return Weather(
      temperature: (current['temperature'] as num).toDouble(),
      temperatureResentie: temperatureResentie,
      humidite: humiditeCurrent,
      windspeed: (current['windspeed'] as num).toDouble(),
      precipitation: precipitationCurrent,
      couvertureNuageuse: couvertureNuageuseCurrent,
      hourlyTimes: times,
      hourlyApparentTemperature: apparentTemps,
      hourlyHumidity: humidities,
      hourlyPrecipitation: precipitations,
      hourlyCloudCover: cloudCovers,
    );
  }
}
