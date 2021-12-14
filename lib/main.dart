import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();


  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  List<LatLng> polygonLatLngs = <LatLng>[];
  int _polygonIdCounter =1;




  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

 @override
 void initState() {
    // TODO: implement initState
    super.initState();
    _setMarker(LatLng(37.43296265331129, -122.08832357078792));
    
  }
  void _setMarker(LatLng point){
   _markers.add(Marker(markerId: const MarkerId('marker'),
     position:point
   ));
  }
  void _setPolygon(){
   final String polygonIdVal = 'polygon_$_polygonIdCounter';
   _polygonIdCounter++;
   _polygons.add(Polygon(polygonId:PolygonId(polygonIdVal),
     points: polygonLatLngs,
     strokeWidth: 2,
     strokeColor: Colors.blue,
     fillColor: Colors.red.withOpacity(.4)

   ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        polygons: _polygons,
        markers: _markers,
        mapType: MapType.satellite,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onTap: (point){
          setState(() {
            polygonLatLngs.add(point);
            _setPolygon();

          });


        },
      ),

    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
