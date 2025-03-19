import 'package:flutter/material.dart';

class ForeCastPerHour extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;

  const ForeCastPerHour({
    super.key,
    required this.time,
    required this.temperature,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: SizedBox(
        width: 100,
        height: 120, // Ensure it has enough height to fit all content
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Prevent overflow by making it as small as possible
            children: [
              Text(
                time,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.fade,
              ),
              const SizedBox(height: 4), // Reduce unnecessary spacing
              Icon(icon, size: 32),
              const SizedBox(height: 4),
              Text(
                temperature,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
