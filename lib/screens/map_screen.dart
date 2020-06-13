import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:geocoder/geocoder.dart';
import 'dart:math';
import 'package:location/location.dart';
import 'package:vector_math/vector_math_operations.dart';

const LatLng DEST = LatLng(30.195560, 71.475280);

class MyMap extends StatefulWidget {

  MyMap({this.location = ""});

  final String location;



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

  LatLng _initPosition = LatLng(40.688841, -74.044015);

  

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png');

    personLocationIcon = await BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
        'assets/current_location_person.png');
  }



  @override
  void initState() {
    super.initState();
    setCustomMapPin();
    updateGoogleMap();
  }

  @override
  Widget build(BuildContext context) {
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
            zoom: 18.0)));
        updateMarkerAndCircle(newLocalData);
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

    final marker2 = Marker(
      markerId: MarkerId("dest_loc"),
      position: dest,
      infoWindow: InfoWindow(title: 'DESTINATION'),
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


}