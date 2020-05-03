import 'package:flutter/material.dart';
import 'package:fooden/components/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.edit),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("images/my_image.jpg"),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Taimoor Aftab",
                style: TextStyle(
                  color: Colors.teal.shade900,
                  fontSize: 40.0,
                  fontFamily: "Pacifico",
                ),
              ),
              SizedBox(
                height: 20.0,
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
