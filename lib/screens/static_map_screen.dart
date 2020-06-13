import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class StaticMap extends StatefulWidget {

  StaticMap({this.location = ""});

  final String location;


  @override
  State<StaticMap> createState() => MyStaticMap();
}
  class MyStaticMap extends State<StaticMap>{

  final Map<String, Marker> _markers = {};
  GoogleMapController _controller;
  BitmapDescriptor pinLocationIcon;
  LatLng destination;

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png');
  }

  @override
  void initState(){
    super.initState();
    setCustomMapPin();
    reverseGeocoding();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: GoogleMap(
        mapType: MapType.terrain,
        initialCameraPosition: CameraPosition(
          target: destination,
          zoom: 14,
        ),
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller){
          _controller = controller;
        },
        markers: _markers.values.toSet(),
      ),
    );
  }

  void reverseGeocoding() async {
    print(widget.location);
    var address = await Geocoder.local.findAddressesFromQuery(widget.location);
    var first = address.first;
    var coord = first.coordinates;
    print ("${first.coordinates}");

    destination = LatLng(coord.latitude, coord.longitude);
    print(destination);

    final marker2 = Marker(
      markerId: MarkerId("dest_loc"),
      position: destination,
      infoWindow: InfoWindow(title: 'DESTINATION'),
      icon: pinLocationIcon,
    );
    setState(() {
      _markers["Destination Location"] = marker2;
    });

  }
}