import 'package:flutter/material.dart';

class AccountingPage extends StatelessWidget {
  const AccountingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accounting')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'هذه شاشة Accounting ضمن النسخة الماستر.\nيتم توسيعها تدريجياً وفق المراحل التنفيذية المعتمدة.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
