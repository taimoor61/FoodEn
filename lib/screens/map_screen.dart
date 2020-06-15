import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geocoder/geocoder.dart';
import 'dart:math';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


const LatLng DEST = LatLng(30.195560, 71.475280);

class MyMap extends StatefulWidget {

  MyMap({this.location = "", this.id = ""});

  final String location;
  final String id;



  @override
  State<MyMap> createState() => MyMapSampleState();
}

class MyMapSampleState extends State<MyMap> {

  final Map<String, Marker> _markers = {};
  GoogleMapController _controller;
  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor personLocationIcon;
  StreamSubscription locationSubscription;
  Location locationTracker = Location();
  Circle circle;
  String status;
  int pushCount = 0;
  int popCount = 0;

  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  final Firestore db = Firestore.instance;
  
  double currLat, currLon, destLat, destLon, distance;

  LatLng _initPosition = LatLng(40.688841, -74.044015);

  FirebaseUser loggedInUser;

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png');

    personLocationIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
        'assets/current_location_person.png');
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
  void initState() {
    super.initState();
    setCustomMapPin();
    updateGoogleMap();
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.events[0].location);
    return new Scaffold(
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: GoogleMap(
        mapType: MapType.terrain,
        initialCameraPosition: CameraPosition(
          target: _initPosition,
          zoom: 11,
        ),
        onMapCreated: (GoogleMapController controller){
          _controller = controller;
        },
        markers: _markers.values.toSet(),
        circles: Set.of((circle != null) ? [circle] : []),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: updateGoogleMap,
      //   tooltip: 'Get Location',
      //   child: Icon(Icons.my_location),
      // ),
    );
  }


  void updateGoogleMap()  async{

    var currentLocation = await locationTracker.getLocation();
    updateMarkerAndCircle(currentLocation);

    if (widget.location.isEmpty){
      return;
    }
    else{
      reverseGeocoding();
    }

    if(locationSubscription != null){
      locationSubscription.cancel();
    }

    locationSubscription = locationTracker.onLocationChanged.listen((newLocalData) {
      if(_controller != null){
        _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
            bearing: 192.833490,
            target: LatLng(newLocalData.latitude, newLocalData.longitude),
            tilt: 0,
            zoom: 11.0)));
        updateMarkerAndCircle(newLocalData);
      }
      currLat = newLocalData.latitude;
      currLon = newLocalData.longitude;

      distance = findDistance(currLat, currLon, destLat, destLon);
      if(distance <= 0.1){
        status = "Done";
        print(status);
        pushCount++;
        _displayDialog(context);
      }
    });
//    setState(() {
//      _initPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
//    });
//
//    setState(() {
//      CameraPosition newtPosition = CameraPosition(
//        target: LatLng(currentLocation.latitude, currentLocation.longitude),
//        zoom: 14,
//      );
//      _markers.clear();
//      final marker1 = Marker(
//        markerId: MarkerId("curr_loc"),
//        position: LatLng(currentLocation.latitude, currentLocation.longitude),
//        infoWindow: InfoWindow(title: 'Your Location'),
//      );
//      _markers["Current Location"] = marker1;

//      final marker2 = Marker(
//        markerId: MarkerId("dest_loc"),
//        position: DEST,
//        infoWindow: InfoWindow(title: 'DESTINATION'),
//        icon: pinLocationIcon,
//      );
//
//      _markers["Destination Location"] = marker2;
//      cont.animateCamera(CameraUpdate.newCameraPosition(newtPosition));
//    });
  }

  @override
  void dispose() {
    if (locationSubscription != null) {
      locationSubscription.cancel();
    }
    super.dispose();
  }

  void reverseGeocoding() async {
    print(widget.location);
    var address = await Geocoder.local.findAddressesFromQuery(widget.location);
    var first = address.first;
    var coord = first.coordinates;
    print ("${first.coordinates}");

    LatLng dest = LatLng(coord.latitude, coord.longitude);
    print(dest);

    destLat = dest.latitude;
    destLon = dest.longitude;

    final marker2 = Marker(
      markerId: MarkerId("dest_loc"),
      position: dest,
      infoWindow: InfoWindow(title: widget.location),
      icon: pinLocationIcon,
    );
    setState(() {
      _markers["Destination Location"] = marker2;
    });


  }

  void updateMarkerAndCircle(LocationData newLocationData){
    LatLng latLng = LatLng(newLocationData.latitude, newLocationData.longitude);
    this.setState(() {
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: latLng,
        rotation: newLocationData.heading,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
        infoWindow: InfoWindow(title: "Current Location"),
        //icon: personLocationIcon,
      );
      _markers["Current Location"] = marker;
    });

    circle = Circle(
      circleId: CircleId("pin"),
      radius: newLocationData.accuracy,
      zIndex: 1,
      strokeColor: Colors.blue,
      center: latLng,
      fillColor: Colors.blue.withAlpha(70)
    );
  }


  double findDistance(double clat, double clon, double dlat, double dlon){
    clat = clat * (pi/180);
    clon = clon * (pi/180);
    dlat = dlat * (pi/180);
    dlon = dlon * (pi/180);

    double lonDistance = dlon - clon;
    double latDistance = dlat - clat;

    double a = pow(sin(latDistance/2), 2) +
               cos(clat) * cos(dlat) *
               pow(sin(lonDistance/2), 2);

    double c = 2 * asin(sqrt(a));

    double r = 6371;

    return c * r;
  }


  void updateStatus() async{
    
    //var fireBaseUser = await FirebaseAuth.instance.currentUser();
    
    _firestore.collection("events").document(widget.id).updateData({"handled" : true}).then((result) {
      print("status updates");
    }).catchError((onError){
      print(onError);
      });

   // db.collection("events").document(loggedInUser.uid).updateData({'handled' : true});
  }

  _displayDialog(BuildContext context){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Order Recieved?"),
          actions: [
            new FlatButton(
              child: Text('No'),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: Text('Yes'),
              onPressed: (){
                updateStatus();
                Navigator.of(context).popUntil((route){
                  return popCount++ == pushCount + 3;
                });
              },
            ),
          ],
        );
      },
    );

  }
  
}