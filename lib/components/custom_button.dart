import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  CustomCard({this.text, this.icon});

  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade200,
      elevation: 10,
      margin: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: ListTile(
        leading: Icon(
          this.icon,
          color: Colors.teal,
        ),
        title: Text(
          this.text,
          style: TextStyle(
            color: Colors.teal.shade900,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
