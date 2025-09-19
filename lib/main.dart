import 'package:flutter/material.dart';
import 'passenger/screens/search_screen.dart';
import 'conductor/screens/login_screen.dart';

void main() {
  runApp(BusApp());
}

class BusApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Tracking',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    SearchScreen(),   // Passenger
    LoginScreen(), // Conductor
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
