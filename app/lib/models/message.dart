/// Message model for chat functionality
enum MessageType {
  text,
  image,
  file,
  voice,
  system,
}

class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final List<String> attachments;
  final List<String> mentions;
  final String? replyToId;
  final bool isEdited;
  final DateTime? editedAt;
  final List<MessageReaction> reactions;

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.type,
    required this.timestamp,
    this.attachments = const [],
    this.mentions = const [],
    this.replyToId,
    this.isEdited = false,
    this.editedAt,
    this.reactions = const [],
  });

  Message copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    List<String>? attachments,
    List<String>? mentions,
    String? replyToId,
    bool? isEdited,
    DateTime? editedAt,
    List<MessageReaction>? reactions,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      attachments: attachments ?? this.attachments,
      mentions: mentions ?? this.mentions,
      replyToId: replyToId ?? this.replyToId,
      isEdited: isEdited ?? this.isEdited,
      editedAt: editedAt ?? this.editedAt,
      reactions: reactions ?? this.reactions,
    );
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      content: json['content'],
      type: MessageType.values[json['type']],
      timestamp: DateTime.parse(json['timestamp']),
      attachments: List<String>.from(json['attachments'] ?? []),
      mentions: List<String>.from(json['mentions'] ?? []),
      replyToId: json['replyToId'],
      isEdited: json['isEdited'] ?? false,
      editedAt: json['editedAt'] != null 
          ? DateTime.parse(json['editedAt'])
          : null,
      reactions: (json['reactions'] as List?)?.map((e) => MessageReaction.fromJson(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'content': content,
      'type': type.index,
      'timestamp': timestamp.toIso8601String(),
      'attachments': attachments,
      'mentions': mentions,
      'replyToId': replyToId,
      'isEdited': isEdited,
      'editedAt': editedAt?.toIso8601String(),
      'reactions': reactions.map((e) => e.toJson()).toList(),
    };
  }
}

class MessageReaction {
  final String emoji;
  final List<String> userIds;

  MessageReaction({
    required this.emoji,
    required this.userIds,
  });

  factory MessageReaction.fromJson(Map<String, dynamic> json) {
    return MessageReaction(
      emoji: json['emoji'],
      userIds: List<String>.from(json['userIds']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emoji': emoji,
      'userIds': userIds,
    };
  }
}
