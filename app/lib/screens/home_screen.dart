import 'package:flutter/material.dart';
import '../models/project.dart';
import '../widgets/app_colors.dart';
import '../widgets/project_card.dart';
import '../widgets/quick_action_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _promptController = TextEditingController();
  bool _isListening = false;
  bool _isProcessing = false;
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Project> _projects = [
    Project(
      id: '1',
      title: 'Mobile App Development',
      description: 'Create a new mobile application for client',
      progress: 0.65,
      teamMembers: ['John Doe', 'Jane Smith', 'Mike Johnson'],
      dueDate: DateTime.now().add(const Duration(days: 14)),
      status: ProjectStatus.inProgress,
    ),
    Project(
      id: '2',
      title: 'Website Redesign',
      description: 'Redesign company website with modern UI',
      progress: 0.30,
      teamMembers: ['Sarah Wilson', 'Tom Brown'],
      dueDate: DateTime.now().add(const Duration(days: 21)),
      status: ProjectStatus.inProgress,
    ),
    Project(
      id: '3',
      title: 'Marketing Campaign',
      description: 'Launch Q4 marketing campaign',
      progress: 1.0,
      teamMembers: ['Alice Cooper', 'Bob Davis'],
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      status: ProjectStatus.completed,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
    _slideController.forward();
  }

  @override
  void dispose() {
    _promptController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ),
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Hello Javier!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.success,
            child: Icon(Icons.person, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Give any command from creating a\ndocument to scheduling a\nmeeting.',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  height: 1.4,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: QuickActionCard(
                    title: 'Create a\nChannel',
                    icon: Icons.add_circle_outline,
                    onTap: () => _handleQuickAction('Create a new channel'),
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: QuickActionCard(
                    title: 'Schedule a\nMeeting',
                    icon: Icons.calendar_today_outlined,
                    onTap: () => _handleQuickAction('Schedule a meeting'),
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: QuickActionCard(
              title: 'Assign a\nTask',
              icon: Icons.task_outlined,
              onTap: () => _handleQuickAction('Assign a task'),
              isDark: isDark,
              isFullWidth: true,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Projects',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.lightText,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _projects.length,
                        itemBuilder: (context, index) {
                          final project = _projects[index];
                          return ProjectCard(project: project, isDark: isDark);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -10),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promptController,
                    style: TextStyle(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter a prompt here',
                      hintStyle: TextStyle(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                      filled: true,
                      fillColor: isDark
                          ? AppColors.darkBackground
                          : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    onSubmitted: (text) {
                      if (text.trim().isNotEmpty) {
                        _handleTextCommand(text.trim());
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: _toggleVoiceRecording,
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _isListening ? _pulseAnimation.value : 1.0,
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: _isListening
                                  ? [AppColors.error, AppColors.warning]
                                  : [AppColors.primary, AppColors.secondary],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (_isListening
                                            ? AppColors.error
                                            : AppColors.primary)
                                        .withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            _isListening ? Icons.stop : Icons.mic,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleQuickAction(String action) {
    _handleTextCommand(action);
  }

  void _handleTextCommand(String command) {
    setState(() {
      _isProcessing = true;
    });
    _promptController.clear();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        _showCommandResult(command);
      }
    });
  }

  void _toggleVoiceRecording() {
    setState(() {
      _isListening = !_isListening;
    });
    if (_isListening) {
      _pulseController.repeat(reverse: true);
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _isListening) {
          _toggleVoiceRecording();
          _handleTextCommand('Create a new project for mobile app development');
        }
      });
    } else {
      _pulseController.stop();
    }
  }

  void _showCommandResult(String command) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Command Processed'),
        content: Text(
          'Processing: "$command"\n\nAI is analyzing your request and will create the necessary workflows.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
