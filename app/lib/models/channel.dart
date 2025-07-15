/// Channel model representing a communication channel
class Channel {
  final String id;
  final String name;
  final String description;
  final String category;
  final List<String> memberIds; // Changed to use IDs instead of full User objects
  final DateTime createdAt;
  final DateTime lastActivity;
  final int messageCount;
  final int fileCount;
  final String? lastMessage;
  final bool isPrivate;
  final List<String> tags;

  Channel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.memberIds,
    required this.createdAt,
    required this.lastActivity,
    this.messageCount = 0,
    this.fileCount = 0,
    this.lastMessage,
    this.isPrivate = false,
    this.tags = const [],
  });

  // Getter for member count
  int get memberCount => memberIds.length;

  Channel copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    List<String>? memberIds,
    DateTime? createdAt,
    DateTime? lastActivity,
    int? messageCount,
    int? fileCount,
    String? lastMessage,
    bool? isPrivate,
    List<String>? tags,
  }) {
    return Channel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      memberIds: memberIds ?? this.memberIds,
      createdAt: createdAt ?? this.createdAt,
      lastActivity: lastActivity ?? this.lastActivity,
      messageCount: messageCount ?? this.messageCount,
      fileCount: fileCount ?? this.fileCount,
      lastMessage: lastMessage ?? this.lastMessage,
      isPrivate: isPrivate ?? this.isPrivate,
      tags: tags ?? this.tags,
    );
  }

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      memberIds: List<String>.from(json['memberIds'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      lastActivity: DateTime.parse(json['lastActivity']),
      messageCount: json['messageCount'] ?? 0,
      fileCount: json['fileCount'] ?? 0,
      lastMessage: json['lastMessage'],
      isPrivate: json['isPrivate'] ?? false,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'memberIds': memberIds,
      'createdAt': createdAt.toIso8601String(),
      'lastActivity': lastActivity.toIso8601String(),
      'messageCount': messageCount,
      'fileCount': fileCount,
      'lastMessage': lastMessage,
      'isPrivate': isPrivate,
      'tags': tags,
    };
  }
}