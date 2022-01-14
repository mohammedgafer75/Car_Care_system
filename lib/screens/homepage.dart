import 'package:car_care/http.dart';
import 'package:car_care/screens/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/instance_manager.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loca;
import 'package:car_care/screens/sign_in.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  bool ch = false;
  TextEditingController det = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int count = 0;
  late LocationData _currentPosition;
  loca.Location geolocation = loca.Location();
  Future getData() async {
    print(count);
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

    return _currentPosition;
  }

  void _getLocation() async {
    PermissionStatus _permissionGranted = await geolocation.hasPermission();
    Location location = Location();
    if (_permissionGranted == PermissionStatus.granted) {
      print('h');
      final LocationData pos = await location.getLocation();
      setState(() {
        print(pos.runtimeType);
      });
    } else {
      await location.requestPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;
    final orientation = MediaQuery.of(context).orientation;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Progress')
            .where('status', isEqualTo: 1)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Services'),
              backgroundColor: Colors.yellow[800],
              actions: [
                IconBadge(
                  icon: const Icon(Icons.notifications_none),
                  itemCount: snapshot.data!.docs.length,
                  badgeColor: Colors.red,
                  itemColor: Colors.white,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProgressPage()));
                  },
                )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.yellow[800],
              child: const Center(child: Icon(Icons.call_outlined)),
              onPressed: () {
                launch('tel://65782');
              },
            ),
            body: Form(
              key: _formKey,
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                  top: height / 80,
                ),
                padding: EdgeInsets.only(
                    top: height / 90, left: width / 8, right: width / 8),
                child: Center(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Services')
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        return GridView.builder(
                          itemCount: snapshot.data!.docs.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                (orientation == Orientation.portrait) ? 2 : 3,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: .90,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          "${snapshot.data!.docs[index]['name']}"),
                                      content: TextFormField(
                                        controller: det,
                                        validator: (val) {
                                          if (val!.isEmpty) {
                                            return "please enter your email";
                                          }
                                        },
                                        decoration: const InputDecoration(
                                            hintText:
                                                "some details about your car"),
                                      ),
                                      actions: [
                                        TextButton(
                                            style: ButtonStyle(
                                                padding:
                                                    MaterialStateProperty.all(
                                                        EdgeInsets.only(
                                                            top: height / 45,
                                                            bottom: height / 45,
                                                            left: width / 10,
                                                            right: width / 10)),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        const Color.fromRGBO(
                                                            19, 26, 44, 1.0))),
                                            onPressed: () async {
                                              if (det.text.isEmpty) {
                                                setState(() {
                                                  Navigator.of(context).pop();
                                                  showBar(
                                                      context,
                                                      'please enter some details',
                                                      0);
                                                });
                                              } else {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  setState(() {
                                                    showLoadingDialog(context);
                                                  });
                                                  auth.User? user = FirebaseAuth
                                                      .instance.currentUser;
                                                  String? name =
                                                      user!.displayName;
                                                  // double? la = _currentPosition.latitude;
                                                  //  double? lo = _currentPosition.longitude;
                                                  double a = 15.633 + index;
                                                  GeoPoint location =
                                                      GeoPoint(a, 32.533);
                                                  var res = await addItem(
                                                      uid: user.uid,
                                                      name: name!,
                                                      type: snapshot.data!
                                                          .docs[index]['name'],
                                                      description:
                                                          det.text.trim(),
                                                      map_location: location);
                                                  if (res.ch == 1) {
                                                    setState(() {
                                                      det.clear();
                                                      Navigator.of(context)
                                                          .pop();
                                                      Navigator.of(context)
                                                          .pop();
                                                      showBar(
                                                          context,
                                                          "Progress Added!!",
                                                          1);
                                                    });
                                                  } else {
                                                    setState(() {
                                                      Navigator.of(context)
                                                          .pop();
                                                      showBar(
                                                          context, res.data, 0);
                                                    });
                                                  }
                                                }
                                              }
                                            },
                                            child: const Text('Send report'))
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Card(
                                color: Colors.yellow[800],
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Center(
                                        child: Container(
                                          height: height / 6,
                                          width: width / 6,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.contain,
                                            imageUrl: snapshot.data!.docs[index]
                                                ['image'],
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                Center(
                                              child: CircularProgressIndicator(
                                                  value: downloadProgress
                                                      .progress),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    (const Icon(Icons.error)),
                                          ),
                                        ),
                                      ),
                                      Text(snapshot.data!.docs[index]['name'],
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                ),
              ),
            ),
          );
        });
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

class Card_d extends StatefulWidget {
  const Card_d(
      {Key? key, required this.title, required this.icon, required this.nav})
      : super(key: key);
  final String title;
  final String icon;
  final dynamic nav;

  @override
  State<Card_d> createState() => _Card_dState();
}

// ignore: camel_case_types
class _Card_dState extends State<Card_d> {
  void showBar(BuildContext context, String msg) {
    var bar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Alert(
          context: context,
        );
      },
      child: Card(
        color: const Color.fromRGBO(19, 26, 44, 1.0),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  maxRadius: 70,
                  backgroundImage: AssetImage(widget.icon),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(widget.title, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
