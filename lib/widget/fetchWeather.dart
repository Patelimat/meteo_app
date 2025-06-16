import 'package:flutter/material.dart';

class FetchWeather extends StatelessWidget {

  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  const FetchWeather({
    super.key,
    required this.latitudeController,
    required this.longitudeController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: latitudeController,
          decoration: const InputDecoration(labelText: 'Latitude'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: longitudeController,
          decoration: const InputDecoration(labelText: 'Longitude'),
          keyboardType: TextInputType.number,
        ),
        ElevatedButton(
          onPressed: () {
            // You can implement the weather fetch logic here or lift it up to a StatefulWidget.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Implement weather fetch logic here.')),
            );
          },
          child: const Text('Get Weather'),
        ),
      ],
    );
  }
}