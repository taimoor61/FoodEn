import 'package:flutter/material.dart';
import 'package:fooden/components/rounded_button.dart';
import 'package:fooden/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 200.0,
              child: Hero(
                tag: "logo",
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
              },
              textAlign: TextAlign.center,
              decoration: kInputDecoration,
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
              },
              textAlign: TextAlign.center,
              decoration: kInputDecoration.copyWith(
                hintText: "Enter Your Password"
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
              text: "Login",
              color: Colors.lightBlueAccent,
              onPressed: (){
                Navigator.pushNamed(context, 'home_screen');
              },
            ),
          ],
        ),
      ),
    );
  }
}
