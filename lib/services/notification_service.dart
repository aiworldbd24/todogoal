import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/task_model.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(FirebaseMessaging.instance);
});

class NotificationService {
  NotificationService(this._messaging);

  final FirebaseMessaging _messaging;

  Future<void> init() async {
    await _messaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? 'New update';
      debugPrint('Push received: ' + title);
    });
  }

  Future<void> scheduleDeadlineReminder(TaskModel task) async {
    // Use local notification plugins or server scheduled notifications.
    debugPrint('Scheduling notification for task: ' + task.title);
  }

  Future<String?> getDeviceToken() => _messaging.getToken();
}
