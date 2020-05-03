import 'package:flutter/material.dart';
import 'package:fooden/models/events.dart';
import 'package:fooden/screens/add_event_screen.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  List<Event> events = [
    Event(
        amount: 5,
        volunteerRequired: 2,
        description: "Left over burgers and pizza",
        isHandled: true),
    Event(
        amount: 10,
        volunteerRequired: 2,
        description: "Left over food from a marriage hall"),
    Event(
        amount: 15,
        volunteerRequired: 3,
        description: "Prepared food to be distributed among the needy",
        isHandled: true),
    Event(
        amount: 2,
        volunteerRequired: 1,
        description: "Some leftover food",
        isHandled: true),
  ];

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
                      child: AddEventScreen((event) {
                        setState(() {
                          events.add(event);
                        });
                      }),
                    )));
          }),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          final Event event = events[index];
          return GestureDetector(
            onLongPress: (){
              setState(() {
                events.remove(event);
              });
            },
            child: Container(
              margin: EdgeInsets.all(
                  5.0), //only(top: 5.0, bottom: 5.0, right: 20.0, left: 5.0),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: event.isHandled ? Color(0xFFebffe8) : Color(0xFFFFEFEE),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
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
                            fontWeight: FontWeight.bold),
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
          );
        },
      ),
    );
  }
}
