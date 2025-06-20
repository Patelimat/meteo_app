import 'package:flutter/material.dart';
import 'appColors.dart';

class Coordinates extends StatelessWidget {
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final VoidCallback onGetWeather;

  const Coordinates({
    super.key,
    required this.latitudeController,
    required this.longitudeController,
    required this.onGetWeather,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: latitudeController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.location_on_rounded, color: Colors.blueAccent),
              hintText: 'Latitude',
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: AppColors.shadow),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: AppColors.shadow, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: longitudeController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.location_on_rounded, color: Colors.blueAccent),
              hintText: 'Longitude',
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: AppColors.shadow),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: AppColors.shadow, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: onGetWeather,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              backgroundColor: AppColors.bouton,
            ),
            child: const Text('Obtenir la météo', style: TextStyle(fontSize: 16, color: AppColors.text)),
          ),
        ],
      ),
    );
  }
}
