import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddWallet extends StatefulWidget {
  const AddWallet({Key? key}) : super(key: key);

  @override
  _AddWalletState createState() => _AddWalletState();
}

class _AddWalletState extends State<AddWallet> {
  TextEditingController number = TextEditingController();
  TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 26, 44, 1.0),
      appBar: AppBar(
        title: Text('Add Wallet'),
        backgroundColor: Colors.yellow[800],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Container(
                padding: EdgeInsets.only(
                  top: data.padding.top * .7,
                  // bottom: data.padding.bottom * .3),
                ),
                height: height * 0.6,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      padding: EdgeInsets.only(
                          right: width / 100, left: width / 100),
                      height: height * 0.1,
                      width: width * 0.8,
                      // decoration: BoxDecoration(
                      //  color: Colors.white.withOpacity(0.5),
                      // borderRadius: BorderRadius.circular(16),
                      // ),
                      child: TextFormField(
                        controller: number,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "please enter your account number";
                          }
                        },
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 3.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white70.withOpacity(.7),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          prefixIcon: const Icon(
                            Icons.account_box,
                            size: 24,
                            color: Colors.white,
                          ),

                          labelText: 'Account Number',

                          labelStyle: const TextStyle(color: Colors.white),
                          hintStyle: const TextStyle(color: Colors.white),

                          // hintText: hint,
                          //  hintStyle: kBodyText,
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      padding: EdgeInsets.only(
                          right: width / 100, left: width / 100),
                      height: height * 0.1,
                      width: width * 0.8,
                      // decoration: BoxDecoration(
                      //  color: Colors.white.withOpacity(0.5),
                      // borderRadius: BorderRadius.circular(16),
                      // ),
                      child: TextFormField(
                        controller: password,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "please enter your account password";
                          }
                          if (val.length < 6) {
                            return "length must be more than 5";
                          }
                        },
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.red, width: 3.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white70.withOpacity(.7),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          prefixIcon: const Icon(
                            Icons.lock,
                            size: 24,
                            color: Colors.white,
                          ),

                          labelText: 'password',

                          labelStyle: const TextStyle(color: Colors.white),
                          hintStyle: const TextStyle(color: Colors.white),

                          // hintText: hint,
                          //  hintStyle: kBodyText,
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Center(
                    child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.only(
                              top: height / 45,
                              bottom: height / 45,
                              left: width / 10,
                              right: width / 10)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.yellow[800]),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      side: const BorderSide(
                                          color: Color.fromRGBO(
                                              19, 26, 44, 1.0))))),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            showLoadingDialog(context);
                          });
                          auth.User? user = FirebaseAuth.instance.currentUser;
                          String? name = user!.displayName;
                          Map<String, dynamic> data = <String, dynamic>{
                            "uid": user.uid,
                            "name": name,
                            "account number": number.text,
                            "password": password.text,
                            "balance": 10000,
                          };
                          try {
                            await FirebaseFirestore.instance
                                .collection('userwallet')
                                .doc()
                                .set(data);
                            setState(() {
                              Navigator.of(context).pop();
                              showBar(context, 'wallet Created', 1);

                              //print('this is result:$res');
                            });
                          } catch (e) {
                            setState(() {
                              Navigator.of(context).pop();
                              showBar(context, e.toString(), 1);
                            });
                          }
                        }
                      },
                      child: Text(
                        'Make',
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                  ),
                ]))
          ],
        ),
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
