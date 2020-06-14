import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooden/screens/donate_screen.dart';
import 'package:fooden/screens/event_screen.dart';
import 'package:fooden/screens/profile_screen.dart';
import 'package:fooden/screens/volunteer_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  PageController _controller;

  List<Widget> _children;
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
    _children = [
      ProfileScreen(),
      VolunteerScreen(),
      DonateScreen(),
      EventScreen(),
    ];
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
    } catch (e) {print("ABC");}
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: pageView,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          elevation: 30,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              this._controller.animateToPage(index,
                  duration: Duration(milliseconds: 300), curve: Curves.fastLinearToSlowEaseIn);
            });
          },
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: Icon(Icons.person,color: Colors.black,),
              title: Text('Profile',style: TextStyle(color: Colors.black),),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: new Icon(Icons.map, color: Colors.black,),
              title: new Text('Volunteer', style: TextStyle(color: Colors.black),),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: new Icon(Icons.money_off, color: Colors.black,),
              title: new Text('Donate', style: TextStyle(color: Colors.black),),
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: new Icon(Icons.event, color: Colors.black,),
              title: new Text('Events', style: TextStyle(color: Colors.black),),
            )
          ],
        ),
      ),
    );
  }
}
