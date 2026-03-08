import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/app_colors.dart';
import 'constants/app_constants.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/shell/app_shell.dart';
import 'screens/timeline/timeline_screen.dart';
import 'screens/bluetooth/bluetooth_screen.dart';
import 'screens/monitor/monitor_screen.dart';
import 'screens/graphs/graphs_screen.dart';
import 'screens/alerts/alerts_screen.dart';
import 'screens/midwives/midwives_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/shop/shop_screen.dart';
import 'screens/history/logs_history_screen.dart';
import 'screens/chatbot/chatbot_screen.dart';
import 'services/auth_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MamacitaApp());
}

class MamacitaApp extends StatelessWidget {
  const MamacitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Mamaconnect',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (_) => const SplashScreen(),
          AppRoutes.login: (_) => const AuthScreen(),
          AppRoutes.register: (_) => const RegisterScreen(),
          AppRoutes.onboarding: (_) => const OnboardingScreen(),
          AppRoutes.home: (_) => const AppShell(),
          '/timeline': (_) => const TimelineScreen(),
          '/bluetooth': (_) => const BluetoothScreen(),
          '/monitor': (_) => const MonitorScreen(),
          '/graphs': (_) =>
              const GraphsScreen(heartbeatHistory: [140, 142, 138, 145]),
          '/alerts': (_) => const AlertsScreen(),
          '/midwives': (_) => const MidwivesScreen(),
          '/profile': (_) => const ProfileScreen(),
          '/shop': (_) => const ShopScreen(),
          '/logs-history': (_) => const LogsHistoryScreen(),
          '/chatbot': (_) => const ChatbotScreen(),
          '/medicines': (_) =>
              const PlaceholderRouteScreen(title: 'Safe Medicines'),
          '/hospitals': (_) =>
              const PlaceholderRouteScreen(title: 'Hospitals Nearby'),
          '/symptoms': (_) =>
              const PlaceholderRouteScreen(title: 'Symptoms Tracker'),
          '/diets': (_) =>
              const PlaceholderRouteScreen(title: 'Recommended Diets'),
          '/workouts': (_) =>
              const PlaceholderRouteScreen(title: 'Workout Plans'),
        },
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.background,
      ),
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textDark),
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

class PlaceholderRouteScreen extends StatelessWidget {
  final String title;

  const PlaceholderRouteScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title - Coming Soon',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
