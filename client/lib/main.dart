import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindBloom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF174143),
          primary: const Color(0xFF174143),
          secondary: const Color(0xFF1F5A5D),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF174143),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF174143),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16
            )
          )
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF174143),
              width: 2
            )
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        scaffoldBackgroundColor:
          const Color(0xFFF5F5F5),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() =>
    _AuthWrapperState();
}

class _AuthWrapperState extends
  State<AuthWrapper> {

  bool isLoading = true;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final prefs =
      await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    setState(() {
      isLoggedIn = token != null;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF174143),
        body: Center(
          child: Column(
            mainAxisAlignment:
              MainAxisAlignment.center,
            children: [
              Text(
                '🌱 MindBloom',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold
                )
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(
                color: Colors.white
              )
            ]
          )
        )
      );
    }

    return isLoggedIn
      ? const HomeScreen()
      : const LoginScreen();
  }
}