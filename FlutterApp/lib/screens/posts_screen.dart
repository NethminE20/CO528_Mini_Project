import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<dynamic> _posts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      final data = await ApiService.getPosts();
      setState(() {
        _posts = data;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  void _showCreateEditDialog([Map<String, dynamic>? post]) {
    final contentController =
        TextEditingController(text: post?['content'] ?? '');
    final isEditing = post != null;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 520),
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Edit Post' : 'Create Post',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Content',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: contentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write your post...',
                  hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: AppColors.border, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: AppColors.border, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 1.5),
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
                  _GradientButton(
                    label: isEditing ? 'Update' : 'Create',
                    onPressed: () async {
                      final content = contentController.text.trim();
                      if (content.isEmpty) return;
                      try {
                        if (isEditing) {
                          await ApiService.updatePost(
                              post['_id'], {'content': content});
                          Fluttertoast.showToast(
                            msg: 'Post updated successfully',
                            backgroundColor: AppColors.success,
                          );
                        } else {
                          final user = context.read<AuthProvider>().user;
                          await ApiService.createPost({
                            'content': content,
                            'userId': user?['email'] ?? 'anonymous',
                          });
                          Fluttertoast.showToast(
                            msg: 'Post created successfully',
                            backgroundColor: AppColors.success,
                          );
                        }
                        if (ctx.mounted) Navigator.pop(ctx);
                        _fetchPosts();
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
    );
  }

  Future<void> _deletePost(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this post?'),
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
      await ApiService.deletePost(id);
      Fluttertoast.showToast(
          msg: 'Post deleted', backgroundColor: AppColors.success);
      _fetchPosts();
    } catch (_) {
      Fluttertoast.showToast(
          msg: 'Delete failed', backgroundColor: AppColors.danger);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header row
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Posts',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text,
                  letterSpacing: -0.5,
                ),
              ),
              _GradientButton(
                label: 'New Post',
                icon: Icons.add,
                onPressed: () => _showCreateEditDialog(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Content
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _posts.isEmpty
                  ? const Center(
                      child: Text(
                        'No posts yet.',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _posts.length,
                      itemBuilder: (context, index) {
                        final p = _posts[index];
                        return _PostCard(
                          post: p,
                          onEdit: () => _showCreateEditDialog(p),
                          onDelete: () => _deletePost(p['_id']),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

class _PostCard extends StatelessWidget {
  final Map<String, dynamic> post;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PostCard({
    required this.post,
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
              post['content'] ?? '',
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.text,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person_outline,
                    size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  post['userId'] ?? 'Unknown',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.favorite_outline,
                    size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  '${post['likes'] ?? 0}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const Spacer(),
                _SmallOutlineButton(
                  label: 'Edit',
                  icon: Icons.edit_outlined,
                  color: AppColors.primary,
                  onPressed: onEdit,
                ),
                const SizedBox(width: 8),
                _SmallOutlineButton(
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

// ─── Shared Widgets ─────────────────────────────────────

class _GradientButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;

  const _GradientButton({
    required this.label,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null
            ? Icon(icon, size: 18, color: Colors.white)
            : const SizedBox.shrink(),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class _SmallOutlineButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _SmallOutlineButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 14, color: color),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: Size.zero,
      ),
    );
  }
}
