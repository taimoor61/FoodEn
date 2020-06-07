import 'package:flutter/material.dart';
import 'package:fooden/screens/DetailForm.dart';
import 'package:fooden/screens/home_screen.dart';
import 'package:fooden/screens/launch_screen.dart';
import 'package:fooden/screens/login_screen.dart';
import 'package:fooden/screens/payment_screen.dart';
import 'package:fooden/screens/registration_screen.dart';
import 'package:fooden/screens/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(canvasColor: Colors.white),
      debugShowCheckedModeBanner: false,
      initialRoute: 'launch_screen',
      routes: {
        'launch_screen': (context) => LaunchScreen(),
        'welcome_screen': (context) => WelcomeScreen(),
        'login_screen': (context) => LoginScreen(),
        'registration_screen': (context) => RegistrationScreen(),
        'home_screen': (context) => HomeScreen(),
        'payment_screen': (context) => PaymentScreen(),
        'detail_form_screen': (context) => DetailForm(),
      },
     // home: LaunchScreen(),
    );
  }
} 