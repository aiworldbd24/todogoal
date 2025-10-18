import 'package:uuid/uuid.dart';

import '../models/project_model.dart';
import '../models/task_model.dart';
import '../models/user_model.dart';

class DummyData {
  DummyData._();

  static final UserModel demoUser = UserModel(
    id: const Uuid().v4(),
    email: 'user@example.com',
    displayName: 'Sky Walker',
    isEmailVerified: true,
  );

  static List<ProjectModel> demoProjects() {
    final projectId = const Uuid().v4();
    return [
      ProjectModel(
        id: projectId,
        ownerId: demoUser.id,
        name: 'Nebula Launch',
        description: 'Prepare launch tasks for the upcoming product.',
        status: ProjectStatus.active,
        createdAt: DateTime.now(),
        tasks: [
          TaskModel(
            id: const Uuid().v4(),
            projectId: projectId,
            title: 'Define mission goals',
            description: 'Outline the OKRs and KPIs for the launch.',
            priority: TaskPriority.high,
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 2)),
            status: TaskStatus.inProgress,
          ),
          TaskModel(
            id: const Uuid().v4(),
            projectId: projectId,
            title: 'Craft teaser assets',
            description: 'Design visual teasers with glassmorphism aesthetics.',
            priority: TaskPriority.medium,
            startDate: DateTime.now(),
            endDate: DateTime.now().add(const Duration(days: 4)),
            status: TaskStatus.pending,
          ),
        ],
      ),
    ];
  }
}
