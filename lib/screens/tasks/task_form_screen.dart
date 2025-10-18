import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../models/task_model.dart';
import '../../providers/project_provider.dart';
import '../../widgets/glassmorphism_container.dart';
import '../../widgets/gradient_background.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  const TaskFormScreen({super.key, this.task});

  final Map<String, dynamic>? task;

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late DateTime _startDate;
  late DateTime _endDate;
  TaskPriority _priority = TaskPriority.medium;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?['title'] as String? ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?['description'] as String? ?? '');
    _startDate = widget.task?['startDate'] as DateTime? ?? DateTime.now();
    _endDate = widget.task?['endDate'] as DateTime? ?? DateTime.now().add(const Duration(days: 1));
    if (widget.task?['priority'] is TaskPriority) {
      _priority = widget.task?['priority'] as TaskPriority;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = selectedDate;
        } else {
          _endDate = selectedDate;
        }
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    final projectId = (widget.task?['projectId'] as String?) ??
        (routeArgs is Map<String, dynamic> ? routeArgs['projectId'] as String? : null);

    if (projectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project reference missing.')), 
      );
      return;
    }

    final task = TaskModel(
      id: widget.task?['id'] as String? ?? const Uuid().v4(),
      projectId: projectId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _priority,
      startDate: _startDate,
      endDate: _endDate,
      status: TaskStatus.pending,
    );

    await ref.read(projectListProvider.notifier).addTask(projectId, task);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task ${task.title} saved.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMEd();
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? 'Create Task' : 'Edit Task')),
      body: GradientBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: GlassmorphismContainer(
              width: 520,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Task Title'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter task title' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<TaskPriority>(
                      value: _priority,
                      items: TaskPriority.values
                          .map((priority) => DropdownMenuItem(
                                value: priority,
                                child: Text(priority.name.toUpperCase()),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _priority = value);
                      },
                      decoration: const InputDecoration(labelText: 'Priority'),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: const Text('Start Date'),
                            subtitle: Text(dateFormat.format(_startDate)),
                            trailing: IconButton(
                              icon: const Icon(Icons.calendar_month),
                              onPressed: () => _pickDate(isStart: true),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('End Date'),
                            subtitle: Text(dateFormat.format(_endDate)),
                            trailing: IconButton(
                              icon: const Icon(Icons.calendar_month),
                              onPressed: () => _pickDate(isStart: false),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _handleSubmit,
                      child: const Text('Save Task'),
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
