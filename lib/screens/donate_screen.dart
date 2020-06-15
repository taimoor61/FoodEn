import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooden/models/organizations.dart';
import 'package:fooden/constants.dart';
import 'package:fooden/screens/org_details_screen.dart';

// ignore: must_be_immutable
class DonateScreen extends StatelessWidget {

  List<Organization> orgs = [
    Organization(
        path: 'images/aghakhan-foundation.png', name: 'Agha Khan Foundation', location:"International", phoneNumber: "(051) 111 253 254"
    ),
    Organization(
        path: 'images/al-ameen.jpg', name: 'Al-Ameen Trust', location: "Near Civic Center Karachi", phoneNumber: "0800-26336"
    ),
    Organization(
        path: 'images/eidhi-foundation.jpg', name: 'Eidhi Foundation', location: "Lahore, Pakistan", phoneNumber: "(042) 35156363"
    ),
    Organization(
        path: 'images/mustafa-trust.png', name: 'Al-Mustafa Trust', location: "Scheme 3, Rawalpindi", phoneNumber: "(051) 5598743"
    ),

  ];


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
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: orgs.length,
                    itemBuilder: (BuildContext context, int index){
                      final Organization org = orgs[index];
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => OrgDetailScreen(
                                org: org,
                              )));
                        },
                        child: Card(
                          child: Image.asset(orgs[index].path, fit: BoxFit.fill),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          margin: EdgeInsets.all(10),
                        ),
                      );
                    }
                )
            ),
          ],
        ),
      ),
    );
  }
}