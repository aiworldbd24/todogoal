import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/project_model.dart';
import '../../models/task_model.dart';
import '../../providers/project_provider.dart';
import '../../routes/app_routes.dart';
import '../../widgets/glass_button.dart';
import '../../widgets/glassmorphism_container.dart';
import '../../widgets/gradient_background.dart';
import '../../utils/iterable_extensions.dart';

class ProjectDetailScreen extends ConsumerWidget {
  const ProjectDetailScreen({super.key, required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectState = ref.watch(projectListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Project Detail')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(
          context,
          AppRoutes.taskForm,
          arguments: {'projectId': projectId},
        ),
        icon: const Icon(Icons.add_task),
        label: const Text('Add Task'),
      ),
      body: GradientBackground(
        child: projectState.when(
          data: (projects) {
            final project = projects.where((project) => project.id == projectId).firstOrNull;
            if (project == null) {
              return const Center(child: Text('Project not found'));
            }
            return _ProjectDetailBody(project: project);
          },
          error: (error, _) => Center(child: Text('Error: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class _ProjectDetailBody extends StatefulWidget {
  const _ProjectDetailBody({required this.project});

  final ProjectModel project;

  @override
  State<_ProjectDetailBody> createState() => _ProjectDetailBodyState();
}

class _ProjectDetailBodyState extends State<_ProjectDetailBody> {
  TaskPriority? _filterPriority;

  @override
  Widget build(BuildContext context) {
    final tasks = widget.project.tasks.where((task) {
      if (_filterPriority == null) return true;
      return task.priority == _filterPriority;
    }).toList()
      ..sort((a, b) => a.endDate.compareTo(b.endDate));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassmorphismContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.project.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.project.description,
                  style:
                      Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text('Filter by priority', style: TextStyle(color: Colors.white)),
              const SizedBox(width: 12),
              DropdownButton<TaskPriority?>(
                value: _filterPriority,
                dropdownColor: Colors.blueGrey.shade900,
                items: [
                  const DropdownMenuItem(value: null, child: Text('All')),
                  ...TaskPriority.values.map(
                    (priority) => DropdownMenuItem(
                      value: priority,
                      child: Text(priority.name.toUpperCase()),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _filterPriority = value),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: GlassButton(
                      label: 'Add your first task',
                      icon: Icons.add_circle_outline,
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.taskForm,
                        arguments: {'projectId': widget.project.id},
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (_, index) {
                      final task = tasks[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.taskDetail,
                            arguments: task.id,
                          ),
                          child: GlassmorphismContainer(
                            child: ListTile(
                              title: Text(task.title,
                                  style: const TextStyle(color: Colors.white)),
                              subtitle: Text(
                                '${DateFormat.MMMd().format(task.startDate)} → ${DateFormat.MMMd().format(task.endDate)}',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              trailing:
                                  Icon(Icons.circle, color: _priorityColor(task.priority)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

Color _priorityColor(TaskPriority priority) {
  switch (priority) {
    case TaskPriority.high:
      return Colors.redAccent;
    case TaskPriority.medium:
      return Colors.orangeAccent;
    case TaskPriority.low:
      return Colors.greenAccent;
  }
}
