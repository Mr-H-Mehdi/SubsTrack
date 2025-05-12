import 'package:flutter/material.dart';
import 'package:labs/screens/LoginScreen.dart';
import 'package:labs/screens/SignupScreen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _titleSlideAnimation;
  late Animation<Offset> _buttonsSlideAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    // Logo scale animation
    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );
    
    // Fade animation for logos
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );
    
    // Slide animation for title
    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
      ),
    );
    
    // Slide animation for buttons
    _buttonsSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    
    // Start the animation
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
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 68),
            // Animated logo with scale effect
            ScaleTransition(
              scale: _logoScaleAnimation,
              child: const Center(
                child: Image(
                  image: AssetImage("assets/images/AppLogo.png"),
                ),
              ),
            ),
            // Animated title with slide effect
            SlideTransition(
              position: _titleSlideAnimation,
              child: const Padding(
                padding: EdgeInsets.all(32),
                child: Text(
                  "Substrack",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 64,
                  ),
                ),
              ),
            ),
            // Fade animation for service logos
            FadeTransition(
              opacity: _fadeAnimation,
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(92, 8, 68, 0),
                    child: Image(
                      image: AssetImage("assets/images/YTLogo.png"),
                    ),
                  ),
                  Image(
                    image: AssetImage("assets/images/SpotifyLogo.png"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 68),
            FadeTransition(
              opacity: _fadeAnimation,
              child: const Image(
                image: AssetImage("assets/images/NetflixLogo.png"),
              ),
            ),
            const SizedBox(height: 58),
            FadeTransition(
              opacity: _fadeAnimation,
              child: const Text(
                "Welcome to SubsTrack!\nLet's manage your all Subscriptions here",
                style: TextStyle(color: Colors.white, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            // Animated buttons with slide effect
            SlideTransition(
              position: _buttonsSlideAnimation,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32.0, 0, 32, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const SignUpScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              var curve = Curves.easeInOut;
                              var curveTween = CurvedAnimation(parent: animation, curve: curve);
                              
                              return FadeTransition(
                                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curveTween),
                                child: child,
                              );
                            },
                            transitionDuration: const Duration(milliseconds: 500),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        textStyle: const TextStyle(color: Colors.black),
                        fixedSize: const Size(548, 32),
                      ),
                      child: const Text("Get Started"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32.0, 8, 32, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              var curve = Curves.easeInOut;
                              var curveTween = CurvedAnimation(parent: animation, curve: curve);
                              
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(curveTween),
                                child: child,
                              );
                            },
                            transitionDuration: const Duration(milliseconds: 500),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[850],
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(color: Colors.black),
                        fixedSize: const Size(548, 32),
                      ),
                      child: const Text("Have an Account? Login"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}