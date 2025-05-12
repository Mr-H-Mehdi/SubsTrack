import 'package:cloud_firestore/cloud_firestore.dart';

class Subscription {
  final String id;
  final String name;
  final String category;
  final double price;
  final DateTime billingDate;
  final String icon;
  final String userId;

  Subscription({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.billingDate,
    required this.icon,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'billingDate': Timestamp.fromDate(billingDate),
      'icon': icon,
      'userId': userId,
    };
  }

  factory Subscription.fromMap(String id, Map<String, dynamic> map) {
    return Subscription(
      id: id,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      billingDate: (map['billingDate'] as Timestamp).toDate(),
      icon: map['icon'] ?? 'subscription',
      userId: map['userId'] ?? '',
    );
  }
}

class SubscriptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'subscriptions';

  Future<void> addSubscription(Subscription subscription) async {
    await _firestore.collection(_collection).add(subscription.toMap());
  }

  Stream<List<Subscription>> getSubscriptions(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Subscription.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  Future<void> addDummySubscriptions(String userId) async {
    final List<Map<String, dynamic>> dummyData = [
      {
        'name': 'Netflix',
        'category': 'Entertainment',
        'price': 15.99,
        'billingDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 5))),
        'icon': 'movie',
        'userId': userId,
      },
      {
        'name': 'Spotify',
        'category': 'Entertainment',
        'price': 9.99,
        'billingDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 10))),
        'icon': 'music_note',
        'userId': userId,
      },
      {
        'name': 'Gym Membership',
        'category': 'Health & Fitness',
        'price': 29.99,
        'billingDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 15))),
        'icon': 'fitness_center',
        'userId': userId,
      },
    ];

    for (var data in dummyData) {
      await _firestore.collection(_collection).add(data);
    }
  }
} 