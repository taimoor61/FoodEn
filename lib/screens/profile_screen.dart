import 'package:flutter/material.dart';
import 'package:fooden/components/custom_button.dart';
import 'package:fooden/main.dart';
import 'package:fooden/screens/DetailForm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fooden/screens/welcome_screen.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatefulWidget{

  //ProfileScreen({this.firstName, this.lastName, this.email, this.password, this.phoneNumber});



  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String firstName = "";
  String lastName = "";
  String password = "";
  String email = "";
  String phoneNumber = "";
  String downloadURL = "";


  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  FirebaseUser loggedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getUserData();
  }

  void getCurrentUser() async {
    try {
      loggedInUser = await _auth.currentUser();
      if (loggedInUser != null) {
        print(loggedInUser.email);
        setState(() {});
      }
    } catch (e) {
      print("ABC");
    }
  }

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
      body: loggedInUser == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : getProfileData(),
      );
  }


  Padding getProfileData() {
    //getUserData();
    return Padding(
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
                    image: downloadURL.isEmpty ? AssetImage("images/my_image.jpg") : NetworkImage(downloadURL),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              firstName,
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
              text: phoneNumber,
              icon: Icons.phone,
            ),
            CustomCard(
              text: email,
              icon: Icons.email,
            ),
            SizedBox(height: 20),
            Expanded(
              child: Center(
                child: RaisedButton(
                  child: Text('SignOut'),
                  color: Colors.red,
                  onPressed: _signOut,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


//  edit(BuildContext context){
//    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailForm(
//      email: this.email,
//      password: this.password,
//      comingFrom: 'home',
//      firstName: this.firstName,
//      lastName: this.lastName,
//      phoneNumber: this.phoneNumber,
//    )));
//  }

  void getUserData() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    await _firestore.collection('user')
        .document(firebaseUser.uid)
        .get()
        .then((value){
          print (value.data);


          setState(() {
            this.firstName = value.data['firstName'];
            this.lastName = value.data['lastName'];
            this.email = value.data['email'];
            this.password = value.data['password'];
            this.phoneNumber = value.data['phoneNumber'];
            this.downloadURL = value.data['url'];
          });

        });
  }

  Future<void> _signOut() async{
    await FirebaseAuth.instance.signOut();
    print(FirebaseAuth.instance.currentUser().toString());
    Navigator.pushReplacementNamed(context, 'welcome_screen');
  }
}

//Padding(
//padding: EdgeInsets.only(top: 20.0),
//child: Center(
//child: Column(
//crossAxisAlignment: CrossAxisAlignment.center,
//children: <Widget>[
//Flexible(
//child: Container(
//width: 200.0,
//height: 200.0,
//decoration: new BoxDecoration(
//shape: BoxShape.circle,
//image: new DecorationImage(
//fit: BoxFit.fill,
//image: AssetImage("images/my_image.jpg"),
//),
//),
//),
//),
//SizedBox(
//height: 20.0,
//),
//Text(
//firstName + lastName,
//style: TextStyle(
//color: Colors.teal.shade900,
//fontSize: 40.0,
//fontFamily: "Pacifico",
//),
//),
//SizedBox(
//height: 20.0,
//),
//CustomCard(
//text: phoneNumber,
//icon: Icons.phone,
//),
//CustomCard(
//text: email,
//icon: Icons.email,
//),
//],
//),
//),AssetImage("images/my_image.jpg"),
//),