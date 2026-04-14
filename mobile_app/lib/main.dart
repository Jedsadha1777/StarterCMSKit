import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'services/connectivity_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/articles_screen.dart';
import 'screens/report_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ConnectivityService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider.value(value: ConnectivityService()),
      ],
      child: MaterialApp(
        title: 'User App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFc4193c),
            primary: const Color(0xFFc4193c),
            onPrimary: Colors.white,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFc4193c),
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFc4193c),
              foregroundColor: Colors.white,
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFFc4193c),
            foregroundColor: Colors.white,
          ),
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Color(0xFFc4193c),
          ),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        builder: (context, child) {
          return Column(
            children: [
              Consumer<ConnectivityService>(
                builder: (context, connectivity, _) {
                  if (connectivity.isOnline) return const SizedBox.shrink();
                  return Material(
                    child: Container(
                      width: double.infinity,
                      color: Colors.orange.shade800,
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 4,
                        bottom: 4,
                      ),
                      child: const Text(
                        'Offline — กำลังใช้ข้อมูลที่บันทึกไว้',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
              Expanded(child: child!),
            ],
          );
        },
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/articles': (context) => const ArticlesScreen(),
          '/report': (context) => const ReportScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return;

    try {
      await context.read<AuthProvider>().checkAuth();

      if (mounted) {
        final isAuth = context.read<AuthProvider>().isAuthenticated;
        Navigator.pushReplacementNamed(
          context,
          isAuth ? '/home' : '/login',
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 80,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Loading...',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
