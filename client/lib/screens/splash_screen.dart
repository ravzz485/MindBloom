// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
    _SplashScreenState();
}

class _SplashScreenState extends
  State<SplashScreen>
  with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut
    ));

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
              const WelcomeScreen()
          )
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D2B2D),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [
              Color(0xFF1A4A4D),
              Color(0xFF0D2B2D),
              Color(0xFF061A1B),
            ]
          )
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment:
                  MainAxisAlignment.center,
                children: [
                  // Glowing Logo
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [
                          Color(0xFF2A7A7E),
                          Color(0xFF174143),
                          Color(0xFF0D2B2D),
                        ]
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4DB6AC)
                            .withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 10
                        ),
                        BoxShadow(
                          color: const Color(0xFF80CBC4)
                            .withOpacity(0.3),
                          blurRadius: 60,
                          spreadRadius: 20
                        )
                      ]
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF4DB6AC)
                            .withOpacity(0.6),
                          width: 2
                        )
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context,
                            error, stackTrace) {
                            return const Center(
                              child: Text(
                                '🌳',
                                style: TextStyle(
                                  fontSize: 80
                                )
                              )
                            );
                          }
                        )
                      )
                    )
                  ),

                  const SizedBox(height: 32),

                  // App name
                  const Text(
                    'MindBloom',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2
                    )
                  ),

                  const SizedBox(height: 8),

                  // Divider line
                  Container(
                    width: 60,
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF4DB6AC),
                          Color(0xFF80CBC4),
                        ]
                      ),
                      borderRadius:
                        BorderRadius.circular(1)
                    )
                  ),

                  const SizedBox(height: 80),

                  // Loading
                  const SizedBox(
                    width: 35,
                    height: 35,
                    child: CircularProgressIndicator(
                      color: Color(0xFF4DB6AC),
                      strokeWidth: 2
                    )
                  ),
                ]
              )
            )
          )
        )
      )
    );
  }
}

// ─── Welcome Screen ───────────────────────────────

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() =>
    _WelcomeScreenState();
}

class _WelcomeScreenState extends
  State<WelcomeScreen>
  with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [
              Color(0xFF1A4A4D),
              Color(0xFF0D2B2D),
              Color(0xFF061A1B),
            ]
          )
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Glowing Logo
                    Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [
                            Color(0xFF2A7A7E),
                            Color(0xFF174143),
                            Color(0xFF0D2B2D),
                          ]
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF4DB6AC)
                              .withOpacity(0.5),
                            blurRadius: 30,
                            spreadRadius: 10
                          ),
                          BoxShadow(
                            color: const Color(
                              0xFF80CBC4)
                              .withOpacity(0.3),
                            blurRadius: 60,
                            spreadRadius: 20
                          )
                        ]
                      ),
                      child: Container(
                        margin:
                          const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(
                              0xFF4DB6AC)
                              .withOpacity(0.6),
                            width: 2
                          )
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context,
                              error, stackTrace) {
                              return const Center(
                                child: Text(
                                  '🌳',
                                  style: TextStyle(
                                    fontSize: 80
                                  )
                                )
                              );
                            }
                          )
                        )
                      )
                    ),

                    const SizedBox(height: 24),

                    // App name
                    const Text(
                      'MindBloom',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2
                      )
                    ),

                    const SizedBox(height: 8),

                    // Teal divider
                    Container(
                      width: 60,
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF4DB6AC),
                            Color(0xFF80CBC4),
                          ]
                        ),
                        borderRadius:
                          BorderRadius.circular(1)
                      )
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Your personal mental wellness\ncompanion',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white60,
                        height: 1.5
                      )
                    ),

                    const SizedBox(height: 32),

                    // Features
                    _buildFeatureCard(
                      Icons.psychology_rounded,
                      'Mental Health Assessment',
                      'Track your mental wellbeing'
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureCard(
                      Icons.bar_chart_rounded,
                      'Daily Check-In',
                      'Monitor your mood daily'
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureCard(
                      Icons.chat_bubble_rounded,
                      'AI Support Chat',
                      'Talk to your wellness assistant'
                    ),

                    const Spacer(),

                    // Get Started button
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                const LoginScreen()
                            )
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                            const Color(0xFF2A7A7E),
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shadowColor: const Color(
                            0xFF4DB6AC)
                            .withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                              BorderRadius.circular(30)
                          )
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient:
                              const LinearGradient(
                                colors: [
                                  Color(0xFF174143),
                                  Color(0xFF4DB6AC),
                                ]
                              ),
                            borderRadius:
                              BorderRadius.circular(30)
                          ),
                          child: const Row(
                            mainAxisAlignment:
                              MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.eco_rounded,
                                size: 22
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Get Started',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                    FontWeight.bold,
                                  letterSpacing: 1
                                )
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons
                                  .arrow_forward_rounded,
                                size: 22
                              )
                            ]
                          )
                        )
                      )
                    ),

                    const SizedBox(height: 16),

                    // Login link
                    Row(
                      mainAxisAlignment:
                        MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: Colors.white54
                          )
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                  const LoginScreen()
                              )
                            );
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Color(0xFF4DB6AC),
                              fontWeight:
                                FontWeight.bold,
                              fontSize: 15
                            )
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
      )
    );
  }

  Widget _buildFeatureCard(
    IconData icon,
    String title,
    String subtitle
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1)
        )
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF174143),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF4DB6AC)
                  .withOpacity(0.3)
              )
            ),
            child: Icon(
              icon,
              color: const Color(0xFF4DB6AC),
              size: 26
            )
          ),

          const SizedBox(width: 16),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment:
                CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  )
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 13
                  )
                )
              ]
            )
          ),

          // Arrow
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white30,
            size: 16
          )
        ]
      )
    );
  }
}