import 'package:car_care/http.dart';
import 'package:car_care/screens/google_map_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loca;

class AvailableWorker extends StatefulWidget {
  const AvailableWorker({Key? key, required this.type, required this.price})
      : super(key: key);
  final String type;
  final int price;
  @override
  _AvailableWorkerState createState() => _AvailableWorkerState();
}

class _AvailableWorkerState extends State<AvailableWorker> {
  TextEditingController det = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    getData();
  }

  List data = [];
  loca.Location geolocation = loca.Location();
  int ch = 0;
  late LocationData _currentPosition;
  Future getData() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await geolocation.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await geolocation.requestService();
      if (!_serviceEnabled) {}
    }

    _permissionGranted = await geolocation.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await geolocation.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {}
    }

    _currentPosition = await geolocation.getLocation();

    var res = await FirebaseFirestore.instance
        .collection('Worker')
        .where('status', isEqualTo: true)
        .get();
    List list = [];
    res.docs.forEach((element) async {
      GeoPoint position = element['location'];
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude,
          localeIdentifier: "en_US");
      Placemark place = placemarks[0];
      var Address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';

      list.add({
        'name': element['name'],
        'address': Address,
        'phone': element['phone'],
        'uid': element['uid']
      });
    });
    setState(() {
      data = list;
    });
    return ch = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Available'),
          backgroundColor: Colors.yellow[800],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.yellow[800],
          child: const Center(child: Icon(Icons.map)),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MapPage()));
          },
        ),
        body: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (ch == 0) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return data.isNotEmpty
                  ? ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ExpansionTile(
                          title: Text('Worker name:${data[index]['name']}'),
                          subtitle: const Text('tap to get more info'),
                          children: [
                            Column(
                              children: [
                                const Text(
                                  'Address:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(data[index]['address']),
                                TextButton(
                                    onPressed: () {
                                      send(data[index]);
                                    },
                                    child: const Text('Send request'))
                              ],
                            )
                          ],
                        );
                      })
                  : const Center(
                      child: Text(
                          'No available worker check map to find nearest workshop'),
                    );
            }
          },
          // builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //   if (!snapshot.hasData) {
          //     return const Center(
          //       child: CircularProgressIndicator(),
          //     );
          //   } else {

          //     if (snapshot.data!.docs.isNotEmpty) {
          //       return ListView.builder(
          //         itemCount: snapshot.data!.docs.length,
          //         itemBuilder: (BuildContext context, int index) {
          //           return ExpansionTile(
          //               title: Text(
          //                   'Worker name:${snapshot.data!.docs[index]['name']}'));
          //         },
          //       );
          //     } else {

          //     }
          //   }
          // }),
        ));
  }

  send(dynamic datas) {
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: TextFormField(
            controller: det,
            validator: (val) {
              if (val!.isEmpty) {
                return "please enter some details about your car";
              }
            },
            decoration:
                const InputDecoration(hintText: "some details about your car"),
          ),
          actions: [
            TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.only(
                        top: height / 45,
                        bottom: height / 45,
                        left: width / 10,
                        right: width / 10)),
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromRGBO(19, 26, 44, 1.0))),
                onPressed: () async {
                  if (det.text.isEmpty) {
                    setState(() {
                      Navigator.of(context).pop();
                      showBar(context, 'please enter some details', 0);
                    });
                  } else {
                    setState(() {
                      showLoadingDialog(context);
                    });
                    auth.User? user = FirebaseAuth.instance.currentUser;
                    String? name = user!.displayName;
                    double? la = _currentPosition.latitude;
                    double? lo = _currentPosition.longitude;

                    GeoPoint location = GeoPoint(la!, lo!);

                    var res = await addItem(
                      uid: user.uid,
                      name: name!,
                      type: widget.type,
                      description: det.text.trim(),
                      map_location: location,
                      price: widget.price,
                      workerid: datas['uid'],
                      workername: datas['name'],
                      workernumber: int.tryParse(datas['phone'])!,
                    );
                    if (res.ch == 1) {
                      setState(() {
                        det.clear();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        showBar(context, "Progress Added!!", 1);
                      });
                    } else {
                      setState(() {
                        Navigator.of(context).pop();
                        showBar(context, res.data, 0);
                      });
                    }
                  }
                },
                child: const Text('Send report'))
          ],
        );
      },
    );
  }

  void showBar(BuildContext context, String msg, int ch) {
    var bar = SnackBar(
      backgroundColor: ch == 0 ? Colors.red : Colors.green,
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }

  showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => const AlertDialog(
        backgroundColor: Colors.transparent,
        content: Center(
          child: SpinKitFadingCube(
            color: Colors.blue,
            size: 50,
          ),
        ),
      ),
    );
  }
}
