import 'package:flutter/material.dart';
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
    Container(color: Colors.green),
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
