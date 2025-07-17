import 'package:flutter/foundation.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  TaskStatus _selectedFilter = TaskStatus.pending;

  List<Task> get tasks => _tasks;
  TaskStatus get selectedFilter => _selectedFilter;

  List<Task> get filteredTasks {
    switch (_selectedFilter) {
      case TaskStatus.pending:
        return _tasks.where((task) => task.status == TaskStatus.pending).toList();
      case TaskStatus.inProgress:
        return _tasks.where((task) => task.status == TaskStatus.inProgress).toList();
      case TaskStatus.completed:
        return _tasks.where((task) => task.status == TaskStatus.completed).toList();
      case TaskStatus.overdue:
        return _tasks.where((task) => task.status == TaskStatus.overdue).toList();
      case TaskStatus.cancelled:
        return _tasks.where((task) => task.status == TaskStatus.cancelled).toList();
    }
  }

  void setFilter(TaskStatus status) {
    _selectedFilter = status;
    notifyListeners();
  }

  List<Task> getTasksByFilter(TaskStatus status) {
    return _tasks.where((task) => task.status == status).toList();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void updateTaskStatus(String taskId, TaskStatus status) {
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(status: status);
      notifyListeners();
    }
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  int getTaskCountByStatus(TaskStatus status) {
    return _tasks.where((task) => task.status == status).length;
  }

  // Sample data initialization
  void initializeSampleTasks() {
    _tasks = [
      Task(
        id: '1',
        title: 'Design App UI',
        description: 'Create wireframes and mockups for the new app interface',
        status: TaskStatus.inProgress,
        priority: TaskPriority.high,
        dueDate: DateTime.now().add(const Duration(days: 3)),
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        createdBy: 'user1',
      ),
      Task(
        id: '2',
        title: 'Implement Authentication',
        description: 'Set up user login and registration system',
        status: TaskStatus.pending,
        priority: TaskPriority.urgent,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        createdBy: 'user1',
      ),
      Task(
        id: '3',
        title: 'Database Setup',
        description: 'Configure database schema and connections',
        status: TaskStatus.completed,
        priority: TaskPriority.medium,
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        createdBy: 'user2',
      ),
      Task(
        id: '4',
        title: 'Write Documentation',
        description: 'Create comprehensive project documentation',
        status: TaskStatus.pending,
        priority: TaskPriority.low,
        dueDate: DateTime.now().add(const Duration(days: 7)),
        createdAt: DateTime.now(),
        createdBy: 'user1',
      ),
    ];
    notifyListeners();
  }
}
