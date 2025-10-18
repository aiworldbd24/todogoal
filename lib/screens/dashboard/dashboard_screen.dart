import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/project_model.dart';
import '../../providers/project_provider.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../widgets/glass_button.dart';
import '../../widgets/glassmorphism_container.dart';
import '../../widgets/gradient_background.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _hasPrompted = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _promptCreateProject() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Create New Project'),
          content: const Text('Your workspace is empty. Start by creating a project.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Later'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.projectForm);
              },
              child: const Text('Create'),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildProjectList(List<ProjectModel> projects) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: projects.isEmpty
          ? Center(
              child: GlassmorphismContainer(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('No projects yet'),
                    const SizedBox(height: 12),
                    GlassButton(
                      label: 'Create Project',
                      icon: Icons.add,
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.projectForm),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: projects.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, index) {
                final project = projects[index];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.projectDetail,
                    arguments: project.id,
                  ),
                  child: GlassmorphismContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          project.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          children: [
                            Chip(
                              label: Text('${project.tasks.length} tasks'),
                              backgroundColor: Colors.white.withOpacity(0.12),
                            ),
                            Chip(
                              label: Text('Created ${DateFormat.MMMd().format(project.createdAt)}'),
                              backgroundColor: Colors.white.withOpacity(0.12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authServiceProvider);
    final projectState = ref.watch(projectListProvider);

    projectState.whenOrNull(data: (projects) {
      if (projects.isEmpty && !_hasPrompted) {
        _hasPrompted = true;
        _promptCreateProject();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('TodoGoal Dashboard'),
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(authServiceProvider).logout();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed(AppRoutes.login);
              }
            },
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'List'),
            Tab(text: 'Calendar'),
            Tab(text: 'Cards'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.projectForm),
        icon: const Icon(Icons.add),
        label: const Text('Project'),
      ),
      body: GradientBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Welcome, ${auth.currentUser?.displayName ?? 'Commander'}',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: projectState.when(
                data: (projects) => TabBarView(
                  controller: _tabController,
                  children: [
                    _buildProjectList(projects),
                    _CalendarView(projects: projects),
                    _CardOverview(projects: projects),
                  ],
                ),
                error: (error, _) => Center(child: Text('Failed to load projects: $error')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarView extends StatelessWidget {
  const _CalendarView({required this.projects});

  final List<ProjectModel> projects;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat.MMMd();
    final tasks = projects.expand((project) => project.tasks).toList();
    tasks.sort((a, b) => a.endDate.compareTo(b.endDate));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassmorphismContainer(
            child: ListTile(
              title: Text(task.title, style: const TextStyle(color: Colors.white)),
              subtitle: Text(
                '${formatter.format(task.startDate)} → ${formatter.format(task.endDate)}',
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: Icon(Icons.circle, color: _priorityColor(task.priority)),
            ),
          ),
        );
      },
    );
  }
}

class _CardOverview extends StatelessWidget {
  const _CardOverview({required this.projects});

  final List<ProjectModel> projects;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 4 / 3,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return GlassmorphismContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: project.tasks.length,
                  itemBuilder: (_, taskIndex) {
                    final task = project.tasks[taskIndex];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(Icons.circle, size: 12, color: _priorityColor(task.priority)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              task.title,
                              style: const TextStyle(color: Colors.white70),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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
