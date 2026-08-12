import 'package:flutter/material.dart';
import 'package:taco_sales_insight/shared/app_colors.dart';
import 'package:taco_sales_insight/features/home/home_screen.dart';
import 'package:taco_sales_insight/features/history/history_screen.dart';
import 'package:taco_sales_insight/features/profile/profile_screen.dart';
import 'package:taco_sales_insight/features/report/select_outlet_screen.dart';
import 'package:taco_sales_insight/features/report/new_outlet_screen.dart';
import 'package:taco_sales_insight/features/report/input_mode_screen.dart';
import 'package:taco_sales_insight/features/report/voice_input_screen.dart';
import 'package:taco_sales_insight/features/report/processing_screen.dart';
import 'package:taco_sales_insight/features/report/ai_confirmation_screen.dart';
import 'package:taco_sales_insight/features/report/report_summary_screen.dart';
import 'package:taco_sales_insight/features/gamification/points_screen.dart';
import 'package:taco_sales_insight/features/gamification/badges_screen.dart';
import 'package:taco_sales_insight/features/gamification/streak_screen.dart';
import 'package:taco_sales_insight/features/gamification/leaderboard_screen.dart';
import 'package:taco_sales_insight/features/notifications/notifications_screen.dart';

void main() {
  runApp(const TacoSalesInsightApp());
}

class TacoSalesInsightApp extends StatelessWidget {
  const TacoSalesInsightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TACO Sales Insight',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: false,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          elevation: 4,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainNavigationScreen(),
        '/home': (context) => const MainNavigationScreen(initialIndex: 0),
        '/history': (context) => const MainNavigationScreen(initialIndex: 1),
        '/profile': (context) => const MainNavigationScreen(initialIndex: 2),
        '/report/select-outlet': (context) => const SelectOutletScreen(),
        '/report/new-outlet': (context) => const NewOutletScreen(),
        '/report/input-mode': (context) => const InputModeScreenWrapper(),
        '/report/voice-input': (context) => const VoiceInputScreenWrapper(),
        '/report/processing': (context) => const ProcessingScreenWrapper(),
        '/report/ai-confirmation': (context) => const AiConfirmationScreenWrapper(),
        '/report/summary': (context) => const ReportSummaryScreenWrapper(),
        '/profile/points': (context) => const PointsScreen(),
        '/profile/badges': (context) => const BadgesScreen(),
        '/profile/streak': (context) => const StreakScreen(),
        '/profile/leaderboard': (context) => const LeaderboardScreen(),
        '/notifications': (context) => const NotificationsScreen(),
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  const MainNavigationScreen({super.key, this.initialIndex = 0});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  static const List<Widget> _screens = [
    HomeScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  static const List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.history_outlined),
      activeIcon: Icon(Icons.history),
      label: 'History',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outlined),
      activeIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}