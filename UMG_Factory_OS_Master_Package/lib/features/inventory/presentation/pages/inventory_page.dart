import 'package:flutter/material.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Inventory')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'هذه شاشة Smart Inventory ضمن النسخة الماستر.\nيتم توسيعها تدريجياً وفق المراحل التنفيذية المعتمدة.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
