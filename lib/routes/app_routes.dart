import 'package:flutter/material.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/email_verification_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/projects/project_detail_screen.dart';
import '../screens/projects/project_form_screen.dart';
import '../screens/tasks/task_detail_screen.dart';
import '../screens/tasks/task_form_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String signup = '/signup';
  static const String verifyEmail = '/verify-email';
  static const String dashboard = '/dashboard';
  static const String projectForm = '/project-form';
  static const String projectDetail = '/project-detail';
  static const String taskForm = '/task-form';
  static const String taskDetail = '/task-detail';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case verifyEmail:
        return MaterialPageRoute(builder: (_) => const EmailVerificationScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case projectForm:
        return MaterialPageRoute(
          builder: (_) => ProjectFormScreen(project: settings.arguments as Map<String, dynamic>?),
        );
      case projectDetail:
        return MaterialPageRoute(
          builder: (_) => ProjectDetailScreen(projectId: settings.arguments as String),
        );
      case taskForm:
        return MaterialPageRoute(
          builder: (_) => TaskFormScreen(task: settings.arguments as Map<String, dynamic>?),
        );
      case taskDetail:
        return MaterialPageRoute(
          builder: (_) => TaskDetailScreen(taskId: settings.arguments as String),
        );
      case login:
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
