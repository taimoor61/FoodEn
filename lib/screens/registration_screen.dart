import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fooden/components/rounded_button.dart';
import 'package:fooden/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fooden/screens/alert_dialog_with_message.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'DetailForm.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email = "";
  String password = "";

  bool isValidPassword = true;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Container(
                  height: 200.0,
                  child: Hero(
                    tag: "logo",
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                onChanged: (value) {
                  email = value;
                },
                textAlign: TextAlign.center,
                decoration: kInputDecoration,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (value) {
                  password = value;
                },
                textAlign: TextAlign.center,
                obscureText: true,
                maxLength: 30,
                maxLengthEnforced: true,
                decoration: kInputDecoration.copyWith(
                  hintText: "Enter Your Password",
                  errorText: isValidPassword
                      ? null
                      : "Please Enter password between 6-30 characters",
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                text: "Register",
                color: Colors.blueAccent,
                onPressed: () async {
                  if (password.length < 6) {
                    setState(() {
                      isValidPassword = false;
                    });
                    return;
                  }
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: this.email, password: this.password);
                    if (newUser != null) {
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => DetailForm(
                                email: this.email,
                                password: this.password,
                                comingFrom: 'registration',
                              )
                          ));
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    setState(() {
                      showSpinner = false;
                    });
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialogWithMessage(
                        title: "Register Exception",
                        message: 'Message: ${e.message}',
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
