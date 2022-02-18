import 'package:car_care/http.dart';
import 'package:car_care/screens/add_wallet.dart';
import 'package:car_care/screens/available_worker.dart';
import 'package:car_care/screens/google_map_page.dart';
import 'package:car_care/screens/progress.dart';
import 'package:car_care/screens/wallet.dart';
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
  bool ch = false;
  int count = 0;
  TextEditingController det = TextEditingController();
  loca.Location geolocation = loca.Location();

  late LocationData _currentPosition;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getData();
    _getLocation();
  }

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

    return _currentPosition;
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

  _getLocation() async {
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
    auth.User? user = FirebaseAuth.instance.currentUser;
    String? id = user!.uid;
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;
    final orientation = MediaQuery.of(context).orientation;
    int bal = 100;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Progress')
            .where('uid', isEqualTo: id)
            .where('status', isEqualTo: 0)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) {
          if (!snapshots.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Services'),
                backgroundColor: Colors.yellow[800],
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Wallet()));
                      },
                      icon: Icon(Icons.wallet_travel)),
                  IconBadge(
                    icon: const Icon(Icons.notifications_none),
                    itemCount: snapshots.data!.docs.length,
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
              body: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('userwallet')
                      .where('uid', isEqualTo: user.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                    if (!snapshot1.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      bool ch = snapshot1.data!.docs.isNotEmpty;
                      return Form(
                        key: _formKey,
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                            top: height / 5,
                          ),
                          padding: EdgeInsets.only(
                              // top: height / 60,
                              left: width / 12,
                              right: width / 12),
                          child: Center(
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('Services')
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    if (snapshot.data!.docs.isNotEmpty) {
                                      return GridView.builder(
                                        itemCount: snapshot.data!.docs.length,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: (orientation ==
                                                  Orientation.portrait)
                                              ? 2
                                              : 3,
                                          // crossAxisSpacing: 16,
                                          // mainAxisSpacing: 16,
                                          childAspectRatio: .90,
                                        ),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () async {
                                              if (ch) {
                                                var res1 =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'userwallet')
                                                        .where('uid',
                                                            isEqualTo: user.uid)
                                                        .get();
                                                if (res1.docs[0]['balance'] <
                                                    bal) {
                                                  setState(() {
                                                    Navigator.of(context).pop();
                                                    showBar(
                                                        context,
                                                        'you dont have abalance',
                                                        0);
                                                  });
                                                } else {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AvailableWorker(
                                                                price: snapshot
                                                                        .data!
                                                                        .docs[index]
                                                                    ['price'],
                                                                type: snapshot
                                                                        .data!
                                                                        .docs[
                                                                    index]['name'],
                                                              )));
                                                  // showDialog(
                                                  //   context: context,
                                                  //   builder:
                                                  //       (BuildContext context) {
                                                  //     return AlertDialog(
                                                  //       title: Text(
                                                  //           "${snapshot.data!.docs[index]['name']}"),
                                                  //       content: TextFormField(
                                                  //         controller: det,
                                                  //         validator: (val) {
                                                  //           if (val!.isEmpty) {
                                                  //             return "please enter some details about your car";
                                                  //           }
                                                  //         },
                                                  //         decoration:
                                                  //             const InputDecoration(
                                                  //                 hintText:
                                                  //                     "some details about your car"),
                                                  //       ),
                                                  //       actions: [
                                                  //         TextButton(
                                                  //             style: ButtonStyle(
                                                  //                 padding: MaterialStateProperty.all(EdgeInsets.only(
                                                  //                     top: height /
                                                  //                         45,
                                                  //                     bottom:
                                                  //                         height /
                                                  //                             45,
                                                  //                     left:
                                                  //                         width /
                                                  //                             10,
                                                  //                     right: width /
                                                  //                         10)),
                                                  //                 backgroundColor:
                                                  //                     MaterialStateProperty.all(const Color.fromRGBO(
                                                  //                         19,
                                                  //                         26,
                                                  //                         44,
                                                  //                         1.0))),
                                                  //             onPressed:
                                                  //                 () async {
                                                  //               if (det.text
                                                  //                   .isEmpty) {
                                                  //                 setState(() {
                                                  //                   Navigator.of(
                                                  //                           context)
                                                  //                       .pop();
                                                  //                   showBar(
                                                  //                       context,
                                                  //                       'please enter some details',
                                                  //                       0);
                                                  //                 });
                                                  //               } else {
                                                  //                 if (_formKey
                                                  //                     .currentState!
                                                  //                     .validate()) {
                                                  //                   setState(
                                                  //                       () {
                                                  //                     showLoadingDialog(
                                                  //                         context);
                                                  //                   });
                                                  //                   auth.User?
                                                  //                       user =
                                                  //                       FirebaseAuth
                                                  //                           .instance
                                                  //                           .currentUser;
                                                  //                   String?
                                                  //                       name =
                                                  //                       user!
                                                  //                           .displayName;
                                                  //                   double? la =
                                                  //                       _currentPosition
                                                  //                           .latitude;
                                                  //                   double? lo =
                                                  //                       _currentPosition
                                                  //                           .longitude;

                                                  //                   GeoPoint
                                                  //                       location =
                                                  //                       GeoPoint(
                                                  //                           la!,
                                                  //                           lo!);

                                                  //                   var res = await addItem(
                                                  //                       uid: user
                                                  //                           .uid,
                                                  //                       name:
                                                  //                           name!,
                                                  //                       type: snapshot.data!.docs[index][
                                                  //                           'name'],
                                                  //                       description: det
                                                  //                           .text
                                                  //                           .trim(),
                                                  //                       map_location:
                                                  //                           location,
                                                  //                       price: snapshot
                                                  //                           .data!
                                                  //                           .docs[index]['price']);
                                                  //                   if (res.ch ==
                                                  //                       1) {
                                                  //                     setState(
                                                  //                         () async {
                                                  //                       det.clear();
                                                  //                       Navigator.of(context)
                                                  //                           .pop();
                                                  //                       Navigator.of(context)
                                                  //                           .pop();
                                                  //                       showBar(
                                                  //                           context,
                                                  //                           "Progress Added!!",
                                                  //                           1);
                                                  //                       Alert(context: context, desc: '')
                                                  //                           .show();
                                                  //                     });
                                                  //                   } else {
                                                  //                     setState(
                                                  //                         () {
                                                  //                       Navigator.of(context)
                                                  //                           .pop();
                                                  //                       showBar(
                                                  //                           context,
                                                  //                           res.data,
                                                  //                           0);
                                                  //                     });
                                                  //                   }
                                                  //                 }
                                                  //               }
                                                  //             },
                                                  //             child: const Text(
                                                  //                 'Send report'))
                                                  //       ],
                                                  //     );
                                                  //   },
                                                  // );
                                                }
                                              } else {
                                                Alert(
                                                    context: context,
                                                    desc:
                                                        'You dont have a wallet',
                                                    buttons: [
                                                      DialogButton(
                                                          child: const Text(
                                                              'Make Wallet'),
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const AddWallet()));
                                                          })
                                                    ]).show();
                                              }
                                            },
                                            child: Card(
                                              color: Colors.yellow[800],
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Center(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Center(
                                                      child: Container(
                                                        height: height / 6,
                                                        width: width / 4,
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        decoration:
                                                            const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child:
                                                            CachedNetworkImage(
                                                          width: 1000,
                                                          fit: BoxFit.cover,
                                                          imageUrl: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                              ['image'],
                                                          progressIndicatorBuilder:
                                                              (context, url,
                                                                      downloadProgress) =>
                                                                  Center(
                                                            child: CircularProgressIndicator(
                                                                value: downloadProgress
                                                                    .progress),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              (const Icon(
                                                                  Icons.error)),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                        snapshot.data!
                                                                .docs[index]
                                                            ['name'],
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    Text(
                                                        '${snapshot.data!.docs[index]['price']} SDG',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      return const Center(
                                        child: Text('No Avaialble Services'),
                                      );
                                    }
                                  }
                                }),
                          ),
                        ),
                      );
                    }
                  }),
            );
          }
        });
  }
}

class Card_d extends StatefulWidget {
  const Card_d(
      {Key? key, required this.title, required this.icon, required this.nav})
      : super(key: key);

  final String icon;
  final dynamic nav;
  final String title;

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
