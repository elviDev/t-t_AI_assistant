import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/voice_prompt_widget.dart';
import '../../models/task.dart';
import 'widgets/task_card.dart';
import 'widgets/task_filter_tabs.dart';
import 'screens/task_detail_screen.dart';

/// Tasks screen for managing tasks and assignments
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  TaskStatus _selectedFilter = TaskStatus.pending;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _animationController = AnimationController(
      duration: AppConstants.animationDuration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: _buildAppBar(isDark),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Voice prompt section
            _buildVoicePromptSection(isDark),
            
            // Search bar
            _buildSearchBar(isDark),
            
            // Added more spacing between search and filter tabs
            const SizedBox(height: AppConstants.spacing24),
            
            // Filter tabs
            TaskFilterTabs(
              selectedStatus: _selectedFilter,
              onStatusChanged: (status) {
                setState(() {
                  _selectedFilter = status ?? TaskStatus.pending;
                });
              },
              isDark: isDark,
            ),
            
            // Added spacing before tasks list
            const SizedBox(height: AppConstants.spacing16),
            
            // Tasks list
            Expanded(
              child: _buildTasksList(isDark),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// Build app bar
  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        'Tasks',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: isDark ? AppColors.darkText : AppColors.lightText,
          fontFamily: AppConstants.fontFamily,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.filter_list_rounded,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
          onPressed: _showFilterDialog,
        ),
        IconButton(
          icon: Icon(
            Icons.sort_rounded,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
          onPressed: _showSortDialog,
        ),
        const SizedBox(width: AppConstants.spacing8),
      ],
    );
  }

  /// Build voice prompt section
  Widget _buildVoicePromptSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      child: VoicePromptWidget(
        onPromptSubmitted: _handleAIPrompt,
        onVoicePressed: _toggleVoiceRecording,
      ),
    );
  }

  /// Build search bar
  Widget _buildSearchBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacing16),
      child: TextField(
        controller: _searchController,
        style: TextStyle(
          color: isDark ? AppColors.darkText : AppColors.lightText,
          fontFamily: AppConstants.fontFamily,
        ),
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          hintStyle: TextStyle(
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            fontFamily: AppConstants.fontFamily,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
          filled: true,
          fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacing16,
            vertical: AppConstants.spacing12,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  /// Build tasks list
  Widget _buildTasksList(bool isDark) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildTasksTab(TaskStatus.pending, isDark),
        _buildTasksTab(TaskStatus.inProgress, isDark),
        _buildTasksTab(TaskStatus.completed, isDark),
        _buildTasksTab(TaskStatus.overdue, isDark),
      ],
    );
  }

  /// Build tasks tab content
  Widget _buildTasksTab(TaskStatus status, bool isDark) {
    final filteredTasks = _getFilteredTasks(status);
    
    if (filteredTasks.isEmpty) {
      return _buildEmptyState(status, isDark);
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return TaskCard(
          task: task,
          isDark: isDark,
          onTap: () => _navigateToTaskDetail(task),
          onStatusChanged: () => _refreshTasks(),
        );
      },
    );
  }

  /// Build empty state
  Widget _buildEmptyState(TaskStatus status, bool isDark) {
    String title, subtitle;
    IconData icon;
    
    switch (status) {
      case TaskStatus.pending:
        icon = Icons.assignment_outlined;
        title = 'No pending tasks';
        subtitle = 'All caught up! Create a new task to get started.';
        break;
      case TaskStatus.inProgress:
        icon = Icons.work_outline;
        title = 'No tasks in progress';
        subtitle = 'Start working on a pending task to see it here.';
        break;
      case TaskStatus.completed:
        icon = Icons.check_circle_outline;
        title = 'No completed tasks';
        subtitle = 'Complete some tasks to see your achievements here.';
        break;
      case TaskStatus.overdue:
        icon = Icons.schedule;
        title = 'No overdue tasks';
        subtitle = 'Great! You\'re staying on top of your deadlines.';
        break;
      case TaskStatus.cancelled:
        icon = Icons.cancel_outlined;
        title = 'No cancelled tasks';
        subtitle = 'All tasks are active and progressing well.';
        break;
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
          const SizedBox(height: AppConstants.spacing16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
          const SizedBox(height: AppConstants.spacing8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              fontFamily: AppConstants.fontFamily,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build floating action button
  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _showCreateTaskDialog,
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add_rounded),
      label: const Text(
        'New Task',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: AppConstants.fontFamily,
        ),
      ),
    );
  }

  /// Get filtered tasks based on status and search query
  List<Task> _getFilteredTasks(TaskStatus status) {
    // Mock data - in real app, this would come from TaskProvider
    final allTasks = _getMockTasks();
    
    var filtered = allTasks.where((task) => task.status == status).toList();
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((task) =>
          task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.description.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    
    return filtered;
  }

  /// Get mock tasks data
  List<Task> _getMockTasks() {
    return [
      Task(
        id: '1',
        title: 'Design mobile app wireframes',
        description: 'Create wireframes for the new mobile application',
        status: TaskStatus.pending,
        priority: TaskPriority.high,
        assigneeId: 'user1',
        assigneeName: 'Alice Johnson',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        createdBy: 'manager1',
        channelId: '1',
        tags: ['design', 'mobile', 'wireframes'],
      ),
      Task(
        id: '2',
        title: 'Implement user authentication',
        description: 'Set up login and registration functionality',
        status: TaskStatus.inProgress,
        priority: TaskPriority.high,
        assigneeId: 'user2',
        assigneeName: 'Bob Smith',
        dueDate: DateTime.now().add(const Duration(days: 5)),
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        createdBy: 'manager1',
        channelId: '1',
        tags: ['development', 'auth'],
      ),
      Task(
        id: '3',
        title: 'Write marketing copy',
        description: 'Create compelling copy for the landing page',
        status: TaskStatus.completed,
        priority: TaskPriority.medium,
        assigneeId: 'user3',
        assigneeName: 'Carol White',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        completedAt: DateTime.now().subtract(const Duration(hours: 2)),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        createdBy: 'manager2',
        channelId: '2',
        tags: ['marketing', 'copy'],
      ),
    ];
  }

  /// Navigate to task detail screen
  void _navigateToTaskDetail(Task task) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            TaskDetailScreen(task: task),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
        transitionDuration: AppConstants.animationDuration,
      ),
    );
  }

  /// Refresh tasks data
  void _refreshTasks() {
    setState(() {
      // Trigger rebuild to refresh task list
    });
  }

  /// Show create task dialog
  void _showCreateTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => const CreateTaskDialog(),
    );
  }

  /// Show filter dialog
  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const TaskFilterBottomSheet(),
    );
  }

  /// Show sort dialog
  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const TaskSortBottomSheet(),
    );
  }

  /// Handle AI prompt
  void _handleAIPrompt(String prompt) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('AI is processing: "$prompt"'),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  /// Toggle voice recording
  void _toggleVoiceRecording() {
    // Implementation for voice recording
  }
}

/// Create task dialog
class CreateTaskDialog extends StatefulWidget {
  const CreateTaskDialog({super.key});

  @override
  State<CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<CreateTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isCreating = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
      ),
      title: Text(
        'Create New Task',
        style: TextStyle(
          color: isDark ? AppColors.darkText : AppColors.lightText,
          fontFamily: AppConstants.fontFamily,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            style: TextStyle(
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontFamily: AppConstants.fontFamily,
            ),
            decoration: InputDecoration(
              labelText: 'Task Title',
              labelStyle: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacing16),
          TextField(
            controller: _descriptionController,
            style: TextStyle(
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontFamily: AppConstants.fontFamily,
            ),
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Description',
              labelStyle: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _isCreating ? null : _createTask,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            ),
          ),
          child: _isCreating
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Create',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: AppConstants.fontFamily,
                  ),
                ),
        ),
      ],
    );
  }

  void _createTask() async {
    if (_titleController.text.trim().isEmpty) return;
    
    setState(() {
      _isCreating = true;
    });
    
    // Simulate task creation
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task "${_titleController.text}" created successfully!'),
          backgroundColor: AppColors.successColor,
        ),
      );
    }
  }
}

/// Task filter bottom sheet
class TaskFilterBottomSheet extends StatelessWidget {
  const TaskFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
      ),
      padding: const EdgeInsets.all(AppConstants.spacing24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppConstants.spacing24),
          Text(
            'Filter Tasks',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
          const SizedBox(height: AppConstants.spacing24),
          Text(
            'Filter options coming soon...',
            style: TextStyle(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
          const SizedBox(height: AppConstants.spacing24),
        ],
      ),
    );
  }
}

/// Task sort bottom sheet
class TaskSortBottomSheet extends StatelessWidget {
  const TaskSortBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
      ),
      padding: const EdgeInsets.all(AppConstants.spacing24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppConstants.spacing24),
          Text(
            'Sort Tasks',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
          const SizedBox(height: AppConstants.spacing24),
          Text(
            'Sort options coming soon...',
            style: TextStyle(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
          const SizedBox(height: AppConstants.spacing24),
        ],
      ),
    );
  }
}
