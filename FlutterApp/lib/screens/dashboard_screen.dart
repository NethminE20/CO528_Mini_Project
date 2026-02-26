import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';

class _DashCard {
  final String label;
  final String desc;
  final IconData icon;
  final String route;
  final LinearGradient gradient;

  const _DashCard({
    required this.label,
    required this.desc,
    required this.icon,
    required this.route,
    required this.gradient,
  });
}

final _cards = [
  _DashCard(
    label: 'Posts',
    desc: 'View & create posts',
    icon: Icons.article_outlined,
    route: '/posts',
    gradient: const LinearGradient(
      colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  _DashCard(
    label: 'Jobs',
    desc: 'Browse job listings',
    icon: Icons.work_outline,
    route: '/jobs',
    gradient: const LinearGradient(
      colors: [Color(0xFF10B981), Color(0xFF34D399)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  _DashCard(
    label: 'Events',
    desc: 'Upcoming events & RSVP',
    icon: Icons.event_outlined,
    route: '/events',
    gradient: const LinearGradient(
      colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  _DashCard(
    label: 'Chat',
    desc: 'Real-time messaging',
    icon: Icons.chat_bubble_outline,
    route: '/messaging',
    gradient: const LinearGradient(
      colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  _DashCard(
    label: 'Analytics',
    desc: 'Platform insights',
    icon: Icons.bar_chart_outlined,
    route: '/analytics',
    gradient: const LinearGradient(
      colors: [Color(0xFF06B6D4), Color(0xFF67E8F9)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  _DashCard(
    label: 'Notifications',
    desc: 'Stay updated',
    icon: Icons.notifications_outlined,
    route: '/notifications',
    gradient: const LinearGradient(
      colors: [Color(0xFFEF4444), Color(0xFFF87171)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back${user?['name'] != null ? ', ${user!['name']}' : ''} \u{1F44B}',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.text,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'DECP Platform — Department of Computer Engineering Community Portal',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 28),

          // Grid of cards
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  return _DashboardCard(card: _cards[index], index: index);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final _DashCard card;
  final int index;

  const _DashboardCard({required this.card, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + index * 80),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pushReplacementNamed(context, card.route),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.sm,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: card.gradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color:
                            card.gradient.colors.first.withValues(alpha: 0.3),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(card.icon, size: 24, color: Colors.white),
                ),
                const SizedBox(height: 14),
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.brandGradient.createShader(bounds),
                  child: Text(
                    card.label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  card.desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
