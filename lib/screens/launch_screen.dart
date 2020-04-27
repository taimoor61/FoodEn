import 'package:flutter/material.dart';

class LaunchScreen extends StatefulWidget {
  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    changeScreen();
  }

  void changeScreen() async {
    await Future.delayed(const Duration(seconds: 1), () {});
    Navigator.popAndPushNamed(context, 'welcome_screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Image(
            image: AssetImage('images/logo.png'),
            height: 200.0,
            width: 200.0,
          ),
        ),
      ),
    );
  }
}
