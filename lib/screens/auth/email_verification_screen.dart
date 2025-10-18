import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/glassmorphism_container.dart';
import '../../widgets/gradient_background.dart';

class EmailVerificationScreen extends ConsumerWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);

    Future<void> verify() async {
      final navigator = Navigator.of(context);
      await authService.markEmailVerified();
      if (!navigator.mounted) return;
      navigator.pushReplacementNamed(AppRoutes.dashboard);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email verified! Welcome aboard.')),
      );
    }

    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: GlassmorphismContainer(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, size: 72, color: Colors.lightBlueAccent.shade100),
                const SizedBox(height: 16),
                Text(
                  'Verify your email',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  'We've sent a verification link to ${authService.currentUser?.email ?? ''}. '
                  'Activate it to unlock your dashboard.',
                  textAlign: TextAlign.center,
                  style:
                      Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: verify,
                  child: const Text('I've verified my email'),
                ),
                TextButton(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await authService.sendEmailVerification();
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Verification email re-sent.')),
                    );
                  },
                  child: const Text('Resend verification email'),
                ),
                TextButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    await authService.logout();
                    if (navigator.mounted) {
                      navigator.pushReplacementNamed(AppRoutes.login);
                    }
                  },
                  child: const Text('Back to login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
