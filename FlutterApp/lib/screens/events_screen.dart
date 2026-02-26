import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../widgets/shared_widgets.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<dynamic> _events = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final data = await ApiService.getEvents();
      setState(() {
        _events = data;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  void _showCreateEditDialog([Map<String, dynamic>? event]) {
    final titleController = TextEditingController(text: event?['title'] ?? '');
    DateTime? selectedDate;
    if (event?['date'] != null) {
      try {
        selectedDate = DateTime.parse(event!['date']);
      } catch (_) {}
    }
    final isEditing = event != null;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 520),
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Edit Event' : 'Create Event',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Title',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text)),
                const SizedBox(height: 6),
                TextField(
                  controller: titleController,
                  decoration: inputDecoration('Event title'),
                ),
                const SizedBox(height: 14),
                const Text('Date',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text)),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: ctx,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) {
                      setDialogState(() => selectedDate = date);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border, width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Text(
                          selectedDate != null
                              ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                              : 'Select a date',
                          style: TextStyle(
                            color: selectedDate != null
                                ? AppColors.text
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.calendar_today,
                            size: 18, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 10),
                    GradientButton(
                      label: isEditing ? 'Update' : 'Create',
                      onPressed: () async {
                        final data = {
                          'title': titleController.text.trim(),
                          'date': selectedDate?.toIso8601String() ?? '',
                        };
                        if (data['title']!.isEmpty) return;
                        try {
                          if (isEditing) {
                            await ApiService.updateEvent(event['_id'], data);
                            Fluttertoast.showToast(
                              msg: 'Event updated successfully',
                              backgroundColor: AppColors.success,
                            );
                          } else {
                            await ApiService.createEvent(data);
                            Fluttertoast.showToast(
                              msg: 'Event created successfully',
                              backgroundColor: AppColors.success,
                            );
                          }
                          if (ctx.mounted) Navigator.pop(ctx);
                          _fetchEvents();
                        } catch (_) {
                          Fluttertoast.showToast(
                            msg: 'Operation failed',
                            backgroundColor: AppColors.danger,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteEvent(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this event?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child:
                const Text('Delete', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ApiService.deleteEvent(id);
      Fluttertoast.showToast(
          msg: 'Event deleted', backgroundColor: AppColors.success);
      _fetchEvents();
    } catch (_) {
      Fluttertoast.showToast(
          msg: 'Delete failed', backgroundColor: AppColors.danger);
    }
  }

  Future<void> _handleRsvp(String id) async {
    try {
      final user = context.read<AuthProvider>().user;
      await ApiService.rsvpEvent(id, {
        'userId': user?['email'] ?? 'anonymous',
      });
      Fluttertoast.showToast(
          msg: 'RSVP confirmed!', backgroundColor: AppColors.success);
      _fetchEvents();
    } catch (_) {
      Fluttertoast.showToast(
          msg: 'RSVP failed', backgroundColor: AppColors.danger);
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
                'Events',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                  letterSpacing: -0.5,
                ),
              ),
              GradientButton(
                label: 'New Event',
                icon: Icons.add,
                onPressed: () => _showCreateEditDialog(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _events.isEmpty
                  ? const Center(
                      child: Text('No events yet.',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 16)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _events.length,
                      itemBuilder: (context, index) {
                        final ev = _events[index];
                        return _EventCard(
                          event: ev,
                          onEdit: () => _showCreateEditDialog(ev),
                          onDelete: () => _deleteEvent(ev['_id']),
                          onRsvp: () => _handleRsvp(ev['_id']),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

class _EventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onRsvp;

  const _EventCard({
    required this.event,
    required this.onEdit,
    required this.onDelete,
    required this.onRsvp,
  });

  @override
  Widget build(BuildContext context) {
    String dateStr = '—';
    if (event['date'] != null) {
      try {
        dateStr =
            DateFormat('MMM d, yyyy').format(DateTime.parse(event['date']));
      } catch (_) {}
    }

    final rsvpCount =
        (event['rsvps'] is List) ? (event['rsvps'] as List).length : 0;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event['title'] ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.event, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(dateStr,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textMuted)),
                const SizedBox(width: 16),
                const Icon(Icons.people_outline,
                    size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text('$rsvpCount RSVPs',
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textMuted)),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SmallOutlineButton(
                  label: 'RSVP',
                  icon: Icons.check_circle_outline,
                  color: AppColors.success,
                  onPressed: onRsvp,
                ),
                const SizedBox(width: 8),
                SmallOutlineButton(
                  label: 'Edit',
                  icon: Icons.edit_outlined,
                  color: AppColors.primary,
                  onPressed: onEdit,
                ),
                const SizedBox(width: 8),
                SmallOutlineButton(
                  label: 'Delete',
                  icon: Icons.delete_outline,
                  color: AppColors.danger,
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
