import 'task_model.dart';

enum ProjectStatus { active, archived }

class ProjectModel {
  const ProjectModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    required this.status,
    required this.tasks,
    required this.createdAt,
  });

  final String id;
  final String ownerId;
  final String name;
  final String description;
  final ProjectStatus status;
  final List<TaskModel> tasks;
  final DateTime createdAt;

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      ownerId: json['user_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: ProjectStatus.values.firstWhere(
        (status) => status.name == (json['status'] as String? ?? 'active'),
        orElse: () => ProjectStatus.active,
      ),
      tasks: (json['tasks'] as List<dynamic>? ?? [])
          .map((task) => TaskModel.fromJson(task as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': ownerId,
      'name': name,
      'description': description,
      'status': status.name,
      'tasks': tasks.map((task) => task.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  ProjectModel copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? description,
    ProjectStatus? status,
    List<TaskModel>? tasks,
    DateTime? createdAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
