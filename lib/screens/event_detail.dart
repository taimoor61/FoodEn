import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooden/constants.dart';
import 'package:fooden/models/events.dart';
import 'package:fooden/screens/map_screen.dart';
import 'package:fooden/screens/static_map_screen.dart';

class EventDetail extends StatelessWidget {
  EventDetail({@required this.event});

  final Event event;

  final String googleMapsAPIKey = 'AIzaSyBsi_TlNeNMlTMdyOv8BJPVA4S7OkVUmj8';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(

      appBar: AppBar(
        title: Center(
          child: Text(
            "Event Details",
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Positioned(
                  left: 0.1,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: event.isHandled ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text(
                      event.isHandled ? "Done" : "Pending",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Image(
                  alignment: Alignment.center,
                  image: AssetImage('images/app_data.png'),
                  height: size.height * 0.25,
                  width: size.width * 1.5,
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Card(
                        elevation: 10.0,
                        child: Container(
                          width: size.width * 0.4,
                          height: size.height * 0.05,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                          ),
                          child: Center(
                            child: Text(
                              "Amount: ${event.amount}",
                              style: kEventDetailTextStyle,
                            ),
                          ),
                        ),
                      ),
                      Card(
                        elevation: 10.0,
                        child: Container(
                          width: size.width * 0.4,
                          height: size.height * 0.05,
                          color: Colors.grey.shade200,
                          child: Center(
                            child: Text(
                              "Volunteers: ${event.volunteerRequired}",
                              style: kEventDetailTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Card(
                    elevation: 10.0,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      width: double.infinity,
                      height: size.height * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        //borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Center(
                            child: Text(
                              "Description",
                              style: kEventDetailTextStyle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              event.description,
                              textAlign: TextAlign.center,
                              style: kEventDetailTextStyle.copyWith(
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Expanded(
                    flex: 4,
                    child: Card(
                      elevation: 10.0,
                      child: Container(
                        child:
                        StaticMap(
                          location: event.location,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Expanded(
                    flex: 1,
                    child: FlatButton(
                      child: Text(
                        'Show on Maps',
                        style:TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Colors.red,
                      onPressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => MyMap(
                          location: event.location,
                        )));
                        MyMap(location: event.location);
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

//MyMap(
//location: event.location,
//),