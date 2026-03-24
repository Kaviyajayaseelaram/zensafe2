enum ChatSender { user, assistant }

class ChatMessage {
  final String id;
  final ChatSender sender;
  final String content;
  final DateTime createdAt;

  const ChatMessage({
    required this.id,
    required this.sender,
    required this.content,
    required this.createdAt,
  });
}

