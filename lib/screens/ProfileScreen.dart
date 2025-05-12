import 'package:flutter/material.dart';
import 'package:labs/models/UserData.dart';
import 'dart:math' as math;

class ProfileScreen extends StatefulWidget {
  final UserData? userData;

  const ProfileScreen({super.key, this.userData});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  bool checked = false;
  late String name;
  late String email;
  late String phone;
  late String address;
  late String imageName;

  // Animation controllers
  late AnimationController _controller;
  late Animation<double> _profileImageAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Individual info row animations
  late List<Animation<Offset>> _rowAnimations;

  @override
  void initState() {
    super.initState();

    // Initialize with data from userData or use defaults
    if (widget.userData != null) {
      name = widget.userData!.name;
      email = widget.userData!.email;
      phone = widget.userData!.phone;
      address = widget.userData!.address;
      checked = widget.userData!.biometric;
      imageName = widget.userData!.imageName;
    } else {
      // Default values if no data is passed
      name = "Mr John Smith";
      email = "johnsmith@email.com";
      phone = "+923456789012";
      address = "Beruni Hostel NUST, Sector-H12, Islamabad Pk.";
      checked = false;
      imageName = "assets/images/ManPic.jpeg";
    }

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Profile image animation
    _profileImageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeIn),
      ),
    );

    // Slide animation for name and main elements
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );

    // Animations for info rows with staggered effect
    _rowAnimations = List.generate(
      4,
      (index) => Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.4 + (index * 0.1),
            math.min(
                0.9 + (index * 0.05), 1.0), // Ensures end never exceeds 1.0
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
    );

    // Start animations
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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 58, 4),
        foregroundColor: Colors.white,
        title: const Text('Home'),
        elevation: 4.0,
        // Add a custom animation to the AppBar
        flexibleSpace: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 0, 58, 4),
                    Color.fromARGB(255, 0, 102, 7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, _fadeAnimation.value],
                ),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 100),
          // Animated profile image
          AnimatedBuilder(
            animation: _profileImageAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _profileImageAnimation.value,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 2 * math.pi),
                  duration: const Duration(seconds: 2),
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: value * 0.05 * math.sin(value),
                      child: child,
                    );
                  },
                  child: Hero(
                    tag: 'profile_image',
                    child: Center(
                      child: CircleAvatar(
                        backgroundImage: AssetImage(imageName),
                        radius: 50,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          // Animated name
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
          const SizedBox(height: 54),
          // Phone info row with animation
          SlideTransition(
            position: _rowAnimations[0],
            child: _buildInfoRow(
              Icons.phone,
              "Phone Number",
              phone,
            ),
          ),
          const SizedBox(height: 8),
          // Email info row with animation
          SlideTransition(
            position: _rowAnimations[1],
            child: _buildInfoRow(
              Icons.email,
              "Email",
              email,
            ),
          ),
          // Biometric info row with animation
          SlideTransition(
            position: _rowAnimations[2],
            child: Row(
              children: [
                const SizedBox(width: 32),
                Icon(
                  Icons.fingerprint,
                  color: Colors.green[900],
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  "Biometric",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green[900],
                    fontWeight: FontWeight.w600,
                    fontFamily: "Arvo",
                  ),
                ),
                const Spacer(),
                // Animated switch
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Transform.scale(
                    scale: 0.65,
                    child: Switch(
                      value: checked,
                      onChanged: (onChanged) {
                        setState(() {
                          checked = !checked;
                        });
                      },
                      // Custom switch animation
                      thumbColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.grey;
                          }
                          return Colors.white;
                        },
                      ),
                      trackColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors.green.withOpacity(0.8);
                          }
                          return Colors.grey.withOpacity(0.5);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 32),
              ],
            ),
          ),
          // Address info row with animation
          SlideTransition(
            position: _rowAnimations[3],
            child: Row(
              children: [
                const SizedBox(width: 32),
                Icon(
                  Icons.pin_drop,
                  color: Colors.green[900],
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  "Address",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green[900],
                    fontWeight: FontWeight.w600,
                    fontFamily: "Arvo",
                  ),
                ),
                const Spacer(),
                // Animated Container for address
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 220,
                      padding: EdgeInsets.all(4.0 * _fadeAnimation.value),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(4.0 * _fadeAnimation.value),
                        color:
                            Colors.grey.withOpacity(0.1 * _fadeAnimation.value),
                      ),
                      child: child,
                    );
                  },
                  child: Text(
                    address,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build info rows
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        const SizedBox(width: 32),
        Icon(
          icon,
          color: Colors.green[900],
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.green[900],
            fontWeight: FontWeight.w600,
            fontFamily: "Arvo",
          ),
        ),
        const Spacer(),
        // Add a subtle animation to the value text
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.8, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        const SizedBox(width: 32),
      ],
    );
  }
}
