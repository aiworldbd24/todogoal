import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../models/project_model.dart';
import '../../providers/project_provider.dart';
import '../../services/auth_service.dart';
import '../../widgets/glassmorphism_container.dart';
import '../../widgets/gradient_background.dart';

class ProjectFormScreen extends ConsumerStatefulWidget {
  const ProjectFormScreen({super.key, this.project});

  final Map<String, dynamic>? project;

  @override
  ConsumerState<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends ConsumerState<ProjectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project?['name'] as String? ?? '');
    _descriptionController =
        TextEditingController(text: widget.project?['description'] as String? ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final currentUser = ref.read(authServiceProvider).currentUser;
    final ownerId = widget.project?['ownerId'] as String? ?? currentUser?.id;
    if (ownerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in before creating projects.')),
      );
      return;
    }

    final newProject = ProjectModel(
      id: widget.project?['id'] as String? ?? const Uuid().v4(),
      ownerId: ownerId,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      status: ProjectStatus.active,
      createdAt: DateTime.now(),
      tasks: const [],
    );

    await ref.read(projectListProvider.notifier).addProject(newProject);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Project ${newProject.name} saved.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.project != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Project' : 'Create Project')),
      body: GradientBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: GlassmorphismContainer(
              width: 520,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Project name'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter project name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _handleSubmit,
                      child: Text(isEditing ? 'Update project' : 'Create project'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
