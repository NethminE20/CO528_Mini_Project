import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../config/theme.dart';
import '../services/api_service.dart';
import '../widgets/shared_widgets.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  List<dynamic> _jobs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    try {
      final data = await ApiService.getJobs();
      setState(() {
        _jobs = data;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  void _showCreateEditDialog([Map<String, dynamic>? job]) {
    final titleController = TextEditingController(text: job?['title'] ?? '');
    final companyController =
        TextEditingController(text: job?['company'] ?? '');
    final descController =
        TextEditingController(text: job?['description'] ?? '');
    final isEditing = job != null;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 520),
          padding: const EdgeInsets.all(28),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Edit Job' : 'Create Job',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 20),
                _buildField('Title', titleController, 'Job title'),
                const SizedBox(height: 14),
                _buildField('Company', companyController, 'Company name'),
                const SizedBox(height: 14),
                _buildField('Description', descController, 'Job description',
                    maxLines: 4),
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
                          'company': companyController.text.trim(),
                          'description': descController.text.trim(),
                        };
                        if (data['title']!.isEmpty) return;
                        try {
                          if (isEditing) {
                            await ApiService.updateJob(job['_id'], data);
                            Fluttertoast.showToast(
                              msg: 'Job updated successfully',
                              backgroundColor: AppColors.success,
                            );
                          } else {
                            await ApiService.createJob(data);
                            Fluttertoast.showToast(
                              msg: 'Job created successfully',
                              backgroundColor: AppColors.success,
                            );
                          }
                          if (ctx.mounted) Navigator.pop(ctx);
                          _fetchJobs();
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

  Widget _buildField(
      String label, TextEditingController controller, String hint,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: inputDecoration(hint),
        ),
      ],
    );
  }

  Future<void> _deleteJob(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this job?'),
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
      await ApiService.deleteJob(id);
      Fluttertoast.showToast(
          msg: 'Job deleted', backgroundColor: AppColors.success);
      _fetchJobs();
    } catch (_) {
      Fluttertoast.showToast(
          msg: 'Delete failed', backgroundColor: AppColors.danger);
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
                'Jobs',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                  letterSpacing: -0.5,
                ),
              ),
              GradientButton(
                label: 'New Job',
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
              : _jobs.isEmpty
                  ? const Center(
                      child: Text('No jobs yet.',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 16)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _jobs.length,
                      itemBuilder: (context, index) {
                        final j = _jobs[index];
                        return _JobCard(
                          job: j,
                          onEdit: () => _showCreateEditDialog(j),
                          onDelete: () => _deleteJob(j['_id']),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

class _JobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _JobCard({
    required this.job,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
              job['title'] ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.business,
                    size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  job['company'] ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _truncate(job['description'] ?? '', 120),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textMuted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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

  String _truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}…';
  }
}
