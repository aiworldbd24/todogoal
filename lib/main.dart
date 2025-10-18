import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'providers/app_start_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: TodoGoalApp()));
}

class TodoGoalApp extends ConsumerWidget {
  const TodoGoalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialRoute = ref.watch(appStartProvider);

    return MaterialApp(
      title: 'TodoGoal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: initialRoute,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
