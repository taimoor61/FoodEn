import 'package:flutter/material.dart';

const kInputDecoration = InputDecoration(
  hintText: 'Enter Your Email',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kDonateTextStyle = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const kTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Color(0xFFC0C0C0),
  icon: Icon(
    Icons.search,
    color: Colors.grey,
  ),
  hintText: 'Enter organization name',
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    borderSide: BorderSide.none,
  ),
);

const kEventTextFieldStyle = TextStyle(
  fontSize: 30.0,
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
);

const kEventBoxDecoration = BoxDecoration(
  color: Colors.red, //Color(0xFFebffe8)
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(30.0),
    bottomRight: Radius.circular(30.0),
  ),
);

const kEventDetailTextStyle = TextStyle(
  fontSize: 25.0,
  fontStyle: FontStyle.italic,
  fontWeight: FontWeight.bold,
);
