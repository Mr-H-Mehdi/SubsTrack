import 'package:flutter/material.dart';
import 'package:labs/screens/SettingsScreen.dart';
import 'package:labs/models/subscription.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewSubscriptionScreen extends StatefulWidget {
  const NewSubscriptionScreen({super.key});

  @override
  State<NewSubscriptionScreen> createState() => _NewSubscriptionScreenState();
}

class _NewSubscriptionScreenState extends State<NewSubscriptionScreen> {
  double _currentPrice = 9.99;
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'Entertainment';
  DateTime _selectedDate = DateTime.now();
  final SubscriptionService _subscriptionService = SubscriptionService();
  bool _isLoading = false;

  final List<String> _categories = [
    'Entertainment',
    'Productivity',
    'Utilities',
    'Education',
    'Health & Fitness',
    'Other'
  ];

  final List<String> _icons = [
    'movie',
    'music_note',
    'fitness_center',
    'school',
    'work',
    'subscription',
    'shopping_cart',
    'sports_esports',
    'book',
    'cloud',
  ];

  String _getRandomIcon() {
    return _icons[DateTime.now().millisecondsSinceEpoch % _icons.length];
  }

  void _incrementPrice() {
    setState(() {
      _currentPrice = _currentPrice + 1 > 99.99 ? 99.99 : _currentPrice + 1;
    });
  }

  void _decrementPrice() {
    setState(() {
      _currentPrice = _currentPrice - 1 < 0.99 ? 0.99 : _currentPrice - 1;
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _resetFields() {
    setState(() {
      _descriptionController.clear();
      _currentPrice = 9.99;
      _selectedCategory = 'Entertainment';
      _selectedDate = DateTime.now();
    });
  }

  Future<void> _saveSubscription() async {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a subscription name')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final subscription = Subscription(
        id: '',
        name: _descriptionController.text,
        category: _selectedCategory,
        price: _currentPrice,
        billingDate: _selectedDate,
        icon: _getRandomIcon(),
        userId: user.uid,
      );

      await _subscriptionService.addSubscription(subscription);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subscription added successfully')),
        );
        _resetFields();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding subscription: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define dark theme colors - always using dark mode
    Color textColor = Colors.white;
    Color backgroundColor = Colors.black;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    Color inputBackgroundColor = Colors.grey[850]!;
    Color hintTextColor = Colors.grey[400]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.settings, color: textColor),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        title: Text(
          'Add New Subscription',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // "Enter new subscription" text instead of icon
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Enter New Subscription',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Description field with improved contrast
                TextField(
                  controller: _descriptionController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Subscription Name',
                    labelStyle: TextStyle(color: primaryColor),
                    hintText: 'e.g. Netflix, Spotify',
                    hintStyle: TextStyle(color: hintTextColor),
                    filled: true,
                    fillColor: inputBackgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: primaryColor,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: primaryColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Category dropdown with better contrast
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  dropdownColor: inputBackgroundColor,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(color: primaryColor),
                    filled: true,
                    fillColor: inputBackgroundColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: primaryColor,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: primaryColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                ),

                const SizedBox(height: 20),

                // Price section with plus and minus buttons
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Minus button
                        Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.remove, color: Colors.white),
                            onPressed: _decrementPrice,
                          ),
                        ),

                        // Price display
                        Text(
                          '\$${_currentPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),

                        // Plus button
                        Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add, color: Colors.white),
                            onPressed: _incrementPrice,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Slider with better visibility
                    Slider(
                      value: _currentPrice,
                      min: 0.99,
                      max: 99.99,
                      divisions: 99,
                      activeColor: primaryColor,
                      inactiveColor: primaryColor.withOpacity(0.3),
                      label: _currentPrice.toStringAsFixed(2),
                      onChanged: (double value) {
                        setState(() {
                          _currentPrice = value;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$0.99', style: TextStyle(color: textColor)),
                        Text('\$99.99', style: TextStyle(color: textColor)),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Billing cycle with better visibility
                Row(
                  children: [
                    Text(
                      'Billing Date:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: primaryColor,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null && picked != _selectedDate) {
                          setState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: inputBackgroundColor,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Save button
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveSubscription,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Save Subscription',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar: Theme(
      //   data: ThemeData.dark(),
      //   child: BottomNavigationBar(
      //     backgroundColor: Colors.black,
      //     selectedItemColor: primaryColor,
      //     unselectedItemColor: Colors.grey,
      //     type: BottomNavigationBarType.fixed,
      //     items: const [
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.home),
      //         label: 'Home',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.calendar_today),
      //         label: 'Calendar',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.add_circle),
      //         label: '',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.attach_money),
      //         label: 'Payment',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.chat_bubble_outline),
      //         label: 'AI Bot',
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
