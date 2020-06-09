import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:geocoder/geocoder.dart';


const LatLng DEST = LatLng(30.195560, 71.475280);

class MyMap extends StatefulWidget {

  MyMap({this.location = ""});

  final String location;

  @override
  State<MyMap> createState() => MyMapSampleState();
}

class MyMapSampleState extends State<MyMap> {

  final Map<String, Marker> _markers = {};
  Completer _controller = Completer();
  BitmapDescriptor pinLocationIcon;

  LatLng _initPosition = LatLng(40.688841, -74.044015);

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png');
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: GoogleMap(
        mapType: MapType.terrain,
        initialCameraPosition: CameraPosition(
          target: _initPosition,
          zoom: 11,
        ),
        onMapCreated: (GoogleMapController controller){
          _controller.complete(controller);
        },
        markers: _markers.values.toSet(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: updateGoogleMap,
        tooltip: 'Get Location',
        child: Icon(Icons.my_location),
      ),
    );
  }


  void updateGoogleMap()  async{

    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    if (widget.location.isEmpty){
      return;
    }
    else{
      reverseGeocoding();
    }
    setState(() {
      _initPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
    });


    GoogleMapController cont = await _controller.future;
    setState(() {
      CameraPosition newtPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 14,
      );
      _markers.clear();
      final marker1 = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
      );
      _markers["Current Location"] = marker1;

//      final marker2 = Marker(
//        markerId: MarkerId("dest_loc"),
//        position: DEST,
//        infoWindow: InfoWindow(title: 'DESTINATION'),
//        icon: pinLocationIcon,
//      );
//
//      _markers["Destination Location"] = marker2;
      cont.animateCamera(CameraUpdate.newCameraPosition(newtPosition));
    });

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


}