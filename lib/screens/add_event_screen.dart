import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooden/constants.dart';
import 'package:fooden/models/event_data.dart';
import 'package:fooden/models/events.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'alert_dialog_with_message.dart';

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
  LatLng tapMarker;

  String destLatitude;
  String destLongitude;

  int pushCount = 0;
  int popCount = 0;

  GoogleMapController controller;
  final Set<Marker> markers = {};

  TextEditingController popUpTextEditor = TextEditingController();

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                  Text(
                    'OR',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      'Add manually',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: Colors.green,
                    onPressed: () => _displayDialog(context),
                  ),
                ],
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
                onPressed: () async {
                  if (manualLocation == "") {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialogWithMessage(
                        title: "Location Error",
                        message: 'Message: No Location Added',
                      ),
                    );
                  } else {
                    Event event = Event(
                      amount: currentWeight,
                      volunteerRequired: volunteers,
                      isHandled: false,
                      description: description,
                      location: manualLocation,
                      latitude: destLatitude,
                      longitude: destLongitude,
                    );

                    widget.callback(event);
                    Navigator.pop(context);
                  }
                },
              ),
              SizedBox(
                height: 20.0,
              )
            ],
          ),
        ));
  }

  getUserLocation() async {
    //call this async method from where ever you need

    LocationData myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } catch (e) {
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
    final coordinates =
        new Coordinates(myLocation.latitude, myLocation.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(
        '  ${first.thoroughfare}, ${first.featureName}, ${first.locality}, ${first.adminArea}');
    setState(() {
      manualLocation =
          '${first.thoroughfare}, ${first.featureName}, ${first.locality}, ${first.adminArea}';
      destLatitude = "${myLocation.latitude}";
      destLongitude = "${myLocation.longitude}";
    });
    return first;
  }

  _displayDialog(BuildContext context) async {
    var location = await Geolocator().getCurrentPosition();
    LatLng pos = LatLng(location.latitude, location.longitude);
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField in Dialog'),
            content: displayMap(pos),
//            TextField(
//              controller: popUpTextEditor,
//              decoration: InputDecoration(hintText: "Enter location"),
//            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).popUntil((route) {
                    return popCount++ == pushCount + 1;
                  });
                  setState(() {
                    popCount = 0;
                    pushCount = 0;
                    manualLocation = "";
                  });
                },
              ),
              new FlatButton(
                child: new Text('Save'),
                onPressed: () {
                  setState(() {
                    geoCode(tapMarker);
                  });
                  Navigator.of(context).popUntil((route) {
                    return popCount++ == pushCount + 1;
                  });
                  setState(() {
                    popCount = 0;
                    pushCount = 0;
                  });
                },
              ),
            ],
          );
        });
  }

  void addMarker(LatLng latLng) {
    setState(() {
      markers.add(Marker(
        markerId: MarkerId("location"),
        position: latLng,
        infoWindow: InfoWindow(title: "Location"),
        icon: BitmapDescriptor.defaultMarker,
      ));
      tapMarker = latLng;
      print("tapmarker: $tapMarker");
      pushCount++;
      _displayDialog(context);
    });
  }

  Widget displayMap(LatLng pos) {
    return GoogleMap(
      mapType: MapType.terrain,
      initialCameraPosition: CameraPosition(
        target: pos,
        zoom: 14,
      ),
      onMapCreated: (GoogleMapController controller) {
        this.controller = controller;
      },
      onTap: (latLng) {
        if (markers.length >= 1) {
          setState(() {
            markers.clear();
            //tapMarker = latLng;
          });
        }
        addMarker(latLng);
      },
      myLocationEnabled: true,
      markers: this.markers,
      tiltGesturesEnabled: false,
    );
  }

  void geoCode(LatLng latLng) async {
    final coordinates = new Coordinates(latLng.latitude, latLng.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(
        '  ${first.thoroughfare}, ${first.featureName}, ${first.locality}, ${first.adminArea}');
    setState(() {
      manualLocation =
          '${first.thoroughfare}, ${first.featureName}, ${first.locality}, ${first.adminArea}';

      destLatitude = "${latLng.latitude}";
      destLongitude = "${latLng.longitude}";

    });
  }
}
//
//,, ${first.subAdminArea}, ${first.addressLine}, ,, ${first.subThoroughfare}
