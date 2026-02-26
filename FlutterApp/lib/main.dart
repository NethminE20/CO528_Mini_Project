import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'config/theme.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'widgets/app_layout.dart';
import 'screens/dashboard_screen.dart';
import 'screens/posts_screen.dart';
import 'screens/jobs_screen.dart';
import 'screens/events_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/messaging_screen.dart';
import 'screens/notifications_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider()..tryAutoLogin(),
      child: const DECPApp(),
    ),
  );
}

class DECPApp extends StatelessWidget {
  const DECPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DECP Platform',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.interTextTheme(),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.text,
          elevation: 0,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
      },
      onGenerateRoute: (settings) {
        // Protected routes wrapped in AppLayout
        final protectedRoutes = <String, Widget>{
          '/': const DashboardScreen(),
          '/posts': const PostsScreen(),
          '/jobs': const JobsScreen(),
          '/events': const EventsScreen(),
          '/analytics': const AnalyticsScreen(),
          '/messaging': const MessagingScreen(),
          '/notifications': const NotificationsScreen(),
        };

        if (protectedRoutes.containsKey(settings.name)) {
          return MaterialPageRoute(
            builder:
                (_) => AppLayout(
                  currentRoute: settings.name!,
                  child: protectedRoutes[settings.name]!,
                ),
          );
        }
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      },
    );
  }
}
