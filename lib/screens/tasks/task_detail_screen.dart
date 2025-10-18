import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/project_model.dart';
import '../../models/task_model.dart';
import '../../providers/project_provider.dart';
import '../../widgets/glassmorphism_container.dart';
import '../../widgets/gradient_background.dart';

class TaskDetailScreen extends ConsumerWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectState = ref.watch(projectListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Task Detail')),
      body: GradientBackground(
        child: projectState.when(
          data: (projects) {
            final task = _findTask(projects, taskId);
            if (task == null) {
              return const Center(child: Text('Task not found'));
            }
            return _TaskDetail(task: task);
          },
          error: (error, _) => Center(child: Text('Error: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  TaskModel? _findTask(List<ProjectModel> projects, String id) {
    for (final project in projects) {
      for (final task in project.tasks) {
        if (task.id == id) {
          return task;
        }
      }
    }
    return null;
  }
}

class _TaskDetail extends StatelessWidget {
  const _TaskDetail({required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat.yMMMMd();
    return Center(
      child: GlassmorphismContainer(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(task.description, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            Row(
              children: [
                Chip(
                  label: Text(task.priority.name.toUpperCase()),
                  backgroundColor: Colors.white.withOpacity(0.1),
                ),
                const SizedBox(width: 12),
                Chip(
                  label: Text('Status: ${task.status.name}'),
                  backgroundColor: Colors.white.withOpacity(0.1),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Timeline',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${formatter.format(task.startDate)} → ${formatter.format(task.endDate)}',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
