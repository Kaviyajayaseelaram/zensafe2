import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/zensafe_logo.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5AD0FF), Color(0xFF47B3FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const ZenSafeLogo(size: 140).animate().scale(duration: 700.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 24),
            Text(
              'Welcome to ZenSafe',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your smart safety & wellness companion for kids.',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.white.withOpacity(0.9)),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF6A4BFF),
              ),
              onPressed: () => context.go('/login'),
              child: const Text('Let’s Begin!'),
            ),
          ],
        ),
      ),
    );
  }
}

