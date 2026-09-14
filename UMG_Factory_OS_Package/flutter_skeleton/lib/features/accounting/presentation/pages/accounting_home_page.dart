import 'package:flutter/material.dart';

class AccountingHomePage extends StatelessWidget {
  const AccountingHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الحسابات')),
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
