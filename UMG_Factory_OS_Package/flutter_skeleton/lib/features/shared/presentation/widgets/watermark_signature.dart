import 'package:flutter/material.dart';

class WatermarkSignature extends StatelessWidget {
  const WatermarkSignature({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      left: 14,
      bottom: 10,
      child: IgnorePointer(
        child: Opacity(
          opacity: 0.22,
          child: Text(
            'Mohmd Murad',
            style: TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}
