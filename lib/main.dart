import 'package:flutter/material.dart';
import 'package:fooden/screens/home_screen.dart';
import 'package:fooden/screens/launch_screen.dart';
import 'package:fooden/screens/login_screen.dart';
import 'package:fooden/screens/map_screen.dart';
import 'package:fooden/screens/payment_screen.dart';
import 'package:fooden/screens/registration_screen.dart';
import 'package:fooden/screens/volunteer_screen.dart';
import 'package:fooden/screens/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        canvasColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          textTheme: TextTheme(
            headline6: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: 'launch_screen',
      routes: {
        'launch_screen': (context) => LaunchScreen(),
        'welcome_screen': (context) => WelcomeScreen(),
        'login_screen': (context) => LoginScreen(),
        'registration_screen': (context) => RegistrationScreen(),
        'home_screen': (context) => HomeScreen(),
        'payment_screen': (context) => PaymentScreen(),
        'volunteer_screen': (context) => VolunteerScreen(),
        'map_screen': (context) => MyMap(),
      },
      // home: LaunchScreen(),
    );
  }
}
