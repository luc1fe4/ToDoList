import 'task_category.dart';

enum ShadowType {
  peach,
  sage,
}

class TaskModel {
  final String id;
  final String title;
  final TaskCategory category;
  final DateTime? dueDate;
  final String? dueTime;
  final String? dueDateLabel;
  final String? timeOfDayGroup; // 'MORNING', 'AFTERNOON', 'EVENING'
  final bool reminderEnabled;
  final String? reminderLabel;
  final DateTime? createdAt;
  final DateTime? completedAt;
  final String? completedLabel;
  final ShadowType shadowType;

  const TaskModel({
    required this.id,
    required this.title,
    this.category = TaskCategory.none,
    this.dueDate,
    this.dueTime,
    this.dueDateLabel,
    this.timeOfDayGroup,
    this.reminderEnabled = false,
    this.reminderLabel,
    this.createdAt,
    this.completedAt,
    this.completedLabel,
    this.shadowType = ShadowType.peach,
  });

  bool get isCompleted => completedAt != null;

  TaskModel copyWith({
    String? id,
    String? title,
    TaskCategory? category,
    DateTime? dueDate,
    String? dueTime,
    String? dueDateLabel,
    String? timeOfDayGroup,
    bool? reminderEnabled,
    String? reminderLabel,
    DateTime? createdAt,
    DateTime? completedAt,
    String? completedLabel,
    ShadowType? shadowType,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      dueDateLabel: dueDateLabel ?? this.dueDateLabel,
      timeOfDayGroup: timeOfDayGroup ?? this.timeOfDayGroup,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderLabel: reminderLabel ?? this.reminderLabel,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      completedLabel: completedLabel ?? this.completedLabel,
      shadowType: shadowType ?? this.shadowType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category.name,
      'dueDate': dueDate?.toIso8601String(),
      'dueTime': dueTime,
      'dueDateLabel': dueDateLabel,
      'timeOfDayGroup': timeOfDayGroup,
      'reminderEnabled': reminderEnabled,
      'reminderLabel': reminderLabel,
      'createdAt': createdAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'completedLabel': completedLabel,
      'shadowType': shadowType.name,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: TaskCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => TaskCategory.none,
      ),
      dueDate: json['dueDate'] != null ? DateTime.tryParse(json['dueDate'] as String) : null,
      dueTime: json['dueTime'] as String?,
      dueDateLabel: json['dueDateLabel'] as String?,
      timeOfDayGroup: json['timeOfDayGroup'] as String?,
      reminderEnabled: json['reminderEnabled'] as bool? ?? false,
      reminderLabel: json['reminderLabel'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] as String) : null,
      completedAt: json['completedAt'] != null ? DateTime.tryParse(json['completedAt'] as String) : null,
      completedLabel: json['completedLabel'] as String?,
      shadowType: ShadowType.values.firstWhere(
        (s) => s.name == json['shadowType'],
        orElse: () => ShadowType.peach,
      ),
    );
  }
}

