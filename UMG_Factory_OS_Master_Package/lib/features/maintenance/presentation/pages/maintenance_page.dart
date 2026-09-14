import 'package:flutter/material.dart';

class MaintenancePage extends StatelessWidget {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maintenance')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'هذه شاشة Maintenance ضمن النسخة الماستر.\nيتم توسيعها تدريجياً وفق المراحل التنفيذية المعتمدة.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
