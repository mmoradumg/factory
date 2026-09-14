import 'package:flutter/material.dart';

class ProductionPage extends StatelessWidget {
  const ProductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Production')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'هذه شاشة Production ضمن النسخة الماستر.\nيتم توسيعها تدريجياً وفق المراحل التنفيذية المعتمدة.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
