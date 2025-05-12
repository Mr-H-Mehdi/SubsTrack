import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Photo
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      image: const DecorationImage(
                        image: NetworkImage('https://via.placeholder.com/100'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'john.doe@example.com',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
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
                  'iCloud Sync',
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
            
            // My Subscription Settings
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
                onPressed: () {
                  // Logout logic
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
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
    VoidCallback onTap,
  ) {
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
              ),
            ),
            const Spacer(),
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
}