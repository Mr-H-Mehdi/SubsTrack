import 'package:flutter/material.dart';
import './widgets/subscription_card.dart';
import 'SettingsScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showSubscriptions = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _showSubscriptions = _tabController.index == 0;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            color: Colors.white70,
            icon: const Icon(Icons.arrow_back),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Budget Tracker with Circular Progress
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                height: 200,
                width: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background ring
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: CircularProgressIndicator(
                        value: 485 / 500, // dynamically set this
                        strokeWidth: 12,
                        backgroundColor: Colors.black,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.orange),
                      ),
                    ),
                    // Inner text

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              height: 32,
                              width: 32,
                              image: AssetImage("assets/images/AppLogo.png"),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'SubsTrack',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          '\$485.00',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'This month\'s bill',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Subscriptions Categories
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  _buildCardCategory(
                      'Active Subscriptions', '12', Colors.white),
                  _buildCardCategory('Highest Priced', '\$15.99', Colors.white),
                  _buildCardCategory('Lowest Priced', '\$4.99', Colors.white),
                ],
              ),
            ),

            // Tab Bar
            Padding(
              padding: const EdgeInsets.all(5),
              
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[600]!,
                    width: 1,
                  ),
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[700],
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey[400],
                  tabs: const [
                    Tab(
                      // text: "",
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
                        child: Text('Your Subscriptions'),
                      ),
                      // icon: Icon(Icons.list),
                    ),
                    Tab(
                      // text: "",
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
                        child: Text('Upcoming Bills'),
                      ),
                      // icon: Icon(Icons.list),
                    ),
                  ],
                ),
              ),
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Your Subscriptions Tab
                  ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    children: const [
                      SubscriptionCard(
                        title: 'Netflix',
                        price: 15.99,
                        date: '26/05/2025',
                        icon: Icons.play_circle_filled,
                        color: Colors.red,
                      ),
                      SubscriptionCard(
                        title: 'Spotify',
                        price: 9.99,
                        date: '15/05/2025',
                        icon: Icons.music_note,
                        color: Colors.green,
                      ),
                      SubscriptionCard(
                        title: 'YouTube Premium',
                        price: 11.99,
                        date: '30/05/2025',
                        icon: Icons.video_library,
                        color: Colors.red,
                      ),
                      SubscriptionCard(
                        title: 'iCloud',
                        price: 2.99,
                        date: '22/05/2025',
                        icon: Icons.cloud,
                        color: Colors.blue,
                      ),
                    ],
                  ),

                  // Upcoming Bills Tab
                  ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    children: const [
                      SubscriptionCard(
                        title: 'Netflix',
                        price: 15.99,
                        date: '26/05/2025',
                        icon: Icons.play_circle_filled,
                        color: Colors.red,
                        isUpcoming: true,
                      ),
                      SubscriptionCard(
                        title: 'Spotify',
                        price: 9.99,
                        date: '15/05/2025',
                        icon: Icons.music_note,
                        color: Colors.green,
                        isUpcoming: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardCategory(String title, String value, Color color) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 10, bottom: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
