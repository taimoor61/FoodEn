import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fooden/constants.dart';
import 'package:fooden/models/events.dart';

class VolunteerScreen extends StatefulWidget {
  @override
  _VolunteerScreenState createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends State<VolunteerScreen> {

  final _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Volunteer")),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.grey.shade400,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            width: double.infinity,
            child: Text("Events",style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
          ),
          StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('events')
                      .where("handled", isEqualTo: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: Text("Such Empty"));
                    }
                    final documents = snapshot.data.documents.reversed;
                    List<Event> events = [];
                    for (var document in documents) {
                      events.add(
                        Event(
                          amount: document.data['amount'],
                          volunteerRequired: document.data['volunteers'],
                          description: document.data['description'],
                          isHandled: document.data['handled'],
                          location: document.data['location'],
                          id: document.documentID,
                        ),
                      );
                    }
                    return getListViewBuilder(events);
                  },
                ),
        ],
      )
    );
  }
}

ListView getListViewBuilder(List<Event> events) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: events.length,
    itemBuilder: (BuildContext context, int index) {
      final Event event = events[index];
      return GestureDetector(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => MyMap(
          //       location: event.location,
          //     ),
          //   ),
          // );
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          decoration: kEventBoxDecoration.copyWith(
            color: Colors.grey.shade100,//Color(0xFFebffe8)
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 2.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Task # " + (index + 1).toString(),
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      event.description,
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Text(
                event.amount.toString() + 'kg',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}