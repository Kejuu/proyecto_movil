import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationSelector extends StatefulWidget {
  const LocationSelector({super.key});

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  String selectedLocation = 'Universidad de Medellín, Biblioteca';

  final List<String> locations = [
    'Universidad de Medellín, Biblioteca',
    'Casa',
    'Oficina',
    'Parque El Poblado',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Entregar a',
          style: TextStyle(fontSize: 12, color: Colors.white70),
        ),
        Row(
          children: [
            PopupMenuButton<String>(
              onSelected: (value) {
                setState(() {
                  selectedLocation = value;
                });
              },
              itemBuilder: (context) {
                return locations
                    .map((location) => PopupMenuItem<String>(
                  value: location,
                  child: Text(location),
                ))
                    .toList();
              },
              child: Row(
                children: [
                  Text(
                    selectedLocation,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.white70),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
