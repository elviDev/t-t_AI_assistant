import 'package:flutter/foundation.dart';
import '../models/channel.dart';
import '../models/message.dart';

/// Provider for managing channels and channel-related operations
class ChannelProvider with ChangeNotifier {
  // Private variables
  List<Channel> _channels = [];
  Channel? _selectedChannel;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Channel> get channels => List.unmodifiable(_channels);
  Channel? get selectedChannel => _selectedChannel;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Messages storage
  final Map<String, List<Message>> _channelMessages = {};

  /// Initialize with sample data
  ChannelProvider() {
    _initializeSampleData();
  }

  /// Initialize with sample channels
  void _initializeSampleData() {
    _channels = [
      Channel(
        id: '1',
        name: 'Mobile App Development',
        description: 'Developing a new mobile application for client project',
        category: 'Development',
        memberIds: ['user1', 'user2', 'user3'],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        lastActivity: DateTime.now().subtract(const Duration(hours: 2)),
        isPrivate: false,
        tags: ['mobile', 'flutter', 'ios', 'android'],
      ),
      Channel(
        id: '2',
        name: 'Marketing Campaign',
        description: 'Planning and executing Q4 marketing campaign',
        category: 'Marketing',
        memberIds: ['user1', 'user4', 'user5'],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        lastActivity: DateTime.now().subtract(const Duration(minutes: 30)),
        isPrivate: false,
        tags: ['marketing', 'campaign', 'strategy'],
      ),
      Channel(
        id: '3',
        name: 'Team Building Event',
        description: 'Organizing the annual team building event',
        category: 'Events',
        memberIds: ['user2', 'user3', 'user6'],
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        lastActivity: DateTime.now().subtract(const Duration(minutes: 5)),
        isPrivate: false,
        tags: ['team', 'event', 'planning'],
      ),
      Channel(
        id: '4',
        name: 'Budget Review',
        description: 'Quarterly budget review and planning',
        category: 'Finance',
        memberIds: ['user1', 'user7'],
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        lastActivity: DateTime.now().subtract(const Duration(minutes: 15)),
        isPrivate: true,
        tags: ['budget', 'finance', 'quarterly'],
      ),
    ];
    notifyListeners();
  }

  /// Create a new channel
  Future<void> createChannel({
    required String name,
    required String description,
    required String category,
    List<String> memberIds = const [],
    List<String> tags = const [],
    bool isPrivate = false,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      final newChannel = Channel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        description: description,
        category: category,
        memberIds: memberIds,
        createdAt: DateTime.now(),
        lastActivity: DateTime.now(),
        isPrivate: isPrivate,
        tags: tags,
      );

      _channels.insert(0, newChannel);
      notifyListeners();
    } catch (e) {
      _setError('Failed to create channel: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Update a channel
  Future<void> updateChannel(Channel updatedChannel) async {
    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final index = _channels.indexWhere((c) => c.id == updatedChannel.id);
      if (index != -1) {
        _channels[index] = updatedChannel;
        
        if (_selectedChannel?.id == updatedChannel.id) {
          _selectedChannel = updatedChannel;
        }
        
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to update channel: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Delete a channel
  Future<void> deleteChannel(String channelId) async {
    _setLoading(true);
    _setError(null);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      _channels.removeWhere((c) => c.id == channelId);
      
      if (_selectedChannel?.id == channelId) {
        _selectedChannel = null;
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete channel: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Select a channel
  void selectChannel(Channel channel) {
    _selectedChannel = channel;
    notifyListeners();
  }

  /// Add member to channel
  Future<void> addMemberToChannel(String channelId, String userId) async {
    try {
      final channelIndex = _channels.indexWhere((c) => c.id == channelId);
      if (channelIndex != -1) {
        final channel = _channels[channelIndex];
        if (!channel.memberIds.contains(userId)) {
          final updatedMemberIds = List<String>.from(channel.memberIds)..add(userId);
          final updatedChannel = channel.copyWith(memberIds: updatedMemberIds);
          _channels[channelIndex] = updatedChannel;
          
          if (_selectedChannel?.id == channelId) {
            _selectedChannel = updatedChannel;
          }
          
          notifyListeners();
        }
      }
    } catch (e) {
      _setError('Failed to add member: $e');
    }
  }

  /// Remove member from channel
  Future<void> removeMemberFromChannel(String channelId, String userId) async {
    try {
      final channelIndex = _channels.indexWhere((c) => c.id == channelId);
      if (channelIndex != -1) {
        final channel = _channels[channelIndex];
        final updatedMemberIds = List<String>.from(channel.memberIds)..remove(userId);
        final updatedChannel = channel.copyWith(memberIds: updatedMemberIds);
        _channels[channelIndex] = updatedChannel;
        
        if (_selectedChannel?.id == channelId) {
          _selectedChannel = updatedChannel;
        }
        
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to remove member: $e');
    }
  }

  /// Get channels by category
  List<Channel> getChannelsByCategory(String category) {
    if (category == 'All') return _channels;
    return _channels.where((channel) => channel.category == category).toList();
  }

  /// Search channels
  List<Channel> searchChannels(String query) {
    if (query.isEmpty) return _channels;
    
    final lowercaseQuery = query.toLowerCase();
    return _channels.where((channel) =>
        channel.name.toLowerCase().contains(lowercaseQuery) ||
        channel.description.toLowerCase().contains(lowercaseQuery) ||
        channel.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery))).toList();
  }

  /// Get available categories
  List<String> get availableCategories {
    final categories = _channels.map((channel) => channel.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  /// Update channel last activity
  void updateChannelActivity(String channelId) {
    final channelIndex = _channels.indexWhere((c) => c.id == channelId);
    if (channelIndex != -1) {
      final channel = _channels[channelIndex];
      final updatedChannel = channel.copyWith(lastActivity: DateTime.now());
      _channels[channelIndex] = updatedChannel;
      
      if (_selectedChannel?.id == channelId) {
        _selectedChannel = updatedChannel;
      }
      
      notifyListeners();
    }
  }

  /// AI-powered channel creation
  Future<void> createChannelWithAI({
    required String prompt,
    List<String> memberIds = const [],
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      // Simulate AI processing
      await Future.delayed(const Duration(seconds: 3));

      // AI-generated channel details based on prompt
      final aiGeneratedDetails = _generateChannelDetailsFromPrompt(prompt);
      
      await createChannel(
        name: aiGeneratedDetails['name']!,
        description: aiGeneratedDetails['description']!,
        category: aiGeneratedDetails['category']!,
        memberIds: memberIds,
        tags: aiGeneratedDetails['tags']!.split(','),
      );
    } catch (e) {
      _setError('Failed to create channel with AI: $e');
    }
  }

  /// Generate channel details from AI prompt
  Map<String, String> _generateChannelDetailsFromPrompt(String prompt) {
    // Simplified AI simulation - in real app, this would call an AI service
    final lowercasePrompt = prompt.toLowerCase();
    
    String name, description, category, tags;
    
    if (lowercasePrompt.contains('mobile') || lowercasePrompt.contains('app')) {
      name = 'Mobile App Project';
      description = 'Mobile application development and planning';
      category = 'Development';
      tags = 'mobile,app,development,flutter';
    } else if (lowercasePrompt.contains('marketing') || lowercasePrompt.contains('campaign')) {
      name = 'Marketing Initiative';
      description = 'Marketing campaign planning and execution';
      category = 'Marketing';
      tags = 'marketing,campaign,strategy,promotion';
    } else if (lowercasePrompt.contains('meeting') || lowercasePrompt.contains('schedule')) {
      name = 'Team Meeting';
      description = 'Team coordination and meeting planning';
      category = 'Meetings';
      tags = 'meeting,schedule,team,coordination';
    } else if (lowercasePrompt.contains('design') || lowercasePrompt.contains('ui')) {
      name = 'Design Project';
      description = 'UI/UX design and creative planning';
      category = 'Design';
      tags = 'design,ui,ux,creative';
    } else {
      name = 'General Project';
      description = 'General project planning and collaboration';
      category = 'General';
      tags = 'project,planning,collaboration';
    }
    
    return {
      'name': name,
      'description': description,
      'category': category,
      'tags': tags,
    };
  }

  /// Set loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message
  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Message-related methods
  List<Message> getChannelMessages(String channelId) {
    return _channelMessages[channelId] ?? [];
  }

  void sendMessage(String channelId, String content, String senderId) {
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      senderId: senderId,
      senderName: 'User', // Default sender name
      timestamp: DateTime.now(),
      type: MessageType.text,
    );

    if (_channelMessages[channelId] == null) {
      _channelMessages[channelId] = [];
    }
    _channelMessages[channelId]!.add(message);
    notifyListeners();
  }
}
