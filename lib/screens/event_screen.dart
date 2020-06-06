import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooden/constants.dart';
import 'package:fooden/models/events.dart';
import 'package:fooden/screens/add_event_screen.dart';
import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';

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
        title: Text("Events"),
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
                  });
                }),
              )),
            );
          }),
      body: loggedInUser == null
          ? Center(
              child: CircularProgressIndicator(),
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
        padding: EdgeInsets.all(5.0),
        child: Container(
          decoration: kEventBoxDecoration,
          child: Dismissible(
            onDismissed: (direction) {
              // if (direction == DismissDirection.endToStart) {
              //   setState(() {
              //     events.removeAt(index);
              //   });
              // }
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
                    : Color(0xFFFFEFEE), //Color(0xFFebffe8)
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
                      Text(
                        event.location,
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                  Column(children: <Widget>[
                    Text(
                      event.amount.toString() + 'kg',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    event.isHandled
                        ? Container(
                            width: 40.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Colors.green),
                            alignment: Alignment.center,
                            child: Text(
                              "Done",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : SizedBox.shrink()
                  ])
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
