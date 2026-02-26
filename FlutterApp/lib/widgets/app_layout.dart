import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';
import '../services/notification_service.dart';

/// Navigation item model
class _NavItem {
  final String label;
  final IconData icon;
  final String route;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.route,
  });
}

const List<_NavItem> _navItems = [
  _NavItem(label: 'Dashboard', icon: Icons.home_outlined, route: '/'),
  _NavItem(label: 'Posts', icon: Icons.article_outlined, route: '/posts'),
  _NavItem(label: 'Jobs', icon: Icons.work_outline, route: '/jobs'),
  _NavItem(label: 'Events', icon: Icons.event_outlined, route: '/events'),
  _NavItem(
      label: 'Analytics', icon: Icons.bar_chart_outlined, route: '/analytics'),
  _NavItem(
      label: 'Messaging', icon: Icons.chat_bubble_outline, route: '/messaging'),
  _NavItem(
      label: 'Notifications',
      icon: Icons.notifications_outlined,
      route: '/notifications'),
];

/// Main layout that wraps protected screens with a drawer sidebar + top bar
/// Mirrors the web app's Layout component
class AppLayout extends StatefulWidget {
  final String currentRoute;
  final Widget child;

  const AppLayout({
    super.key,
    required this.currentRoute,
    required this.child,
  });

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _notifCount = 0;

  @override
  void initState() {
    super.initState();
    _loadNotifCount();
  }

  Future<void> _loadNotifCount() async {
    try {
      final list = await NotificationService.getNotifications();
      if (mounted) setState(() => _notifCount = list.length);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      // Drawer for mobile, persistent sidebar for desktop
      drawer: isWide ? null : _buildDrawer(context, auth),
      body: Row(
        children: [
          // Permanent sidebar on wide screens
          if (isWide) _buildSidebar(context, auth),

          // Main content area
          Expanded(
            child: Column(
              children: [
                // Top bar
                _buildTopBar(context, user, isWide),
                // Page content
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Sidebar for wide screens (persistent like the web version)
  Widget _buildSidebar(BuildContext context, AuthProvider auth) {
    return Container(
      width: 260,
      decoration: const BoxDecoration(
        gradient: AppColors.sidebarGradient,
        border: Border(
          right: BorderSide(
            color: Color(0x0DFFFFFF),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Brand row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0x14FFFFFF),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.brandGradient.createShader(bounds),
                  child: const Text(
                    'DECP Platform',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Nav items
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Column(
                children: _navItems.map((item) {
                  final isActive = widget.currentRoute == item.route;
                  return _buildNavItem(context, item, isActive);
                }).toList(),
              ),
            ),
          ),

          // Logout button
          if (auth.isAuthenticated)
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.dangerGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ElevatedButton(
                    onPressed: () => _logout(context, auth),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Drawer for mobile screens
  Widget _buildDrawer(BuildContext context, AuthProvider auth) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(gradient: AppColors.sidebarGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Brand
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0x14FFFFFF), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppColors.brandGradient.createShader(bounds),
                      child: const Text(
                        'DECP Platform',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Nav items
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  child: Column(
                    children: _navItems.map((item) {
                      final isActive = widget.currentRoute == item.route;
                      return _buildNavItem(context, item, isActive,
                          closeDrawer: true);
                    }).toList(),
                  ),
                ),
              ),

              // Logout
              if (auth.isAuthenticated)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.dangerGradient,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        onPressed: () => _logout(context, auth),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, _NavItem item, bool isActive,
      {bool closeDrawer = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            if (closeDrawer) Navigator.pop(context);
            Navigator.pushReplacementNamed(context, item.route);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: isActive
                  ? const LinearGradient(
                      colors: [
                        Color(0x40636AF1), // rgba(99, 102, 241, 0.25)
                        Color(0x2606B6D4), // rgba(6, 182, 212, 0.15)
                      ],
                    )
                  : null,
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 20,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                // Active indicator bar
                if (isActive)
                  Container(
                    width: 3,
                    height: 20,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                Icon(
                  item.icon,
                  size: 20,
                  color: isActive ? Colors.white : const Color(0xFF94A3B8),
                ),
                const SizedBox(width: 12),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? Colors.white : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Top bar matching the web's .topbar
  Widget _buildTopBar(
      BuildContext context, Map<String, dynamic>? user, bool isWide) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        border: const Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Hamburger menu for mobile
          if (!isWide)
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu, color: AppColors.textMuted),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            ),
          const Spacer(),

          // Bell icon with badge
          GestureDetector(
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/notifications'),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_outlined,
                      size: 22, color: AppColors.textMuted),
                  if (_notifCount > 0)
                    Positioned(
                      top: -4,
                      right: -6,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEF4444), Color(0xFFF97316)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.danger.withValues(alpha: 0.4),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '$_notifCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),

          // User info chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.08),
                  AppColors.accent.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              user?['name'] ?? 'Guest',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context, AuthProvider auth) {
    auth.logout();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
