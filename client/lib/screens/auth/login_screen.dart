// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../home/home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
    _LoginScreenState();
}

class _LoginScreenState extends
  State<LoginScreen>
  with SingleTickerProviderStateMixin {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool obscurePassword = true;
  String errorMessage = '';

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  static const String baseUrl =
  'http://10.0.2.2:5000/api';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please fill all fields!';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'email': emailController.text.trim(),
          'password': passwordController.text
        })
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final prefs =
          await SharedPreferences.getInstance();
        await prefs.setString(
          'token', data['token']);
        await prefs.setString(
          'name', data['name']);
        await prefs.setString(
          'email', data['email']);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                const HomeScreen()
            )
          );
        }
      } else {
        setState(() {
          errorMessage =
            data['message'] ?? 'Login failed!';
        });
      }

    } catch (e) {
      setState(() {
        errorMessage =
          'Connection error! Make sure server is running!';
      });
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7F4),
      body: Stack(
        children: [
          // Background decorative circles
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF174143)
                  .withOpacity(0.05)
              )
            )
          ),
          Positioned(
            top: 50,
            right: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF174143)
                  .withOpacity(0.05)
              )
            )
          ),
          Positioned(
            bottom: -30,
            right: -20,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF174143)
                  .withOpacity(0.05)
              )
            )
          ),
          Positioned(
            bottom: 100,
            left: -40,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF174143)
                  .withOpacity(0.05)
              )
            )
          ),

          // Leaf decorations top left
          Positioned(
            top: 60,
            left: -10,
            child: Transform.rotate(
              angle: -0.3,
              child: Icon(
                Icons.eco_rounded,
                size: 80,
                color: const Color(0xFF174143)
                  .withOpacity(0.12)
              )
            )
          ),

          // Leaf decorations bottom right
          Positioned(
            bottom: 60,
            right: -10,
            child: Transform.rotate(
              angle: 0.3,
              child: Icon(
                Icons.eco_rounded,
                size: 100,
                color: const Color(0xFF174143)
                  .withOpacity(0.12)
              )
            )
          ),

          // Main content
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),

                      // Logo
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF174143)
                                .withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                              offset: const Offset(0, 5)
                            )
                          ]
                        ),
                        child: Padding(
                          padding:
                            const EdgeInsets.all(8),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context,
                                error, stackTrace) {
                                return Container(
                                  decoration:
                                    const BoxDecoration(
                                      shape:
                                        BoxShape.circle,
                                      color: Color(
                                        0xFF174143)
                                    ),
                                  child: const Icon(
                                    Icons.park_rounded,
                                    color: Colors.white,
                                    size: 70
                                  )
                                );
                              }
                            )
                          )
                        )
                      ),

                      const SizedBox(height: 20),

                      // App name
                      const Text(
                        'MindBloom',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF174143),
                          letterSpacing: 1
                        )
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Your personal mental wellness\ncompanion',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF174143),
                          height: 1.5
                        )
                      ),

                      const SizedBox(height: 32),

                      // Login Card
                      Container(
                        padding:
                          const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                            BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF174143)
                                .withOpacity(0.08),
                              blurRadius: 30,
                              spreadRadius: 5,
                              offset: const Offset(0, 10)
                            )
                          ]
                        ),
                        child: Column(
                          crossAxisAlignment:
                            CrossAxisAlignment.start,
                          children: [
                            // Welcome text
                            const Text(
                              'Welcome Back! 👋',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight:
                                  FontWeight.bold,
                                color: Color(0xFF174143)
                              )
                            ),

                            const SizedBox(height: 6),

                            const Text(
                              'Login to continue your wellness journey',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                height: 1.4
                              )
                            ),

                            const SizedBox(height: 28),

                            // Email field
                            _buildTextField(
                              controller:
                                emailController,
                              label: 'Email Address',
                              hint: 'Email Address',
                              icon:
                                Icons.email_outlined,
                              keyboardType:
                                TextInputType
                                  .emailAddress
                            ),

                            const SizedBox(height: 16),

                            // Password field
                            _buildPasswordField(),

                            const SizedBox(height: 16),

                            // Error message
                            if (errorMessage.isNotEmpty)
                              Container(
                                width: double.infinity,
                                padding:
                                  const EdgeInsets
                                    .all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red
                                    .withOpacity(0.1),
                                  borderRadius:
                                    BorderRadius
                                      .circular(12),
                                  border: Border.all(
                                    color: Colors.red
                                      .withOpacity(0.3)
                                  )
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 18
                                    ),
                                    const SizedBox(
                                      width: 8),
                                    Expanded(
                                      child: Text(
                                        errorMessage,
                                        style:
                                          const TextStyle(
                                            color:
                                              Colors.red,
                                            fontSize: 13
                                          )
                                      )
                                    )
                                  ]
                                )
                              ),

                            const SizedBox(height: 24),

                            // Login button
                            SizedBox(
                              width: double.infinity,
                              height: 58,
                              child: ElevatedButton(
                                onPressed:
                                  isLoading
                                    ? null
                                    : login,
                                style: ElevatedButton
                                  .styleFrom(
                                    backgroundColor:
                                      const Color(
                                        0xFF174143),
                                    foregroundColor:
                                      Colors.white,
                                    elevation: 5,
                                    shadowColor:
                                      const Color(
                                        0xFF174143)
                                      .withOpacity(0.4),
                                    shape:
                                      RoundedRectangleBorder(
                                        borderRadius:
                                          BorderRadius
                                            .circular(30)
                                      )
                                  ),
                                child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                        MainAxisAlignment
                                          .center,
                                      children: [
                                        Text(
                                          'Login',
                                          style:
                                            TextStyle(
                                              fontSize: 18,
                                              fontWeight:
                                                FontWeight
                                                  .bold,
                                              letterSpacing:
                                                1
                                            )
                                        ),
                                        SizedBox(
                                          width: 8),
                                        Icon(Icons
                                          .arrow_forward_rounded)
                                      ]
                                    )
                              )
                            ),

                            const SizedBox(height: 20),

                            // Register link
                            Center(
                              child: Row(
                                mainAxisAlignment:
                                  MainAxisAlignment
                                    .center,
                                children: [
                                  const Text(
                                    "Don't have an account? ",
                                    style: TextStyle(
                                      color: Colors.grey
                                    )
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                            (context) =>
                                            const RegisterScreen()
                                        )
                                      );
                                    },
                                    child: const Text(
                                      'Register Now',
                                      style: TextStyle(
                                        color: Color(
                                          0xFF174143),
                                        fontWeight:
                                          FontWeight.bold,
                                        fontSize: 15
                                      )
                                    )
                                  )
                                ]
                              )
                            )
                          ]
                        )
                      ),

                      const SizedBox(height: 24),

                      // Security note
                      Row(
                        mainAxisAlignment:
                          MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.verified_user_rounded,
                            size: 16,
                            color: Color(0xFF174143)
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Your data is private & secure',
                            style: TextStyle(
                              color: Color(0xFF174143),
                              fontSize: 13
                            )
                          )
                        ]
                      ),

                      const SizedBox(height: 20)
                    ]
                  )
                )
              )
            )
          )
        ]
      )
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7F4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF174143)
            .withOpacity(0.15)
        )
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Color(0xFF174143)
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.grey
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF174143)
                .withOpacity(0.1),
              borderRadius:
                BorderRadius.circular(30)
            ),
            child: Icon(
              icon,
              color: const Color(0xFF174143),
              size: 20
            )
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16
          )
        )
      )
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7F4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF174143)
            .withOpacity(0.15)
        )
      ),
      child: TextField(
        controller: passwordController,
        obscureText: obscurePassword,
        style: const TextStyle(
          color: Color(0xFF174143)
        ),
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: const TextStyle(
            color: Colors.grey
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF174143)
                .withOpacity(0.1),
              borderRadius:
                BorderRadius.circular(30)
            ),
            child: const Icon(
              Icons.lock_outlined,
              color: Color(0xFF174143),
              size: 20
            )
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscurePassword
                ? Icons.visibility_off
                : Icons.visibility,
              color: Colors.grey
            ),
            onPressed: () {
              setState(() {
                obscurePassword = !obscurePassword;
              });
            }
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16
          )
        )
      )
    );
  }
}