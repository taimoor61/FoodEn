import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooden/models/events.dart';
import 'package:fooden/screens/map_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';


int _index = 0;
Set<Marker> _markers = {};
String indexMarker;
ValueNotifier valueNotifier = ValueNotifier(indexMarker);

List<LatLng> point;

class AllEventMap extends StatefulWidget{

  AllEventMap({this.events});
  final List<Event> events;

  @override
  State<AllEventMap> createState() => _AllEventMap();
}

class _AllEventMap extends State<AllEventMap>{



  GoogleMapController mapController;
  Completer<GoogleMapController> completerController = Completer();


  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor normalMarker;
  BitmapDescriptor selectedMarker;

  CameraPosition newCameraPosition;

  Location locationTracker = Location();

  LatLng _initPosition = LatLng(40.688841, -74.044015);
  LatLng newPosition;





  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png');
    normalMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/normalMarker.png');
    selectedMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/selectedMarker.png');
  }

  @override
  void initState() {
    setCustomMapPin();
    updateGoogleMap();
    getMarkers();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print("in maps: ${widget.events.length}");
    return StreamBuilder<String>(
      initialData: "0",
      builder: (context, snapshot){
        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: ValueListenableBuilder(
                  valueListenable: valueNotifier,
                  builder: (context, value, child){
                    return GoogleMap(
                      zoomControlsEnabled: false,
                      markers: _markers,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _initPosition,
                        zoom: 11.0,
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 78),
                  child: SizedBox(
                    height: 180,
                    child: PageView.builder(
                      itemCount: widget.events.length,
                      controller: PageController(viewportFraction: 0.9),
                      onPageChanged: (int index){
                        setState(() {
                          _index = index;
                        });
                        indexMarker = widget.events[index].id;
                        if(widget.events[index].latitude != null && widget.events[index].longitude != null){
                          newPosition = LatLng(double.tryParse(widget.events[index].latitude), double.tryParse(widget.events[index].longitude));
                          newCameraPosition = CameraPosition(target: newPosition, zoom: 15);
                        }
                        getMarkers();
                        mapController.animateCamera(
                            CameraUpdate.newCameraPosition(newCameraPosition)
                        ).then((value) {
                          setState(() {

                          });
                        });
                      },
                      itemBuilder: (_, i){
                        return Transform.scale(
                          scale: i == _index ? 1 : 0.9,
                          child: new Container(
                            height: 116.0,
                            width: 400.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0.5, 0.5),
                                  color: Color(0xff000000).withOpacity(0.12),
                                  blurRadius: 20,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 9, top: 7, bottom: 7, right:  9),
                                  child: Container(
                                    height: 86,
                                    width: 86,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage('assets/selectedMarker.png'),
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 12, right: 0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Wrap(
                                        alignment: WrapAlignment.start,
                                        spacing: 2,
                                        direction: Axis.vertical,
                                        children: [
                                          Container(
                                            child: Text(
                                              widget.events[i].location,
                                              overflow: TextOverflow.clip,
                                              maxLines: 3,
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            width: 230,
                                          ),
                                          Container(
                                            width: 230,
                                            child: Text(
                                              "Description: ${widget.events[i].description}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 4,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 230,
                                            child: Text(
                                              "Volunteers: ${widget.events[i].volunteerRequired}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 150,
                                            height: 15,
                                            child: Text(
                                              "Food Amount: ${widget.events[i].amount} kg",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 200,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                            ),
                                            child: FlatButton(
                                              child: Text(
                                                'Start',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              color: Colors.red,
                                              onPressed: (){
                                                _displayDialog(context, widget.events[i].location, widget.events[i].id);
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },

//    GoogleMap(
//      mapType: MapType.terrain,
//      initialCameraPosition: CameraPosition(
//        target: _initPosition,
//        zoom: 11,
//      ),
//      onMapCreated: _onMapCreated,
//      markers: _markers,
//    ),
    );

  }

  void updateGoogleMap() async{

    //_markers.clear();
    //point.clear();
    print("length ${widget.events.length}");
//      for(int i = 0; i<widget.events.length; i++){
//        reverseGeoCodeAll(widget.events[i].location, widget.events[i].id);
//        print("going in reverse geocoding");
//      }

    var currentLocation = await locationTracker.getLocation();

    setState(() {
      _initPosition = LatLng(currentLocation.latitude, currentLocation.longitude);

      newCameraPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 11,
      );
      mapController.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
    });
//
//
//    final marker1 = Marker(
//        markerId: MarkerId("curr_loc"),
//        position: LatLng(currentLocation.latitude, currentLocation.longitude),
//        infoWindow: InfoWindow(title: 'Your Location'),
//    );
//    setState(() {
//      _markers.add(marker1);
//    });
//
//

  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    completerController.complete(controller);
  }

  void reverseGeoCodeAll(String location, String id) async{
    var address = await Geocoder.local.findAddressesFromQuery(location);
    var first = address.first;
    var coord = first.coordinates;
    //print ("${first.coordinates}");

    String abc = '${first.thoroughfare}, ${first.featureName}, ${first.locality}, ${first.adminArea}';
    LatLng dest = LatLng(coord.latitude, coord.longitude);
    print("dest: $dest");

    point.add(dest);
    print(point);

//
//    setState(() {
//      //_markers.clear();
//      widget.events.forEach((element) {
//        if(element.id == indexMarker){
//          _markers.add(Marker(
//            markerId: MarkerId(location),
//            position: dest,
//            infoWindow: InfoWindow(title: location),
//            icon: selectedMarker,
//          ));
//        }else {
//          _markers.add(Marker(
//            markerId: MarkerId(location),
//            position: dest,
//            infoWindow: InfoWindow(title: location),
//            icon: selectedMarker,
//          ));
//        }
//      });
//
//      valueNotifier.value = indexMarker;
//    });


//    final marker = Marker(
//      markerId: MarkerId(location),
//      position: dest,
//      infoWindow: InfoWindow(title: location),
//      icon: pinLocationIcon,
//      onTap: (){
//          _displayDialog(context, abc, id);
//      }
//    );
//    setState(() {
//      _markers.add(marker);
//    });
  }

  void getMarkers() async {

    _markers = {};

    for (int i = 0; i<widget.events.length; i++){
      if(widget.events[i].id == indexMarker){
        setState(() {
          _markers.add(Marker(
            draggable: false,
            markerId: MarkerId(widget.events[i].location),
            position: LatLng(double.tryParse(widget.events[i].latitude), double.tryParse(widget.events[i].longitude)),
            icon: selectedMarker,
            infoWindow: InfoWindow(title: widget.events[i].location),
          ));
        });

      }else{
        setState(() {
          _markers.add(Marker(
            draggable: false,
            markerId: MarkerId(widget.events[i].location),
            position: LatLng(double.tryParse(widget.events[i].latitude), double.tryParse(widget.events[i].longitude)),
            icon: normalMarker,
            infoWindow: InfoWindow(title: widget.events[i].location),
          ));
        });

      }
    }

    setState(() {
      valueNotifier.value = indexMarker;
    });

  }

  _displayDialog(BuildContext context, String location, String id){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Start order?"),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyMap(location: location, id: id,)));
              },
            ),
          ],
        );
      },
    );

  }
}