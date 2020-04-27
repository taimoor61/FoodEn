import 'package:flutter/material.dart';
import 'package:fooden/components/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 190.0,
                height: 190.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("images/my_image.jpg"),
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
                width: 150.0,
                child: Divider(
                  height: 5.0,
                  color: Colors.teal.shade100,
                ),
              ),
              CustomCard(
                text: "Taimoor Aftab",
                icon: Icons.people,
              ),
              CustomCard(
                text: "+92 343 9851659",
                icon: Icons.phone,
              ),
              CustomCard(
                text: "i160004@nu.edu.pk",
                icon: Icons.email,
              ),
            ],
          ),
        ),
      ),
    );
  }
}