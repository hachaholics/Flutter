import 'package:flutter/material.dart';
import 'passenger/screens/search_screen.dart';
import 'conductor/screens/login_screen.dart';
import 'splash_screen.dart'; // <-- import splash

void main() {
  runApp(const BusApp());
}

class BusApp extends StatelessWidget {
  const BusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Tracking',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(), // <-- start with splash
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    SearchScreen(),   // Passenger
    LoginScreen(),    // Conductor
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: 'Passenger',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Conductor',
          ),
        ],
      ),
    );
  }
}
