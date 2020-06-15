import 'package:flutter/material.dart';
import 'package:fooden/models/organizations.dart';

import '../components/rounded_button.dart';

// ignore: must_be_immutable
class OrgDetailScreen extends StatelessWidget{

  OrgDetailScreen({this.org});

  Organization org;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title : Text('Information'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Card(
                child: Image.asset(org.path,fit: BoxFit.contain),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: EdgeInsets.all(10),
              ),
            ),
            Text(
              org.name,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              org.location,
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              org.phoneNumber,
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            RoundedButton(
              color: Colors.red,
              text: 'Donate',
              onPressed: (){
                Navigator.pushNamed(context, 'payment_screen');
              },
            )
          ],
        ),
      ),
    );
  }
}