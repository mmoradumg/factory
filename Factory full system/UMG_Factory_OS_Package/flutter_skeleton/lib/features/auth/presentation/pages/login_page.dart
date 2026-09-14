import 'package:flutter/material.dart';

import '../../../shared/presentation/widgets/watermark_signature.dart';
import '../../../system_modules/presentation/pages/system_modules_screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final idController = TextEditingController();
    final passController = TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'المصنع بكامله بين يديك',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'فقط تخيّل… ونحن نُحقّق، فالخيال حقيقة حين يُصاغ بإتقان',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: idController,
                        decoration: const InputDecoration(labelText: 'ID'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: passController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Password'),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Forget Password'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SystemModulesScreen(),
                              ),
                            );
                          },
                          child: const Text('Login'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text('Create New Account'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const WatermarkSignature(),
        ],
      ),
    );
  }
}
