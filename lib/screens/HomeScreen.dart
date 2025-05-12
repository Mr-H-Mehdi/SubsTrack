import 'package:flutter/material.dart';
import './widgets/subscription_card.dart';
import 'SettingsScreen.dart';
import 'package:labs/models/subscription.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('Please log in'));
    }

    final subscriptionService = SubscriptionService();

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
        child: StreamBuilder<List<Subscription>>(
          stream: subscriptionService.getSubscriptions(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final subscriptions = snapshot.data ?? [];

            if (subscriptions.isEmpty) {
              // Add dummy data if collection is empty
              subscriptionService.addDummySubscriptions(user.uid);
              return const Center(child: CircularProgressIndicator());
            }

            // Calculate statistics
            final totalThisMonth = subscriptions
                .where((sub) => sub.billingDate.month == DateTime.now().month)
                .fold(0.0, (sum, sub) => sum + sub.price);

            final activeSubscriptions = subscriptions.length;

            final highestSubscription = subscriptions.isEmpty
                ? null
                : subscriptions.reduce((a, b) => a.price > b.price ? a : b);

            final lowestSubscription = subscriptions.isEmpty
                ? null
                : subscriptions.reduce((a, b) => a.price < b.price ? a : b);

            final upcomingBills = subscriptions
                .where((sub) => sub.billingDate.isAfter(DateTime.now()))
                .toList()
              ..sort((a, b) => a.billingDate.compareTo(b.billingDate));

            return Column(
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
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background ring - Use actual subscription data
                        SizedBox(
                          width: 180,
                          height: 180,
                          child: CircularProgressIndicator(
                            // Assume 500 is budget limit, or calculate based on historical data
                            value: totalThisMonth / 500, 
                            strokeWidth: 12,
                            backgroundColor: Colors.black,
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(Colors.orange),
                          ),
                        ),
                        // Inner text
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Row(
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
                            const SizedBox(height: 5),
                            Text(
                              '\$${totalThisMonth.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
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
                
                // Statistics Categories
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      _buildCardCategory(
                          'Active Subscriptions', activeSubscriptions.toString(), Colors.white),
                      _buildCardCategory(
                          'Highest Priced', 
                          highestSubscription != null 
                              ? '\$${highestSubscription.price.toStringAsFixed(2)}' 
                              : 'N/A', 
                          Colors.white),
                      _buildCardCategory(
                          'Lowest Priced', 
                          lowestSubscription != null 
                              ? '\$${lowestSubscription.price.toStringAsFixed(2)}' 
                              : 'N/A', 
                          Colors.white),
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
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
                            child: Text('Your Subscriptions'),
                          ),
                        ),
                        Tab(
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
                            child: Text('Upcoming Bills'),
                          ),
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
                      // Your Subscriptions Tab - Display all subscriptions
                      ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        itemCount: subscriptions.length,
                        itemBuilder: (context, index) {
                          final subscription = subscriptions[index];
                          return SubscriptionCard(
                            title: subscription.name,
                            price: subscription.price,
                            date: '${subscription.billingDate.day}/${subscription.billingDate.month}/${subscription.billingDate.year}',
                            icon: _getIconForSubscription(subscription.icon),
                            color: _getColorForSubscription(subscription.name),
                          );
                        },
                      ),

                      // Upcoming Bills Tab
                      ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        itemCount: upcomingBills.length,
                        itemBuilder: (context, index) {
                          final subscription = upcomingBills[index];
                          return SubscriptionCard(
                            title: subscription.name,
                            price: subscription.price,
                            date: '${subscription.billingDate.day}/${subscription.billingDate.month}/${subscription.billingDate.year}',
                            icon: _getIconForSubscription(subscription.icon),
                            color: _getColorForSubscription(subscription.name),
                            isUpcoming: true,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
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

  // Helper method to safely handle icon conversion
  IconData _getIconForSubscription(String iconData) {
    try {
      // If it's a valid integer, use it as an icon code
      int iconCode = int.parse(iconData);
      return IconData(iconCode, fontFamily: 'MaterialIcons');
    } catch (e) {
      // If it's not a valid integer, map string names to Icons
      switch (iconData.toLowerCase()) {
        case 'movie':
          return Icons.movie;
        case 'netflix':
          return Icons.play_circle_filled;
        case 'music':
        case 'spotify':
          return Icons.music_note;
        case 'shopping':
          return Icons.shopping_bag;
        case 'fitness':
          return Icons.fitness_center;
        case 'gaming':
          return Icons.games;
        case 'video':
        case 'youtube':
          return Icons.video_library;
        case 'cloud':
        case 'icloud':
          return Icons.cloud;
        case 'streaming':
          return Icons.stream;
        case 'news':
          return Icons.newspaper;
        case 'book':
          return Icons.book;
        case 'food':
          return Icons.fastfood;
        default:
          // Default icon if no match is found
          return Icons.subscriptions;
      }
    }
  }

  // Helper method to provide colors based on subscription names
  Color _getColorForSubscription(String name) {
    switch (name.toLowerCase()) {
      case 'netflix':
        return Colors.red;
      case 'spotify':
        return Colors.green;
      case 'youtube':
      case 'youtube premium':
        return Colors.red;
      case 'amazon':
      case 'amazon prime':
        return Colors.blue;
      case 'disney':
      case 'disney+':
        return Colors.blue;
      case 'apple':
      case 'apple music':
      case 'apple tv+':
      case 'icloud':
        return Colors.blue;
      case 'hbo':
      case 'hbo max':
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }
}