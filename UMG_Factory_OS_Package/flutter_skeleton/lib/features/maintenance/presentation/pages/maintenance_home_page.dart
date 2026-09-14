import 'package:flutter/material.dart';

class MaintenanceHomePage extends StatelessWidget {
  const MaintenanceHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأعطال والصيانة')),
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
