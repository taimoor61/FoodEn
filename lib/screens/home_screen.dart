import 'package:flutter/material.dart';
import 'package:fooden/screens/donate_screen.dart';
import 'package:fooden/screens/event_screen.dart';
import 'package:fooden/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Widget> _children = [
    ProfileScreen(),
    Container(color: Colors.blue),
<<<<<<< HEAD
    DonateScreen(), 
=======
    DonateScreen(),
>>>>>>> 16f8302d5784ccea603b2dc21cca57d2e23a1326
    EventScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: new Icon(Icons.map),
            title: new Text('Volunteer'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: new Icon(Icons.money_off),
            title: new Text('Donate'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: new Icon(Icons.event),
            title: new Text('Events'),
          )
        ],
      ),
    );
  }
}
