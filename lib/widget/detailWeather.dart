import 'package:flutter/material.dart';
import 'appcolors.dart';

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
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.box,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(label, style: TextStyle(color: AppColors.textSecondaire, fontSize: 16, fontWeight: FontWeight.w600)),
          Text(value, style: TextStyle(color: AppColors.text, fontSize: 16)),
        ],
      ),
    );
  }
}
