import 'package:flutter/material.dart';

class SalesHomePage extends StatelessWidget {
  const SalesHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المبيعات')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'هذه شاشة ابتدائية ضمن الحزمة التنفيذية، قابلة للتوسعة إلى النسخة الكاملة.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
