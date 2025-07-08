// Project model and status enum

class Project {
  final String id;
  final String title;
  final String description;
  final double progress;
  final List<String> teamMembers;
  final DateTime dueDate;
  final ProjectStatus status;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.teamMembers,
    required this.dueDate,
    required this.status,
  });
}

enum ProjectStatus { inProgress, completed, pending, cancelled }
