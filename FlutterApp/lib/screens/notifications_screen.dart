import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../config/theme.dart';
import '../services/notification_service.dart';
import '../widgets/shared_widgets.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> _notifications = [];
  bool _loading = true;
  bool _showForm = false;
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _fetchNotifications() async {
    try {
      final data = await NotificationService.getNotifications();
      setState(() {
        _notifications = data;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _submitNotification() async {
    final title = _titleController.text.trim();
    final message = _messageController.text.trim();
    if (title.isEmpty || message.isEmpty) return;

    try {
      await NotificationService.createNotification({
        'title': title,
        'message': message,
      });
      Fluttertoast.showToast(
          msg: 'Notification sent!', backgroundColor: AppColors.success);
      _titleController.clear();
      _messageController.clear();
      setState(() => _showForm = false);
      _fetchNotifications();
    } catch (_) {
      Fluttertoast.showToast(
          msg: 'Failed to send notification',
          backgroundColor: AppColors.danger);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                  letterSpacing: -0.5,
                ),
              ),
              GradientButton(
                label: _showForm ? 'Cancel' : '+ Create',
                onPressed: () => setState(() => _showForm = !_showForm),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Create form
        if (_showForm)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'New Notification (Admin)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 14),
                const Text('Title',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text)),
                const SizedBox(height: 6),
                TextField(
                  controller: _titleController,
                  decoration: inputDecoration('Notification title'),
                ),
                const SizedBox(height: 14),
                const Text('Message',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text)),
                const SizedBox(height: 6),
                TextField(
                  controller: _messageController,
                  maxLines: 3,
                  decoration: inputDecoration('Notification message'),
                ),
                const SizedBox(height: 14),
                GradientButton(
                  label: 'Send Notification',
                  onPressed: _submitNotification,
                ),
              ],
            ),
          ),

        if (_showForm) const SizedBox(height: 16),

        // Notifications list
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _notifications.isEmpty
                  ? const Center(
                      child: Text('No notifications.',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 16)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _notifications.length,
                      itemBuilder: (context, index) {
                        final n = _notifications[index];
                        return _NotificationItem(notification: n);
                      },
                    ),
        ),
      ],
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final dynamic notification;

  const _NotificationItem({required this.notification});

  @override
  Widget build(BuildContext context) {
    final title = notification['title'] ?? 'Notification';
    final desc = notification['message'] ?? notification['body'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dot indicator
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.brandGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                if (desc.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
