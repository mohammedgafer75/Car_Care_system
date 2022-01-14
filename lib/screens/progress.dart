import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProgressPage extends StatefulWidget {
  ProgressPage({Key? key}) : super(key: key);

  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('In Progress'),
        backgroundColor: Colors.yellow[800],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Progress')
              .where('status', isEqualTo: 1)
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
                            height: 130,
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
                                child: Text(
                                    'Maintenance worker: ${snapshot.data!.docs[index]['worker']}',
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 10,
                                                    left: 15,
                                                    right: 15)),
                                            backgroundColor: MaterialStateProperty.all(
                                                const Color.fromRGBO(
                                                    19, 26, 44, 1.0)),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(13),
                                                    side: const BorderSide(color: Color.fromRGBO(19, 26, 44, 1.0))))),
                                        onPressed: () {
                                          launch(
                                              'tel://${snapshot.data!.docs[index]['worker_number']}');
                                        },
                                        child: const Text(
                                          'Call',
                                          style: TextStyle(color: Colors.white),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 3.0),
                                      child: TextButton(
                                          style: ButtonStyle(
                                              padding: MaterialStateProperty.all(
                                                  const EdgeInsets.only(
                                                      top: 10,
                                                      bottom: 10,
                                                      left: 15,
                                                      right: 15)),
                                              backgroundColor: MaterialStateProperty.all(
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
                                              var res = await FirebaseFirestore
                                                  .instance
                                                  .collection('Progress')
                                                  .doc(snapshot
                                                      .data!.docs[index].id)
                                                  .delete();
                                              setState(() {
                                                showBar(
                                                    context,
                                                    "phone added to the database",
                                                    0);
                                              });
                                            } catch (e) {
                                              setState(() {
                                                showBar(
                                                    context, e.toString(), 1);
                                              });
                                            }
                                          },
                                          child: const Text(
                                            'Cancel',
                                            style:
                                                TextStyle(color: Colors.white),
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

  void showBar(BuildContext context, String msg, int ch) {
    var bar = SnackBar(
      backgroundColor: ch == 0 ? Colors.red : Colors.green,
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }
}
