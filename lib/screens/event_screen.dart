import 'package:flutter/material.dart';
import 'package:fooden/models/events.dart';

class EventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          final Event event = events[index];
          return Container(
            margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            decoration: BoxDecoration(
                color: event.isHandled ? Color(0xFFebffe8) : Color(0xFFFFEFEE),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                )),
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
                  event.isHandled ? SizedBox.shrink(): Container(
                    width: 40.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.red),
                    alignment: Alignment.center,
                    child: Text(
                      "NEW",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ])
              ],
            ),
          );
        },
      ),
    );
  }
}
