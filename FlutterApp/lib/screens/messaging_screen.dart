import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';
import '../services/socket_service.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SocketService.connect();

    SocketService.onReceiveMessage((data) {
      if (mounted) {
        setState(() {
          _messages.add({
            ...Map<String, dynamic>.from(data),
            'type': 'received',
          });
        });
        _scrollToBottom();
      }
    });
  }

  @override
  void dispose() {
    SocketService.offReceiveMessage();
    SocketService.disconnect();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final user = context.read<AuthProvider>().user;
    final senderName = user?['name'] ?? user?['email'] ?? 'Me';

    final payload = {
      'sender': senderName,
      'message': text,
      'timestamp': DateTime.now().toIso8601String(),
    };

    SocketService.sendMessage(payload);
    setState(() {
      _messages.add({...payload, 'type': 'sent'});
    });
    _textController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title
        const Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Messaging',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.text,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ),

        // Messages area
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.sm,
            ),
            child: _messages.isEmpty
                ? const Center(
                    child: Text(
                      'No messages yet. Start the conversation!',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isSent = msg['type'] == 'sent';

                      return _ChatBubble(
                        message: msg['message'] ?? '',
                        sender: msg['sender'] ?? '',
                        timestamp: msg['timestamp'] ?? '',
                        isSent: isSent,
                      );
                    },
                  ),
          ),
        ),

        // Input bar
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: InputDecoration(
                    hintText: 'Type a message…',
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide:
                          const BorderSide(color: AppColors.border, width: 1.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide:
                          const BorderSide(color: AppColors.border, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                          color: AppColors.primary, width: 1.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: _sendMessage,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      child: Text(
                        'Send',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String message;
  final String sender;
  final String timestamp;
  final bool isSent;

  const _ChatBubble({
    required this.message,
    required this.sender,
    required this.timestamp,
    required this.isSent,
  });

  @override
  Widget build(BuildContext context) {
    String formattedTime = '';
    try {
      final dt = DateTime.parse(timestamp);
      formattedTime =
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {}

    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSent
              ? AppColors.primaryGradient
              : const LinearGradient(
                  colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
                ),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isSent ? 18 : 6),
            bottomRight: Radius.circular(isSent ? 6 : 18),
          ),
          boxShadow: isSent
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                fontSize: 15,
                color: isSent ? Colors.white : AppColors.text,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$sender · $formattedTime',
              style: TextStyle(
                fontSize: 11,
                color: isSent
                    ? Colors.white.withValues(alpha: 0.65)
                    : AppColors.textMuted.withValues(alpha: 0.65),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
