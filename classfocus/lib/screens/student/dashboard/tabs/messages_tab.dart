// lib/screens/student/dashboard/tabs/messages_tab.dart
import 'package:flutter/material.dart';
import '../../../../theme/app_theme.dart';
import '../../messages/chat_screen.dart';

class MessagesTab extends StatelessWidget {
  MessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment),
            onPressed: () {
              // TODO: Implement new chat functionality
            },
            tooltip: 'New Chat',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _mockChats.length,
        itemBuilder: (context, index) {
          final chat = _mockChats[index];
          return _buildChatItem(context, chat);
        },
      ),
    );
  }

  Widget _buildChatItem(BuildContext context, ChatItem chat) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              userName: chat.name,
              avatarUrl: chat.avatarUrl,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
          // Avatar
          CircleAvatar(
            radius: 28,
            backgroundColor: AppTheme.primaryBlue.withOpacity(0.2),
            backgroundImage: chat.avatarUrl != null
                ? AssetImage(chat.avatarUrl!)
                : null,
            child: chat.avatarUrl == null
                ? Text(
                    chat.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          // Name and message
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      chat.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      chat.timestamp,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.secondaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  chat.lastMessage,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.secondaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Unread badge
          if (chat.hasUnread)
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: AppTheme.primaryBlue,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mock chat data
  final List<ChatItem> _mockChats = [
    ChatItem(
      name: 'Dr. Smith',
      lastMessage: 'Your quiz results are ready for review.',
      timestamp: '2m ago',
      hasUnread: true,
    ),
    ChatItem(
      name: 'Prof. Johnson',
      lastMessage: 'Great work on the Data Structures assignment!',
      timestamp: '1h ago',
      hasUnread: false,
    ),
    ChatItem(
      name: 'TA Maria',
      lastMessage: 'Office hours are tomorrow at 2 PM.',
      timestamp: '3h ago',
      hasUnread: false,
    ),
    ChatItem(
      name: 'Study Group',
      lastMessage: 'Meeting at the library at 4 PM',
      timestamp: '5h ago',
      hasUnread: true,
    ),
  ];
}

class ChatItem {
  final String name;
  final String lastMessage;
  final String timestamp;
  final bool hasUnread;
  final String? avatarUrl;

  ChatItem({
    required this.name,
    required this.lastMessage,
    required this.timestamp,
    this.hasUnread = false,
    this.avatarUrl,
  });
}

