import 'package:flutter/material.dart';

import '../../../system/presentation/pages/system_modules_page.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'المصنع بكامله بين يديك',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'فقط تخيّل… ونحن نُحقّق، فالخيال حقيقة حين يُصاغ بإتقان',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 28),
                          const TextField(decoration: InputDecoration(labelText: 'ID')),
                          const SizedBox(height: 12),
                          const TextField(
                            obscureText: true,
                            decoration: InputDecoration(labelText: 'Password'),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: TextButton(
                              onPressed: () {},
                              child: const Text('Forget Password'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          FilledButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (_) => const SystemModulesPage(),
                                ),
                              );
                            },
                            child: const Text('Login'),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const RegisterPage()),
                              );
                            },
                            child: const Text('Create New Account'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 14,
              bottom: 10,
              child: Opacity(
                opacity: 0.22,
                child: Text('Mohmd Murad'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
