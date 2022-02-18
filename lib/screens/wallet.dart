import 'package:car_care/screens/add_wallet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    auth.User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        backgroundColor: Colors.yellow[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('userwallet')
                .where('uid', isEqualTo: user!.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.data!.docs.isNotEmpty) {
                  var bal = snapshot.data!.docs[0]['balance'];
                  var id = snapshot.data!.docs[0].id;
                  return Column(
                    children: [
                      SizedBox(
                        height: 150,
                        child: Card(
                          color: const Color.fromRGBO(19, 26, 44, 1.0),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                    'Account Number: ${snapshot.data!.docs[0]['account number']}',
                                    style:
                                        const TextStyle(color: Colors.white)),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    'Balance: ${snapshot.data!.docs[0]['balance']}',
                                    style:
                                        const TextStyle(color: Colors.white)),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                      SizedBox(
                        height: 200,
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('Offers')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                if (snapshot.data!.docs.isNotEmpty) {
                                  return ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Card(
                                          color: const Color.fromRGBO(
                                              19, 26, 44, 1.0),
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Column(
                                            children: [
                                              GestureDetector(
                                                child: ListTile(
                                                  leading: Text('$index'),
                                                  title: Text(
                                                      '${snapshot.data!.docs[index]['offer']} Requests'),
                                                  trailing: Text(
                                                      '${snapshot.data!.docs[index]['price']} '),
                                                ),
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          (context) =>
                                                              AlertDialog(
                                                                content: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    snapshot.data!.docs[index]['price'] >
                                                                            bal
                                                                        ? const Text(
                                                                            'You Dont Have enough Balance')
                                                                        : const Text(
                                                                            'Are you sure to make payment ??'),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () async {
                                                                          setState(
                                                                              () {
                                                                            showLoadingDialog(context);
                                                                          });

                                                                          Map<String, dynamic>
                                                                              data =
                                                                              <String, dynamic>{
                                                                            "balance":
                                                                                bal - snapshot.data!.docs[index]['price'],
                                                                            "Request":
                                                                                snapshot.data!.docs[index]['offer']
                                                                          };
                                                                          try {
                                                                            await FirebaseFirestore.instance.collection('wallet').doc(id).update(data);
                                                                            setState(() {
                                                                              Navigator.of(context).pop();
                                                                              showBar(context, 'Payment Done', 1);
                                                                            });
                                                                          } catch (e) {
                                                                            setState(() {
                                                                              Navigator.of(context).pop();
                                                                              showBar(context, e.toString(), 0);
                                                                            });
                                                                          }
                                                                        },
                                                                        child: const Text(
                                                                            'make payment'))
                                                                  ],
                                                                ),
                                                              ));
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                } else {
                                  return Text('No available cobon');
                                }
                              }
                            }),
                      )
                    ],
                  );
                } else {
                  return Column(children: [
                    const Text('You Dont have a wallet !!!'),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddWallet()));
                        },
                        child: const Text('make wallet'))
                  ]);
                }
              }
            }),
      ),
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
