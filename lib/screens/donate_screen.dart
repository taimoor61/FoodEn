import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooden/components/donation_button.dart';
import 'package:fooden/constants.dart';

class DonateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                itemExtent: 300.0,
                //diameterRatio: 1.5,
                children: <Widget>[
                  DonationButton(
                    image: AssetImage('images/eidhi.jpg'),
                  ),
                  DonationButton(
                    image: AssetImage('images/al-ameen.jpg'),
                  ),
                  DonationButton(
                    image: AssetImage('images/aghakhan.png'),
                  ),
                  DonationButton(
                    image: AssetImage('images/mustafa-trust.png'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
