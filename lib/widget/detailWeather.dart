import 'package:flutter/material.dart';

class Detailweather extends StatelessWidget {
  final double temperatureResentie;
  final double humidite;
  final double vent;
  final double precipitation;
  final double couvertureNuageuse;

  const Detailweather({
    super.key,
    required this.temperatureResentie,
    required this.humidite,
    required this.vent,
    required this.precipitation,
    required this.couvertureNuageuse,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 300),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(32, 120, 159, 228), // Bleu opaque
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(97, 0, 0, 0),
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWeatherRow('Température ressentie', '${temperatureResentie.toStringAsFixed(1)} °C'),
          _buildWeatherRow('Humidité', '${humidite.toStringAsFixed(0)} %'),
          _buildWeatherRow('Vent', '${vent.toStringAsFixed(1)} km/h'),
          _buildWeatherRow('Précipitations', '${precipitation.toStringAsFixed(1)} mm'),
          _buildWeatherRow('Couverture nuageuse', '${couvertureNuageuse.toStringAsFixed(0)} %'),
        ],
      ),
    );
  }

  Widget _buildWeatherRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
          Text(value, style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}
