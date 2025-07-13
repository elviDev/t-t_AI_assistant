import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../models/project.dart';
import '../../shared/widgets/custom_button.dart';
import 'widgets/project_card.dart';
import 'widgets/quick_action_card.dart';

/// Main home screen displaying projects and AI assistant interface
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  // Controllers and animations
  final TextEditingController _promptController = TextEditingController();
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  
  // State variables
  bool _isListening = false;

  // Sample projects data
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
    _initializeAnimations();
  }

  /// Initialize animations for the home screen
  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: AppConstants.pulseAnimationDuration,
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800), // Slightly faster animation
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

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
    
    return PopScope(
      canPop: false, // Prevent back navigation
      child: Scaffold(
        appBar: _buildAppBar(isDark),
        body: SafeArea(
          child: Column(
            children: [
              // Welcome subtitle
              _buildWelcomeSubtitle(isDark),
              
              const SizedBox(height: AppConstants.spacing32),
              
              // Quick actions
              _buildQuickActions(isDark),
              
              const SizedBox(height: AppConstants.spacing32),
          
              // Projects section
              Expanded(
                child: _buildProjectsSection(isDark),
              ),
              
              // AI input section
              _buildAIInputSection(isDark),
            ],
          ),
        ),
      ),
    );
  }

  /// Build app bar with user greeting and actions
  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // AI Avatar
          Container(
            width: AppConstants.iconButtonSize,
            height: AppConstants.iconButtonSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 20,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Greeting
          Text(
            'Hello Javier!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
        ],
      ),
      actions: [
        // Notifications
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
          onPressed: () => _handleNotifications(),
        ),
        
        const SizedBox(width: AppConstants.spacing8),
        
        // User Avatar
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.success,
          child: Icon(
            Icons.person,
            color: Colors.white,
            size: AppConstants.smallIconSize,
          ),
        ),
        
        const SizedBox(width: AppConstants.spacing16),
      ],
    );
  }

  /// Build welcome subtitle section
  Widget _buildWelcomeSubtitle(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing24),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Give any command from creating a\\ndocument to scheduling a\\nmeeting.',
          style: TextStyle(
            fontSize: 16,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            height: 1.4,
            fontFamily: AppConstants.fontFamily,
          ),
        ),
      ),
    );
  }

  /// Build quick actions section
  Widget _buildQuickActions(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing24),
      child: Column(
        children: [
          // First row of actions
          Row(
            children: [
              Expanded(
                child: QuickActionCard(
                  title: 'Create a\\nChannel',
                  icon: Icons.add_circle_outline,
                  onTap: () => _handleQuickAction('Create a new channel'),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: AppConstants.spacing16),
              Expanded(
                child: QuickActionCard(
                  title: 'Schedule a\\nMeeting',
                  icon: Icons.calendar_today_outlined,
                  onTap: () => _handleQuickAction('Schedule a meeting'),
                  isDark: isDark,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppConstants.spacing16),
          
          // Second row (full width action)
          QuickActionCard(
            title: 'Assign a\\nTask',
            icon: Icons.task_outlined,
            onTap: () => _handleQuickAction('Assign a task'),
            isDark: isDark,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  /// Build projects section
  Widget _buildProjectsSection(bool isDark) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            Text(
              'Recent Projects',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkText : AppColors.lightText,
                fontFamily: AppConstants.fontFamily,
              ),
            ),
            
            const SizedBox(height: AppConstants.spacing16),
            
            // Projects list
            Expanded(
              child: ListView.builder(
                itemCount: _projects.length,
                itemBuilder: (context, index) {
                  final project = _projects[index];
                  return ProjectCard(
                    project: project,
                    isDark: isDark,
                    onTap: () => _handleProjectTap(project),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build AI input section at bottom
  Widget _buildAIInputSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.largeBorderRadius),
          topRight: Radius.circular(AppConstants.largeBorderRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Text input
          Expanded(
            child: TextField(
              controller: _promptController,
              style: TextStyle(
                color: isDark ? AppColors.darkText : AppColors.lightText,
                fontFamily: AppConstants.fontFamily,
              ),
              decoration: InputDecoration(
                hintText: 'Enter a prompt here',
                hintStyle: TextStyle(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  fontFamily: AppConstants.fontFamily,
                ),
                filled: true,
                fillColor: isDark ? AppColors.darkBackground : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
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
          
          const SizedBox(width: AppConstants.spacing16),
          
          // Voice recording button
          GestureDetector(
            onTap: _toggleVoiceRecording,
            child: GradientFloatingActionButton(
              onPressed: _toggleVoiceRecording,
              icon: _isListening ? Icons.stop : Icons.mic,
              gradient: _isListening ? AppColors.errorGradient : AppColors.primaryGradient,
              isListening: _isListening,
              animation: _pulseAnimation,
            ),
          ),
        ],
      ),
    );
  }

  /// Handle quick action tap
  void _handleQuickAction(String action) {
    _handleTextCommand(action);
  }

  /// Handle project card tap
  void _handleProjectTap(Project project) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening project: ${project.title}'),
      ),
    );
  }

  /// Handle notifications button tap
  void _handleNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifications feature coming soon!'),
      ),
    );
  }

  /// Handle text command processing
  void _handleTextCommand(String command) {
    // Clear the input
    _promptController.clear();
    
    // Simulate AI processing
    Future.delayed(AppConstants.commandProcessingDuration, () {
      if (mounted) {
        // Show result dialog
        _showCommandResult(command);
      }
    });
  }

  /// Toggle voice recording state
  void _toggleVoiceRecording() {
    setState(() {
      _isListening = !_isListening;
    });
    
    if (_isListening) {
      _pulseController.repeat(reverse: true);
      // Simulate voice recording
      Future.delayed(AppConstants.voiceRecordingDuration, () {
        if (mounted && _isListening) {
          _toggleVoiceRecording();
          _handleTextCommand('Create a new project for mobile app development');
        }
      });
    } else {
      _pulseController.stop();
    }
  }

  /// Show command processing result
  void _showCommandResult(String command) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Command Processed'),
        content: Text(
          'Processing: "$command"\\n\\nAI is analyzing your request and will create the necessary workflows.',
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
