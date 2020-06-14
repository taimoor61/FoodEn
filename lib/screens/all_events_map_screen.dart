import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooden/models/events.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';

class AllEventMap extends StatefulWidget{

  AllEventMap({this.events});
  final List<Event> events;

  @override
  State<AllEventMap> createState() => _AllEventMap();
}

class _AllEventMap extends State<AllEventMap>{

  final Map<String, Marker> _markers = {};
  GoogleMapController _controller;
  BitmapDescriptor pinLocationIcon;
  CameraPosition newPosition;
  Location locationTracker = Location();
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
    // TODO: implement build
  return new Scaffold(
    body: GoogleMap(
      mapType: MapType.terrain,
      initialCameraPosition: CameraPosition(
        target: _initPosition,
        zoom: 11,
      ),
      onMapCreated: (GoogleMapController controller){
        this._controller = controller;
      },
      markers: _markers.values.toSet(),
    ),
  );

  }

  void updateGoogleMap() async{

    _markers.clear();

    for(int i = 0; i<widget.events.length; i++){
      reverseGeoCodeAll(widget.events[i].location);
    }
    var currentLocation = await locationTracker.getLocation();

    setState(() {
      _initPosition = LatLng(currentLocation.latitude, currentLocation.longitude);

      newPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 11,
      );
    });


    final marker1 = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
    );
    setState(() {
      _markers["Current Location"] = marker1;
    });


    _controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));
  }

  void reverseGeoCodeAll(String location) async{
    var address = await Geocoder.local.findAddressesFromQuery(location);
    var first = address.first;
    var coord = first.coordinates;
    //print ("${first.coordinates}");

    LatLng dest = LatLng(coord.latitude, coord.longitude);
    print(dest);

    final marker = Marker(
      markerId: MarkerId(location),
      position: dest,
      infoWindow: InfoWindow(title: location),
      icon: pinLocationIcon,
    );
    setState(() {
      _markers[location] = marker;
    });
  }
}