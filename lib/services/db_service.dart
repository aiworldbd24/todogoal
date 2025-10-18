import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/project_model.dart';
import '../models/task_model.dart';
import '../utils/dummy_data.dart';

final dbServiceProvider = Provider<DatabaseService>((ref) => DatabaseService());

class DatabaseService {
  DatabaseService();

  final String _apiBaseUrl = 'https://your-hostinger-app.com/api';

  Future<List<ProjectModel>> fetchProjects(String userId) async {
    // Replace with Hostinger API call
    final response = await http.get(Uri.parse('$_apiBaseUrl/projects?userId=$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((project) => ProjectModel.fromJson(project as Map<String, dynamic>))
          .toList();
    }
    return DummyData.demoProjects();
  }

  Future<ProjectModel> createProject(ProjectModel project) async {
    final response = await http.post(
      Uri.parse('$_apiBaseUrl/projects'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(project.toJson()),
    );
    if (response.statusCode == 201) {
      return ProjectModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    return project;
  }

  Future<TaskModel> createTask(TaskModel task) async {
    final response = await http.post(
      Uri.parse('$_apiBaseUrl/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );
    if (response.statusCode == 201) {
      return TaskModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }
    return task;
  }

  Future<void> scheduleNotification(TaskModel task) async {
    // TODO: call your notification endpoint
  }

  /// Firebase alternative example using REST endpoints
  /// (You may replace with the Firebase Admin SDK on your server)
  Future<void> syncWithFirebase(Map<String, dynamic> payload) async {
    final firebaseFunctionUrl = 'https://us-central1-your-project.cloudfunctions.net/syncTask';
    await http.post(
      Uri.parse(firebaseFunctionUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
  }
}
