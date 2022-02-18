import 'package:car_care/map_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapPage extends StatefulWidget {
  MapPage({Key? key}) : super(key: key);
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
    getLoc();
  }

  late LocationData _currentPosition;
  late CameraPosition _initialcameraposition;
  // late PolylinePoints polylinePoints;
  // List<LatLng> polylineCoordinates = [];
  // final Set<Polyline> _polyline = {};
  // _createPolylines(
  //   double startLatitude,
  //   double startLongitude,
  //   double destinationLatitude,
  //   double destinationLongitude,
  // ) async {
  //   // Initializing PolylinePoints
  //   polylinePoints = PolylinePoints();

  //   List<LatLng> routeCoords = [];
  //   PolylinePoints googleMapPolyline = PolylinePoints();
  //   var res = await googleMapPolyline.getRouteBetweenCoordinates(
  //       "AIzaSyBIyloiIsMJHo7N-Cbbp8oWyGG8iDjD9jg",
  //       PointLatLng(startLatitude, startLongitude),
  //       PointLatLng(destinationLatitude, destinationLongitude));

  //   print(res.status);
  //   print(res.errorMessage);
  //   // Generating the list of coordinates to be used for
  //   // drawing the polylines

  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     "AIzaSyBIyloiIsMJHo7N-Cbbp8oWyGG8iDjD9jg", // Google Maps API Key
  //     PointLatLng(startLatitude, startLongitude),
  //     PointLatLng(destinationLatitude, destinationLongitude),
  //   );

  //   // Adding the coordinates to the list
  //   if (result.points.isNotEmpty) {
  //     result.points.forEach((PointLatLng point) {
  //       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //     });
  //   }

  //   // Defining an ID
  //   PolylineId id = const PolylineId('poly');

  //   // Initializing Polyline
  //   Polyline polyline = Polyline(
  //     polylineId: id,
  //     color: Colors.red,
  //     points: polylineCoordinates,
  //     width: 3,
  //   );

  //   _polyline.add(polyline);
  //   // Adding the polyline to the map
  //   // polylines[id] = polyline;
  // }
  int ch = 0;
  final Set<Marker> _markers = {};
  List<dynamic> _contacts = [];
  Location geolocation = Location();
  Future getLoc() async {
    _currentPosition = await geolocation.getLocation();
    var res = await FirebaseFirestore.instance.collection('workshop').get();
    _contacts = [];
    _initialcameraposition = CameraPosition(
      target: LatLng(_currentPosition.latitude!, _currentPosition.longitude!),
      zoom: 14.4746,
    );
    for (var element in res.docs) {
      GeoPoint geoPoint = element['location'];
      double lat = geoPoint.latitude;
      double lng = geoPoint.longitude;
      LatLng latLng = LatLng(lng, lat);
      var _id = element.id;
      _contacts.add({
        "location": LatLng(lat, lng),
        "id": _id,
        "name": element['workshopName']
      });
      // await _createPolylines(
      //     _currentPosition.latitude!, _currentPosition.longitude!, lat, lng);
    }
    _contacts.add({
      "location":
          LatLng(_currentPosition.latitude!, _currentPosition.longitude!),
      "id": '1',
      "name": 'mylocation'
    });

    return _currentPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Services Maps'),
          backgroundColor: Colors.yellow[800],
        ),
        body: FutureBuilder(builder: (context, snapshot) {
          if (ch == 0) {
            createMarkers(context);
            return _contacts.isEmpty
                ? const Center(
                    child: Text('No Locations Founded'),
                  )
                : Stack(
                    children: [
                      GoogleMap(
                          // polylines: _polyline,
                          initialCameraPosition: _initialcameraposition,
                          markers: _markers,
                          myLocationButtonEnabled: false,
                          onMapCreated: _onMapCreated),
                    ],
                  );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }));
  }

  createMarkers(BuildContext context) {
    Marker marker;

    _contacts.forEach((contact) async {
      marker = Marker(
        markerId: MarkerId(contact['id']),
        position: contact['location'],
        icon: BitmapDescriptor.defaultMarker,
        // icon: await _getAssetIcon(context).then((value) => value),
        infoWindow: InfoWindow(title: contact['name'], onTap: () {}),
      );

      _markers.add(marker);
    });
  }

  late GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      controller.setMapStyle(MapStyle().aubergine);
    });
  }
}
