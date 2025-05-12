import 'package:flutter/material.dart';
import 'package:labs/screens/SettingsScreen.dart';

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

  final List<String> _categories = [
    'Entertainment',
    'Productivity',
    'Utilities',
    'Education',
    'Health & Fitness',
    'Other'
  ];

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
      body: SingleChildScrollView(
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

            const SizedBox(height: 40),

            // Add button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Check if subscription name is not empty
                  if (_descriptionController.text.trim().isNotEmpty) {
                    // Show success snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Subscription added successfully!'),
                        backgroundColor: primaryColor,
                      ),
                    );

                    // Reset fields to default state
                    _resetFields();
                  } else {
                    // Show error if subscription name is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Please enter a subscription name'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Add Subscription',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
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
