import 'package:flutter/material.dart';

class AdditionalInfoItems extends StatelessWidget {
  final IconData icon;
  final String text;
  final String value;

  const AdditionalInfoItems({
    super.key,
    required this.icon,
    required this.text,
    required this.value
    });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32),
        SizedBox(height: 8),
        Text(text),
        SizedBox(height: 8),
        Text('$value', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
