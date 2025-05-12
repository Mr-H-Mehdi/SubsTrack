import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:labs/models/UserData.dart';
import 'dart:math' as math;

class SettingsScreen extends StatefulWidget {
  final UserData? userData;

  const SettingsScreen({super.key, this.userData});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
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
      name = "John Doe";
      email = "john.doe@example.com";
      phone = "+1234567890";
      address = "123 Main St, City";
      checked = false;
      imageName = "assets/images/ManPic.jpeg";
    }

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Photo with Animation
            AnimatedBuilder(
              animation: _profileImageAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _profileImageAnimation.value,
                  child: Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(imageName),
                        ),
                        const SizedBox(height: 10),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            email,
                            style: TextStyle(
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            // Personal Information Section
            _buildSettingsSection(
              context,
              'Personal Information',
              [
                _buildInfoRow(Icons.phone, "Phone Number", phone),
                _buildInfoRow(Icons.email, "Email", email),
                _buildInfoRow(Icons.pin_drop, "Address", address),
                _buildSettingItem(
                  context,
                  'Biometric Authentication',
                  Icons.fingerprint,
                  Colors.green,
                  () {},
                  trailing: Switch(
                    value: checked,
                    onChanged: (value) {
                      setState(() {
                        checked = value;
                      });
                    },
                    thumbColor: MaterialStateProperty.all(Colors.white),
                    activeTrackColor: Colors.green,
                    inactiveTrackColor: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // General Settings
            _buildSettingsSection(
              context,
              'General Settings',
              [
                _buildSettingItem(
                  context,
                  'Security',
                  Icons.security,
                  Colors.blue,
                  () {},
                ),
                _buildSettingItem(
                  context,
                  'Cloud Sync',
                  Icons.cloud,
                  Colors.blue,
                  () {},
                ),
                _buildSettingItem(
                  context,
                  'Notifications',
                  Icons.notifications,
                  Colors.orange,
                  () {},
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Subscription Settings
            _buildSettingsSection(
              context,
              'My Subscription',
              [
                _buildSettingItem(
                  context,
                  'Sort Subscriptions',
                  Icons.sort,
                  Colors.purple,
                  () {},
                ),
                _buildSettingItem(
                  context,
                  'Summary',
                  Icons.summarize,
                  Colors.green,
                  () {},
                ),
                _buildSettingItem(
                  context,
                  'Default Currency',
                  Icons.attach_money,
                  Colors.amber,
                  () {},
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Appearance Settings
            _buildSettingsSection(
              context,
              'Appearance',
              [
                _buildSettingItem(
                  context,
                  'Theme',
                  Icons.color_lens,
                  Colors.indigo,
                  () {},
                ),
                _buildSettingItem(
                  context,
                  'Font Style',
                  Icons.font_download,
                  Colors.teal,
                  () {},
                ),
              ],
            ),

            const SizedBox(height: 20),

            // About & Help
            _buildSettingsSection(
              context,
              'About & Help',
              [
                _buildSettingItem(
                  context,
                  'Privacy Policy',
                  Icons.privacy_tip,
                  Colors.grey,
                  () {},
                ),
                _buildSettingItem(
                  context,
                  'Terms & Conditions',
                  Icons.description,
                  Colors.grey,
                  () {},
                ),
                _buildSettingItem(
                  context,
                  'Help & Support',
                  Icons.help,
                  Colors.grey,
                  () {},
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();

                    print('User signed out');
                    // You can navigate the user to a login screen or show a message
                    Navigator.pushReplacementNamed(context, '/login');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Logged out successfully'),
                      ),
                    );
                  } catch (e) {
                    print('Error signing out: $e');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    List<Widget> items,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[300],
            ),
          ),
          const SizedBox(height: 15),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: color,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            trailing ??
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 15),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
