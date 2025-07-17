import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../providers/channel_provider.dart';
import '../../shared/widgets/voice_prompt_widget.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../models/channel.dart';
import 'widgets/channel_card.dart';
import 'widgets/channel_category_filter.dart';
import 'channel_detail_screen.dart';

/// Channels screen displaying all communication channels
class ChannelsScreen extends StatefulWidget {
  const ChannelsScreen({super.key});

  @override
  State<ChannelsScreen> createState() => _ChannelsScreenState();
}

class _ChannelsScreenState extends State<ChannelsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
            
            // Category filter
            _buildCategoryFilter(isDark),
            
            // Channels list
            Expanded(
              child: _buildChannelsList(isDark),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(isDark),
    );
  }

  /// Build app bar with search and filter actions
  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        'Channels',
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
        const SizedBox(width: AppConstants.spacing8),
      ],
    );
  }

  /// Build voice prompt section
  Widget _buildVoicePromptSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing16),
      child: const VoicePromptWidget(),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.3, end: 0);
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
          hintText: 'Search channels...',
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
          // Implement search functionality
        },
      ),
    ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.3, end: 0);
  }

  /// Build category filter
  Widget _buildCategoryFilter(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacing16),
      child: ChannelCategoryFilter(
        selectedCategory: _selectedCategory,
        onCategorySelected: (category) {
          setState(() {
            _selectedCategory = category;
          });
        },
        isDark: isDark,
      ),
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3, end: 0);
  }

  /// Build channels list
  Widget _buildChannelsList(bool isDark) {
    return Consumer<ChannelProvider>(
      builder: (context, channelProvider, child) {
        final filteredChannels = _getFilteredChannels(channelProvider.channels);
        
        if (filteredChannels.isEmpty) {
          return _buildEmptyState(isDark);
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(AppConstants.spacing16),
          itemCount: filteredChannels.length,
          itemBuilder: (context, index) {
            final channel = filteredChannels[index];
            return ChannelCard(
              channel: channel,
              isDark: isDark,
              onTap: () => _navigateToChannelDetail(channel),
            ).animate(delay: (index * 100).ms).fadeIn().slideX(begin: 0.3, end: 0);
          },
        );
      },
    );
  }

  /// Build empty state
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 64,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
          const SizedBox(height: AppConstants.spacing16),
          Text(
            'No channels found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
          const SizedBox(height: AppConstants.spacing8),
          Text(
            'Create your first channel to start collaborating',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              fontFamily: AppConstants.fontFamily,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0));
  }

  /// Build floating action button
  Widget _buildFloatingActionButton(bool isDark) {
    return FloatingActionButton.extended(
      onPressed: _showCreateChannelDialog,
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add_rounded),
      label: const Text(
        'Create Channel',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: AppConstants.fontFamily,
        ),
      ),
    ).animate().scale(delay: 1000.ms).then().shimmer(duration: 2000.ms);
  }

  /// Get filtered channels based on search and category
  List<Channel> _getFilteredChannels(List<Channel> channels) {
    var filtered = channels;
    
    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered.where((channel) => channel.category == _selectedCategory).toList();
    }
    
    // Filter by search
    final searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((channel) =>
          channel.name.toLowerCase().contains(searchQuery) ||
          channel.description.toLowerCase().contains(searchQuery)).toList();
    }
    
    return filtered;
  }

  /// Navigate to channel detail screen
  void _navigateToChannelDetail(Channel channel) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ChannelDetailScreen(channel: channel),
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

  /// Show create channel dialog
  void _showCreateChannelDialog() {
    showDialog(
      context: context,
      builder: (context) => const CreateChannelDialog(),
    );
  }

  /// Show filter dialog
  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const ChannelFilterBottomSheet(),
    );
  }
}

/// Create channel dialog widget
class CreateChannelDialog extends StatefulWidget {
  const CreateChannelDialog({super.key});

  @override
  State<CreateChannelDialog> createState() => _CreateChannelDialogState();
}

class _CreateChannelDialogState extends State<CreateChannelDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
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
        'Create New Channel',
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
            controller: _nameController,
            style: TextStyle(
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontFamily: AppConstants.fontFamily,
            ),
            decoration: InputDecoration(
              labelText: 'Channel Name',
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
          onPressed: _isCreating ? null : _createChannel,
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

  void _createChannel() async {
    if (_nameController.text.trim().isEmpty) return;
    
    setState(() {
      _isCreating = true;
    });
    
    // Simulate channel creation
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Channel "${_nameController.text}" created successfully!'),
          backgroundColor: AppColors.successColor,
        ),
      );
    }
  }
}

/// Channel filter bottom sheet
class ChannelFilterBottomSheet extends StatelessWidget {
  const ChannelFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppConstants.largeBorderRadius),
          topRight: Radius.circular(AppConstants.largeBorderRadius),
        ),
      ),
      padding: const EdgeInsets.all(AppConstants.spacing24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppConstants.spacing24),
          
          // Title
          Text(
            'Filter Channels',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkText : AppColors.lightText,
              fontFamily: AppConstants.fontFamily,
            ),
          ),
          const SizedBox(height: AppConstants.spacing24),
          
          // Filter options will be added here
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
