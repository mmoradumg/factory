import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Account')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          TextField(decoration: InputDecoration(labelText: 'الاسم')),
          SizedBox(height: 12),
          TextField(decoration: InputDecoration(labelText: 'السن')),
          SizedBox(height: 12),
          TextField(decoration: InputDecoration(labelText: 'الوظيفة')),
          SizedBox(height: 12),
          TextField(decoration: InputDecoration(labelText: 'اسم الشركة')),
          SizedBox(height: 12),
          TextField(decoration: InputDecoration(labelText: 'البريد الإلكتروني')),
          SizedBox(height: 12),
          TextField(decoration: InputDecoration(labelText: 'الموقع')),
          SizedBox(height: 12),
          TextField(decoration: InputDecoration(labelText: 'الهاتف')),
          SizedBox(height: 12),
          TextField(decoration: InputDecoration(labelText: 'كلمة المرور')),
        ],
      ),
    );
  }
}
