import 'package:flutter/material.dart';

class HourlyForeCastItem extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;
  const HourlyForeCastItem({
    super.key,
    required this.time,
    required this.temperature,
    required this.icon,
    });

  @override
  Widget build(BuildContext context) {
    return  Card(
      surfaceTintColor: Colors.grey,
      elevation: 6,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: SizedBox(
          width: 90,
          child: Column(
            children: [
              Text(
                time,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Icon(icon, size: 32),
              SizedBox(height: 8),
              Text(temperature),
            ],
          ),
        ),
      ),
    );
  }
}
