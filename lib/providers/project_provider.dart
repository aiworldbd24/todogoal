import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/project_model.dart';
import '../models/task_model.dart';
import '../services/auth_service.dart';
import '../services/db_service.dart';
import '../services/notification_service.dart';
import '../utils/dummy_data.dart';

final projectListProvider =
    StateNotifierProvider<ProjectNotifier, AsyncValue<List<ProjectModel>>>((ref) {
  final auth = ref.watch(authServiceProvider);
  final db = ref.watch(dbServiceProvider);
  final notifications = ref.watch(notificationServiceProvider);
  final notifier = ProjectNotifier(
    dbService: db,
    notificationService: notifications,
    userId: auth.currentUser?.id,
  );
  notifier.loadInitial();
  return notifier;
});

class ProjectNotifier extends StateNotifier<AsyncValue<List<ProjectModel>>> {
  ProjectNotifier({
    required DatabaseService dbService,
    required NotificationService notificationService,
    required String? userId,
  })  : _dbService = dbService,
        _notificationService = notificationService,
        _userId = userId,
        super(const AsyncLoading());

  final DatabaseService _dbService;
  final NotificationService _notificationService;
  final String? _userId;

  Future<void> loadInitial() async {
    await _notificationService.init();
    if (_userId == null) {
      state = AsyncData(DummyData.demoProjects());
      return;
    }

    state = const AsyncLoading();
    try {
      final projects = await _dbService.fetchProjects(_userId!);
      state = AsyncData(projects);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> addProject(ProjectModel project) async {
    final current = state.value ?? [];
    final newProject = project.copyWith(id: const Uuid().v4());
    state = AsyncData([...current, newProject]);
    await _dbService.createProject(newProject);
  }

  Future<void> addTask(String projectId, TaskModel task) async {
    final current = state.value ?? [];
    final generatedTask = task.copyWith(id: const Uuid().v4(), projectId: projectId);
    final updatedProjects = current.map((project) {
      if (project.id == projectId) {
        _notificationService.scheduleDeadlineReminder(generatedTask);
        return project.copyWith(tasks: [...project.tasks, generatedTask]);
      }
      return project;
    }).toList();
    state = AsyncData(updatedProjects);
    await _dbService.createTask(generatedTask);
  }
}
