import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooden/constants.dart';

import '../constants.dart';
import '../constants.dart';

class DonateScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: kTextFieldDecoration,
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Card(
                    child: Image.asset(
                      'images/eidhi.jpg',
                      fit: BoxFit.fill,
                    ),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.all(10),
                  ),
                  Card(
                    child: Image.asset(
                        'images/al-ameen.jpg',
                         fit: BoxFit.fill,
                    ),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.all(10),
                  ),
                  Card(
                    child: Image.asset(
                        'images/aghakhan.png',
                      fit: BoxFit.fill,
                    ),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.all(10),
                  ),
                  Card(
                    child: Image.asset(
                        'images/mustafa-trust.png',
                      fit: BoxFit.fill,
                    ),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.all(10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}