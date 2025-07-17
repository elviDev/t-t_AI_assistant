import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

/// Simple and modern message input widget with mention support
class MessageInput extends StatefulWidget {
  final TextEditingController controller;
  final bool isDark;
  final Function(String) onSendMessage;
  final VoidCallback? onAttachFile;
  final VoidCallback? onSendVoiceMessage;

  const MessageInput({
    super.key,
    required this.controller,
    required this.isDark,
    required this.onSendMessage,
    this.onAttachFile,
    this.onSendVoiceMessage,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  bool _hasText = false;
  bool _showMentionSuggestions = false;
  String _mentionQuery = '';
  int _mentionStart = -1;
  final FocusNode _focusNode = FocusNode();
  OverlayEntry? _overlayEntry;

  // Mock users for mentions
  final List<Map<String, String>> _users = [
    {'id': 'user1', 'name': 'Alice Johnson', 'avatar': 'AJ'},
    {'id': 'user2', 'name': 'Bob Smith', 'avatar': 'BS'},
    {'id': 'user3', 'name': 'Carol White', 'avatar': 'CW'},
    {'id': 'user4', 'name': 'David Brown', 'avatar': 'DB'},
    {'id': 'user5', 'name': 'Emma Wilson', 'avatar': 'EW'},
  ];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    _hideOverlay();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }

    // Check for mentions
    _checkForMentions();
  }

  void _checkForMentions() {
    final text = widget.controller.text;
    final cursorPos = widget.controller.selection.baseOffset;
    
    if (cursorPos < 0) return;

    // Find the last @ symbol before cursor
    int atPos = -1;
    for (int i = cursorPos - 1; i >= 0; i--) {
      if (text[i] == '@') {
        atPos = i;
        break;
      } else if (text[i] == ' ' || text[i] == '\n') {
        break;
      }
    }

    if (atPos >= 0) {
      // Extract mention query
      final mentionText = text.substring(atPos + 1, cursorPos);
      if (mentionText.length <= 20 && !mentionText.contains(' ')) {
        setState(() {
          _mentionQuery = mentionText.toLowerCase();
          _mentionStart = atPos;
          _showMentionSuggestions = true;
        });
        _showOverlay();
        return;
      }
    }

    // Hide suggestions if no valid mention
    if (_showMentionSuggestions) {
      setState(() {
        _showMentionSuggestions = false;
      });
      _hideOverlay();
    }
  }

  void _showOverlay() {
    _hideOverlay();
    
    _overlayEntry = OverlayEntry(
      builder: (context) => _buildMentionSuggestions(),
    );
    
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildMentionSuggestions() {
    final filteredUsers = _users.where((user) {
      return user['name']!.toLowerCase().contains(_mentionQuery);
    }).take(5).toList();

    if (filteredUsers.isEmpty) return const SizedBox.shrink();

    return Positioned(
      bottom: 120,
      left: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        color: widget.isDark ? const Color(0xFF2F2F2F) : Colors.white,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 200),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              return ListTile(
                dense: true,
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primaryColor,
                  child: Text(
                    user['avatar']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                title: Text(
                  user['name']!,
                  style: TextStyle(
                    color: widget.isDark ? Colors.white : const Color(0xFF2F2F2F),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () => _insertMention(user),
              );
            },
          ),
        ),
      ),
    );
  }

  void _insertMention(Map<String, String> user) {
    final text = widget.controller.text;
    final beforeMention = text.substring(0, _mentionStart);
    final afterCursor = text.substring(widget.controller.selection.baseOffset);
    
    final newText = '$beforeMention@${user['name']} $afterCursor';
    final newCursorPos = beforeMention.length + user['name']!.length + 2;
    
    widget.controller.text = newText;
    widget.controller.selection = TextSelection.collapsed(offset: newCursorPos);
    
    setState(() {
      _showMentionSuggestions = false;
    });
    _hideOverlay();
    
    // Show notification that user was mentioned
    _showMentionNotification(user['name']!);
  }

  void _showMentionNotification(String userName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.alternate_email,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text('$userName will be notified'),
          ],
        ),
        backgroundColor: AppColors.primaryColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppConstants.spacing16,
        AppConstants.spacing12,
        AppConstants.spacing16,
        AppConstants.spacing16 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: widget.isDark 
            ? const Color(0xFF1C1C1C)
            : Colors.white,
        border: Border(
          top: BorderSide(
            color: widget.isDark 
                ? const Color(0xFF2F2F2F)
                : const Color(0xFFE5E5E5),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Attach button
            _buildActionButton(
              icon: Icons.add,
              onPressed: widget.onAttachFile,
            ),
            
            const SizedBox(width: AppConstants.spacing12),
            
            // Text input with mention support
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: widget.isDark 
                      ? const Color(0xFF2F2F2F)
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  maxLines: null,
                  style: TextStyle(
                    color: widget.isDark ? Colors.white : const Color(0xFF2F2F2F),
                    fontFamily: AppConstants.fontFamily,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Message... (@ to mention)',
                    hintStyle: TextStyle(
                      color: widget.isDark 
                          ? Colors.white54
                          : Colors.grey[600],
                      fontFamily: AppConstants.fontFamily,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.spacing16,
                      vertical: AppConstants.spacing12,
                    ),
                  ),
                  onSubmitted: (text) {
                    if (text.trim().isNotEmpty) {
                      widget.onSendMessage(text);
                      _hideOverlay();
                    }
                  },
                ),
              ),
            ),
            
            const SizedBox(width: AppConstants.spacing12),
            
            // Send/Voice button
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _hasText 
                  ? _buildSendButton()
                  : _buildActionButton(
                      icon: Icons.mic,
                      onPressed: widget.onSendVoiceMessage,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build simple action button
  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: widget.isDark 
            ? const Color(0xFF2F2F2F)
            : const Color(0xFFF5F5F5),
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(18),
          child: Icon(
            icon,
            color: widget.isDark 
                ? Colors.white70
                : Colors.grey[700],
            size: 20,
          ),
        ),
      ),
    );
  }

  /// Build send button
  Widget _buildSendButton() {
    return Container(
      key: const ValueKey('send'),
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (widget.controller.text.trim().isNotEmpty) {
              widget.onSendMessage(widget.controller.text);
              _hideOverlay();
            }
          },
          borderRadius: BorderRadius.circular(18),
          child: const Icon(
            Icons.arrow_upward,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
