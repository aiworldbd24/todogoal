import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';
import '../routes/app_routes.dart';

final appStartProvider = Provider<String>((ref) {
  final authService = ref.watch(authServiceProvider);
  if (!authService.isLoggedIn) {
    return AppRoutes.login;
  }
  return authService.currentUser?.isEmailVerified == true
      ? AppRoutes.dashboard
      : AppRoutes.verifyEmail;
});
