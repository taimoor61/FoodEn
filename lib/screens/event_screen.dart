import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooden/constants.dart';
import 'package:fooden/models/events.dart';
import 'package:fooden/screens/add_event_screen.dart';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fooden/screens/event_detail.dart';
// import 'package:fooden/screens/volunteer_screen.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  FirebaseUser loggedInUser;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
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
        title: Center(child: Text("Events")),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                  child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: AddEventScreen((Event event) {
                  _firestore.collection('events').add({
                    'amount': event.amount,
                    'description': event.description,
                    'email': loggedInUser.email,
                    'handled': false,
                    'volunteers': event.volunteerRequired,
                    'location': event.location,
                    'latitude': event.latitude,
                    'longitude': event.longitude,
                  });
                }),
              )),
            );
          }),
      body: loggedInUser == null
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueGrey,
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('events')
                  .where("email", isEqualTo: loggedInUser.email)
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
                      latitude: document.data['latitude'],
                      longitude: document.data['longitude'],
                    ),
                  );
                }
                return getListViewBuilder(events);
              },
            ),
    );
  }
}

ListView getListViewBuilder(List<Event> events) {
  return ListView.builder(
    shrinkWrap: true,
    itemCount: events.length,
    itemBuilder: (BuildContext context, int index) {
      final Event event = events[index];
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EventDetail(event: event)),
            );
          },
          child: Container(
            decoration: kEventBoxDecoration,
            child: Dismissible(
              onDismissed: (direction) {
                Firestore.instance
                    .collection('events')
                    .document(event.id)
                    .delete()
                    .catchError((e) {
                  print(e);
                });
              },
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: kEventBoxDecoration,
                child: Transform.rotate(
                  angle: 45 * math.pi / 180,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2.0, color: Colors.white),
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              key: UniqueKey(),
              child: Container(
                //margin: EdgeInsets.all(5.0),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: kEventBoxDecoration.copyWith(
                  color: event.isHandled
                      ? Color(0xFFebffe8)
                      : Colors.grey
                          .shade100, //Color(0xFFFFEFEE), //Color(0xFFebffe8)
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
                        // Text(
                        //   event.location,
                        //   style: TextStyle(
                        //     fontSize: 15.0,
                        //     color: event.isHandled ? Colors.green : Colors.red,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
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
                    Expanded(
                      child: Column(children: <Widget>[
                        Text(
                          event.amount.toString() + 'kg',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          width: 55.0,
                          height: 20.0,
                          padding: EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: event.isHandled ? Colors.green : Colors.red,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            event.isHandled ? "Done" : "Pending",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ]),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
