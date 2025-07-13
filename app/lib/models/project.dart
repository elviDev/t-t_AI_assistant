/// Project model representing a project in the application
class Project {
  final String id;
  final String title;
  final String description;
  final double progress;
  final List<String> teamMembers;
  final DateTime dueDate;
  final ProjectStatus status;
  final String? imageUrl;
  final List<String>? tags;

  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.teamMembers,
    required this.dueDate,
    required this.status,
    this.imageUrl,
    this.tags,
  });

  /// Create a copy of the project with updated values
  Project copyWith({
    String? id,
    String? title,
    String? description,
    double? progress,
    List<String>? teamMembers,
    DateTime? dueDate,
    ProjectStatus? status,
    String? imageUrl,
    List<String>? tags,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      progress: progress ?? this.progress,
      teamMembers: teamMembers ?? this.teamMembers,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
      imageUrl: imageUrl ?? this.imageUrl,
      tags: tags ?? this.tags,
    );
  }

  /// Convert project to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'progress': progress,
      'teamMembers': teamMembers,
      'dueDate': dueDate.toIso8601String(),
      'status': status.name,
      'imageUrl': imageUrl,
      'tags': tags,
    };
  }

  /// Create project from JSON
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      progress: (json['progress'] as num).toDouble(),
      teamMembers: List<String>.from(json['teamMembers'] as List),
      dueDate: DateTime.parse(json['dueDate'] as String),
      status: ProjectStatus.values.firstWhere(
        (status) => status.name == json['status'],
      ),
      imageUrl: json['imageUrl'] as String?,
      tags: json['tags'] != null ? List<String>.from(json['tags'] as List) : null,
    );
  }

  @override
  String toString() {
    return 'Project(id: $id, title: $title, progress: $progress, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Project && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Enum representing different project statuses
enum ProjectStatus {
  pending('Pending'),
  inProgress('In Progress'),
  completed('Completed'),
  cancelled('Cancelled'),
  onHold('On Hold');

  const ProjectStatus(this.displayName);

  final String displayName;

  /// Get color associated with status
  String get colorName {
    switch (this) {
      case ProjectStatus.pending:
        return 'warning';
      case ProjectStatus.inProgress:
        return 'primary';
      case ProjectStatus.completed:
        return 'success';
      case ProjectStatus.cancelled:
        return 'error';
      case ProjectStatus.onHold:
        return 'secondary';
    }
  }
}
