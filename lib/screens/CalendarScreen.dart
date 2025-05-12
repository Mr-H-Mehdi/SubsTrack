import 'package:flutter/material.dart';
import 'package:labs/models/subscription.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

// Helper method to build icon based on icon string
Widget _buildSubscriptionIcon(String iconStr) {
  // Try to parse as integer first (icon code)
  try {
    int iconCode = int.parse(iconStr);
    return Icon(
      IconData(iconCode, fontFamily: 'MaterialIcons'),
      color: Colors.white,
      size: 30,
    );
  } catch (e) {
    // If parsing fails, use a text-based approach or predefined icons
    switch (iconStr.toLowerCase()) {
      case 'movie':
        return const Icon(Icons.movie, color: Colors.white, size: 30);
      case 'music':
        return const Icon(Icons.music_note, color: Colors.white, size: 30);
      case 'game':
        return const Icon(Icons.sports_esports, color: Colors.white, size: 30);
      case 'shopping':
        return const Icon(Icons.shopping_bag, color: Colors.white, size: 30);
      case 'food':
        return const Icon(Icons.restaurant, color: Colors.white, size: 30);
      case 'fitness':
        return const Icon(Icons.fitness_center, color: Colors.white, size: 30);
      case 'education':
        return const Icon(Icons.school, color: Colors.white, size: 30);
      case 'productivity':
        return const Icon(Icons.work, color: Colors.white, size: 30);
      case 'utility':
        return const Icon(Icons.bolt, color: Colors.white, size: 30);
      default:
        // Default icon if no match
        return const Icon(Icons.subscriptions, color: Colors.white, size: 30);
    }
  }
}

class _CalendarScreenState extends State<CalendarScreen> with SingleTickerProviderStateMixin {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Subscription>> _events = {};
  late TabController _tabController;
  List<Subscription> _allSubscriptions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedDay = _focusedDay;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Helper function to convert DateTime to a comparable key
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Check if a date has events
  bool _hasEventsForDay(DateTime day) {
    final normalizedDay = _normalizeDate(day);
    return _events.containsKey(normalizedDay) && _events[normalizedDay]!.isNotEmpty;
  }

  // Get events for a specific day
  List<Subscription> _getEventsForDay(DateTime day) {
    final normalizedDay = _normalizeDate(day);
    return _events[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Please log in',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final subscriptionService = SubscriptionService();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Calendar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color.fromARGB(255, 19, 98, 44),
          labelColor: Colors.white,
          tabs: const [
            Tab(text: 'Calendar View'),
            Tab(text: 'All Subscriptions'),
          ],
        ),
      ),
      body: StreamBuilder<List<Subscription>>(
        stream: subscriptionService.getSubscriptions(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          _allSubscriptions = snapshot.data ?? [];
          
          // Group subscriptions by normalized date
          _events = {};
          for (var subscription in _allSubscriptions) {
            final normalizedDate = _normalizeDate(subscription.billingDate);
            if (_events[normalizedDate] == null) _events[normalizedDate] = [];
            _events[normalizedDate]!.add(subscription);
          }

          return TabBarView(
            controller: _tabController,
            children: [
              // Calendar View Tab
              _buildCalendarView(),
              
              // All Subscriptions Tab
              _buildAllSubscriptionsView(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCalendarView() {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.utc(2025, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          eventLoader: (day) {
            return _getEventsForDay(day);
          },
          calendarStyle: const CalendarStyle(
            outsideDaysVisible: false,
            weekendTextStyle: TextStyle(color: Colors.red),
            holidayTextStyle: TextStyle(color: Colors.red),
            defaultTextStyle: TextStyle(color: Colors.white),
            selectedDecoration: BoxDecoration(
              color: Color.fromARGB(255, 19, 98, 44),
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.blueGrey,
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: true,
            formatButtonShowsNext: false,
            titleCentered: true,
            formatButtonDecoration: BoxDecoration(
              color: Color.fromARGB(255, 19, 98, 44),
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            formatButtonTextStyle: TextStyle(color: Colors.white),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
            rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
          ),
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isEmpty) return null;
              return Positioned(
                right: 1,
                bottom: 1,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.amber,
                  ),
                  width: 8.0,
                  height: 8.0,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                _selectedDay != null
                    ? DateFormat('MMM d, yyyy').format(_selectedDay!)
                    : 'No date selected',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Divider(color: Colors.grey),
        const SizedBox(height: 8),
        Expanded(
          child: _selectedDay == null
              ? const Center(
                  child: Text(
                    'Select a day to view subscriptions',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : _buildSelectedDayEventList(),
        ),
      ],
    );
  }

  Widget _buildSelectedDayEventList() {
    final events = _selectedDay != null ? _getEventsForDay(_selectedDay!) : [];
    
    if (events.isEmpty) {
      return const Center(
        child: Text(
          'No subscriptions due on this day',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return _buildSubscriptionCard(events[index]);
      },
    );
  }

  Widget _buildAllSubscriptionsView() {
    if (_allSubscriptions.isEmpty) {
      return const Center(
        child: Text(
          'No subscriptions found',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    // Sort subscriptions by date
    final sortedSubscriptions = [..._allSubscriptions]
      ..sort((a, b) => a.billingDate.compareTo(b.billingDate));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedSubscriptions.length,
      itemBuilder: (context, index) {
        final subscription = sortedSubscriptions[index];
        return _buildSubscriptionCard(subscription);
      },
    );
  }

  Widget _buildSubscriptionCard(Subscription subscription) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromARGB(255, 40, 40, 40),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 30, 30, 30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: _buildSubscriptionIcon(subscription.icon),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subscription.category,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${subscription.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d').format(subscription.billingDate),
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}