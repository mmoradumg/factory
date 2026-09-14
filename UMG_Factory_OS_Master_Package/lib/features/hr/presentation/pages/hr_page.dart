import 'package:flutter/material.dart';

class HrPage extends StatelessWidget {
  const HrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HR')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'هذه شاشة HR ضمن النسخة الماستر.\nيتم توسيعها تدريجياً وفق المراحل التنفيذية المعتمدة.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
