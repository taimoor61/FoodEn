import 'package:flutter/material.dart';
import 'package:fooden/constants.dart';
import 'package:fooden/models/event_data.dart';
import 'package:fooden/models/events.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';


class AddEventScreen extends StatefulWidget {
  AddEventScreen(this.callback);

  final Function callback;
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  int currentWeight = weightList[0];
  int volunteers = 1;
  String description = "";
  String manualLocation = "";


  List<DropdownMenuItem> getWeightDropDownItems() {
    List<DropdownMenuItem<int>> dropList = [];
    for (int i = 0; i < weightList.length; ++i) {
      dropList.add(
        DropdownMenuItem(
          child: Text(
            weightList[i].toString() +
                ((i == weightList.length - 1)
                    ? "+"
                    : ("-" + weightList[i + 1].toString())) +
                " kg",
          ),
          value: weightList[i],
        ),
      );
    }
    return dropList;
  }

  List<DropdownMenuItem> getVolunteerDropDownItems() {
    List<DropdownMenuItem<int>> dropList = [];
    for (int i = 0; i < 10; ++i) {
      dropList.add(
        DropdownMenuItem(
          child: Text(
            (i + 1).toString(),
          ),
          value: i + 1,
        ),
      );
    }
    return dropList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFF757575),
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "Add Event",
                style: kEventTextFieldStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Food Amount",
                    style: kEventTextFieldStyle.copyWith(color: Colors.black),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  DropdownButton<int>(
                    value: currentWeight,
                    items: getWeightDropDownItems(),
                    onChanged: (value) {
                      setState(() {
                        currentWeight = value;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Volunteers",
                    style: kEventTextFieldStyle.copyWith(color: Colors.black),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  DropdownButton<int>(
                    value: volunteers,
                    items: getVolunteerDropDownItems(),
                    onChanged: (value) {
                      setState(() {
                        volunteers = value;
                      });
                    },
                  ),
                ],
              ),
              TextField(
                onChanged: (value) {
                  description = value;
                },
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Description",
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "Location",
                style: kEventTextFieldStyle,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                manualLocation,
                style: kEventTextFieldStyle.copyWith(color: Colors.black),
              ),
              SizedBox(
                height: 10.0,
              ),
              FlatButton(
                child: Text(
                  'Get Location',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                color: Colors.red,
                onPressed: () {
                  getUserLocation();
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              FlatButton(
                child: Text(
                  "Add",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                color: Colors.lightBlueAccent,
                onPressed: () {
                  Event event = Event(
                    amount: currentWeight,
                    volunteerRequired: volunteers,
                    isHandled: false,
                    description: description,
                    location: manualLocation,
                  );
                  widget.callback(event);
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 20.0,)
            ],
          ),
        ));
  }

  getUserLocation() async {//call this async method from where ever you need

    LocationData myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    }catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }
      myLocation = null;
    }
    final coordinates = new Coordinates(
        myLocation.latitude, myLocation.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(
        coordinates);
    var first = addresses.first;
    print('  ${first.thoroughfare}, ${first.featureName}, ${first.locality}, ${first.adminArea}');
    setState(() {
      manualLocation = '${first.thoroughfare}, ${first.featureName}, ${first.locality}, ${first.adminArea}';
    });
    return first;
  }
}
//
//,, ${first.subAdminArea}, ${first.addressLine}, ,, ${first.subThoroughfare}