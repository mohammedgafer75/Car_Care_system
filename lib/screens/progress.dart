import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProgressPage extends StatefulWidget {
  ProgressPage({Key? key}) : super(key: key);

  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  void showBar(BuildContext context, String msg, int ch) {
    var bar = SnackBar(
      backgroundColor: ch == 0 ? Colors.red : Colors.green,
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }

  @override
  Widget build(BuildContext context) {
    auth.User? user = FirebaseAuth.instance.currentUser;
    String? id = user!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('In Progress'),
        backgroundColor: Colors.yellow[800],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Progress')
              .where('uid', isEqualTo: id)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No data Founded'),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: SizedBox(
                            height: 150,
                            width: 70,
                            child: ListView(children: [
                              Center(
                                child: Text(
                                  '${snapshot.data!.docs[index]['type']} In Progress ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                              ),
                              Padding(
                                  padding:
                                      const EdgeInsets.only(top: 18, left: 18),
                                  child: Row(
                                    children: [
                                      const Text(
                                      ' Maintenance worker:  ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                      Text(
                                          '${snapshot.data!.docs[index]['worker']}',
                                          style: const TextStyle(
                                              fontSize: 14, color: Colors.black)),
                                    ],
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 18, left: 18),
                                child: Row(
                                  children: [
                                    const Text(
                                      ' Status: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                    snapshot.data!.docs[index]['status'] == 1
                                        ? const Text(
                                            ' Done ',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black),
                                          )
                                        : snapshot.data!.docs[index]
                                                    ['status'] ==
                                                0
                                            ? const Text(
                                                ' Waiting ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              )
                                            : const Text(
                                                ' Cancled ',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                  ],
                                ),
                              ),
                              snapshot.data!.docs[index]['status'] == 1
                                  ? const SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                              style: ButtonStyle(
                                                  padding: MaterialStateProperty.all(
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 10,
                                                          left: 15,
                                                          right: 15)),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          const Color.fromRGBO(
                                                              19, 26, 44, 1.0)),
                                                  shape: MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(13),
                                                          side: const BorderSide(color: Color.fromRGBO(19, 26, 44, 1.0))))),
                                              onPressed: () {
                                                launch(
                                                    'tel://${snapshot.data!.docs[index]['worker_number']}');
                                              },
                                              child: const Text(
                                                'Call',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                          snapshot.data!.docs[index]
                                                      ['status'] ==
                                                  1
                                              ? const SizedBox()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 3.0),
                                                  child: TextButton(
                                                      style: ButtonStyle(
                                                          padding: MaterialStateProperty.all(
                                                              const EdgeInsets.only(
                                                                  top: 10,
                                                                  bottom: 10,
                                                                  left: 15,
                                                                  right: 15)),
                                                          backgroundColor:
                                                              MaterialStateProperty.all(
                                                                  const Color.fromRGBO(
                                                                      19, 26, 44, 1.0)),
                                                          shape: MaterialStateProperty.all<
                                                                  RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(13),
                                                                  side: const BorderSide(color: Color.fromRGBO(19, 26, 44, 1.0))))),
                                                      onPressed: () async {
                                                        try {
                                                          var res =
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Progress')
                                                                  .doc(snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .id)
                                                                  .update({
                                                            'status': 3
                                                          });
                                                          setState(() {
                                                            showBar(
                                                                context,
                                                                " Progress Canceled",
                                                                1);
                                                          });
                                                        } catch (e) {
                                                          setState(() {
                                                            showBar(
                                                                context,
                                                                e.toString(),
                                                                0);
                                                          });
                                                        }
                                                      },
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )),
                                                )
                                        ],
                                      ),
                                    ),
                            ]),
                          ),
                        ),
                      );
                    });
              }
            }
          }),
    );
  }
}
