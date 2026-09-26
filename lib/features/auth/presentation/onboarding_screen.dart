import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Icon(Icons.receipt_long, size: 100, color: Colors.blue),
              const SizedBox(height: 32),
              Text(
                'Get paid.\\nWithout the chasing.',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 40),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Track unpaid invoices and generate professional payment follow-up messages automatically.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => context.go('/register'),
                child: const Text('Register'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
