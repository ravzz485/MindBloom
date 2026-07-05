// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
    _RegisterScreenState();
}

class _RegisterScreenState extends
  State<RegisterScreen>
  with SingleTickerProviderStateMixin {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController =
    TextEditingController();
  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      setState(() {
        errorMessage = 'Please fill all fields!';
      });
      return;
    }

    if (passwordController.text !=
        confirmPasswordController.text) {
      setState(() {
        errorMessage = 'Passwords do not match!';
      });
      return;
    }

    if (passwordController.text.length < 6) {
      setState(() {
        errorMessage =
          'Password must be at least 6 characters!';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text
        })
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout!');
        }
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '✅ Account created successfully!'
              ),
              backgroundColor: Color(0xFF174143)
            )
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                const LoginScreen()
            )
          );
        }
      } else {
        setState(() {
          errorMessage =
            data['message'] ?? 'Registration failed!';
        });
      }

    } catch (e) {
      setState(() {
        errorMessage =
          'Error: ${e.toString()}';
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

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Logo
                      Container(
                        width: 100,
                        height: 100,
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
                                    size: 50
                                  )
                                );
                              }
                            )
                          )
                        )
                      ),

                      const SizedBox(height: 16),

                      const Text(
                        'MindBloom',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF174143),
                          letterSpacing: 1
                        )
                      ),

                      const SizedBox(height: 24),

                      // Register Card
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
                            const Text(
                              'Create Account! 🌱',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight:
                                  FontWeight.bold,
                                color: Color(0xFF174143)
                              )
                            ),

                            const SizedBox(height: 6),

                            const Text(
                              'Start your wellness journey today',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey
                              )
                            ),

                            const SizedBox(height: 24),

                            _buildTextField(
                              controller: nameController,
                              hint: 'Full Name',
                              icon: Icons.person_outlined
                            ),

                            const SizedBox(height: 14),

                            _buildTextField(
                              controller: emailController,
                              hint: 'Email Address',
                              icon: Icons.email_outlined,
                              keyboardType:
                                TextInputType.emailAddress
                            ),

                            const SizedBox(height: 14),

                            _buildPasswordField(
                              controller:
                                passwordController,
                              hint: 'Password',
                              obscure: obscurePassword,
                              onToggle: () {
                                setState(() {
                                  obscurePassword =
                                    !obscurePassword;
                                });
                              }
                            ),

                            const SizedBox(height: 14),

                            _buildPasswordField(
                              controller:
                                confirmPasswordController,
                              hint: 'Confirm Password',
                              obscure:
                                obscureConfirmPassword,
                              onToggle: () {
                                setState(() {
                                  obscureConfirmPassword =
                                    !obscureConfirmPassword;
                                });
                              }
                            ),

                            const SizedBox(height: 14),

                            // Error message
                            if (errorMessage.isNotEmpty)
                              Container(
                                width: double.infinity,
                                padding:
                                  const EdgeInsets.all(
                                    12),
                                decoration: BoxDecoration(
                                  color: Colors.red
                                    .withOpacity(0.1),
                                  borderRadius:
                                    BorderRadius.circular(
                                      12),
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

                            // Register button
                            SizedBox(
                              width: double.infinity,
                              height: 58,
                              child: ElevatedButton(
                                onPressed: isLoading
                                  ? null
                                  : register,
                                style: ElevatedButton
                                  .styleFrom(
                                    backgroundColor:
                                      const Color(
                                        0xFF174143),
                                    foregroundColor:
                                      Colors.white,
                                    elevation: 5,
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
                                          'Create Account',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight:
                                              FontWeight
                                                .bold
                                          )
                                        ),
                                        SizedBox(width: 8),
                                        Icon(Icons
                                          .arrow_forward_rounded)
                                      ]
                                    )
                              )
                            ),

                            const SizedBox(height: 20),

                            Center(
                              child: Row(
                                mainAxisAlignment:
                                  MainAxisAlignment
                                    .center,
                                children: [
                                  const Text(
                                    'Already have an account? ',
                                    style: TextStyle(
                                      color: Colors.grey
                                    )
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator
                                        .pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                              (context) =>
                                              const LoginScreen()
                                          )
                                        );
                                    },
                                    child: const Text(
                                      'Login',
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

                      Row(
                        mainAxisAlignment:
                          MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.verified_user_rounded,
                            size: 16,
                            color: Color(0xFF174143)
                          ),
                          SizedBox(width: 6),
                          Text(
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
              borderRadius: BorderRadius.circular(30)
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
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
        obscureText: obscure,
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
              borderRadius: BorderRadius.circular(30)
            ),
            child: const Icon(
              Icons.lock_outlined,
              color: Color(0xFF174143),
              size: 20
            )
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscure
                ? Icons.visibility_off
                : Icons.visibility,
              color: Colors.grey
            ),
            onPressed: onToggle
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