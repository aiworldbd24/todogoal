enum TaskPriority { high, medium, low }

enum TaskStatus { pending, inProgress, completed }

class TaskModel {
  const TaskModel({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.priority,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.notificationsScheduled = false,
  });

  final String id;
  final String projectId;
  final String title;
  final String description;
  final TaskPriority priority;
  final DateTime startDate;
  final DateTime endDate;
  final TaskStatus status;
  final bool notificationsScheduled;

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      projectId: json['project_id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      priority: TaskPriority.values.firstWhere(
        (priority) => priority.name == (json['priority'] as String? ?? 'medium'),
        orElse: () => TaskPriority.medium,
      ),
      startDate: DateTime.tryParse(json['start_date'] as String? ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['end_date'] as String? ?? '') ?? DateTime.now(),
      status: TaskStatus.values.firstWhere(
        (status) => status.name == (json['status'] as String? ?? 'pending'),
        orElse: () => TaskStatus.pending,
      ),
      notificationsScheduled: json['notifications_scheduled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'title': title,
      'description': description,
      'priority': priority.name,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'status': status.name,
      'notifications_scheduled': notificationsScheduled,
    };
  }

  TaskModel copyWith({
    String? id,
    String? projectId,
    String? title,
    String? description,
    TaskPriority? priority,
    DateTime? startDate,
    DateTime? endDate,
    TaskStatus? status,
    bool? notificationsScheduled,
  }) {
    return TaskModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      notificationsScheduled: notificationsScheduled ?? this.notificationsScheduled,
    );
  }
}
