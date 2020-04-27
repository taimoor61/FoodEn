import 'package:flutter/material.dart';
import 'screens/launch_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(canvasColor: Colors.white),
      initialRoute: 'launch_screen',
      routes: {
        'launch_screen': (context) => LaunchScreen(),
      },
    );
  }
} 