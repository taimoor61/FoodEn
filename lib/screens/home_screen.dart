import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooden/screens/donate_screen.dart';
import 'package:fooden/screens/event_screen.dart';
import 'package:fooden/screens/profile_screen.dart';
//import 'package:fooden/screens/volunteer_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  PageController _controller;

  final List<Widget> _children = [
    ProfileScreen(),
    //MyMap(),
    Container(color: Colors.red),
    DonateScreen(),
    EventScreen(),
  ];
  PageView pageView;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void initialize() {
    _currentIndex = 0;
    _controller = PageController(initialPage: _currentIndex);
    pageView = PageView(
      controller: this._controller,
      children: this._children,
      onPageChanged: (page) {
        setState(() {
          _currentIndex = page;
        });
      },
    );
  }

  void getCurrentUser() async {
    try {
      loggedInUser = await _auth.currentUser();
      if (loggedInUser != null) {
        print(loggedInUser.email);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageView,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            this._controller.animateToPage(index,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
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
