import 'package:flutter/material.dart';
import '../../../models/user.dart';

class ChannelMembers extends StatelessWidget {
  final List<User> members;
  final Function(User)? onMemberTap;

  const ChannelMembers({
    super.key,
    required this.members,
    this.onMemberTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Members (${members.length})',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    child: Text(
                      member.name.isNotEmpty ? member.name[0].toUpperCase() : 'U',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(member.name),
                  subtitle: Text(member.email),
                  trailing: member.isOnline
                      ? Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                  onTap: onMemberTap != null ? () => onMemberTap!(member) : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
