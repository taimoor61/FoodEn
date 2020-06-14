import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
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
    return NeumorphicApp(
      title: 'Flutter Demo',
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
        baseColor: Color(0xFFFFFFFF),
        lightSource: LightSource.topLeft,
        depth: 10,
      ),
      darkTheme: NeumorphicThemeData(
        baseColor: Color(0xFF3E3E3E),
        lightSource: LightSource.topLeft,
        depth: 6,
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
