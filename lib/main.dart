import 'package:flutter/material.dart';
import 'package:labs/screens/AIBotScreen.dart';
import 'package:labs/screens/CalendarScreen.dart';
import 'package:labs/screens/HomeScreen.dart';
import 'package:labs/screens/LoginScreen.dart';
import 'package:labs/screens/NewSubscriptionScreen.dart';
import 'package:labs/screens/ProfileScreen.dart';
import 'package:labs/screens/SignupScreen.dart';
import 'package:labs/screens/SplashScreen.dart';
import 'package:labs/screens/CardPaymentScreen.dart';

void main() {
  runApp(const MyApp());
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'SubsTrack',
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.blue,
//           brightness: Brightness.dark,
//         ),
//       ),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => const Scaffold(
//               backgroundColor: Colors.black,
//               body: SafeArea(
//                 child: Splashscreen(),
//               ),
//             ),
//         '/login': (context) => const LoginScreen(),
//         '/signup': (context) => const SignUpScreen(),
//         '/profile': (context) => const ProfileScreen(),
//       },
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SubsTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 19, 98, 44),
          primary: const Color.fromARGB(255, 19, 98, 44),
        ),
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const CalendarScreen(),
    const NewSubscriptionScreen(),
    const CardPaymentScreen(),
    const AIBotScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Payment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: 'AI Bot',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}