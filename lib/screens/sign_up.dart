import 'package:car_care/http.dart';
import 'package:car_care/screens/text_field_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:car_care/background-image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController email = new TextEditingController();
  TextEditingController name = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController repassword = new TextEditingController();
  TextEditingController number = new TextEditingController();
  bool loading = false;
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);

    final width = data.size.width;
    final height = data.size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.yellow[800],
      ),
      body: Container(
        color: Colors.blue,
        child: Stack(
          children: [
            BackgroundImage(image: 'assets/images/car.jpg'),
            Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.only(top: height * 0.05),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      padding:
                          EdgeInsets.only(right: width / 8, left: width / 8),
                      height: height * 0.1,
                      width: width * 1.0,

                      // decoration: BoxDecoration(
                      //   color: Colors.grey[500].withOpacity(0.5),
                      //   borderRadius: BorderRadius.circular(16),
                      // ),
                      child: TextFormField(
                        controller: name,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "please enter your Name";
                          }
                        },
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 3.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white70.withOpacity(.7),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            size: 24,
                            color: Colors.white,
                          ),

                          labelText: 'Name',

                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(color: Colors.white),

                          // hintText: hint,
                          //  hintStyle: kBodyText,
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      padding:
                          EdgeInsets.only(right: width / 8, left: width / 8),
                      height: height * 0.1,
                      width: width * 1.0,

                      // decoration: BoxDecoration(
                      //   color: Colors.grey[500].withOpacity(0.5),
                      //   borderRadius: BorderRadius.circular(16),
                      // ),
                      child: TextFormField(
                        controller: email,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "please enter your Email";
                          }
                          String pattern =
                              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                              r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                              r"{0,253}[a-zA-Z0-9])?)*$";
                          RegExp regex = RegExp(pattern);
                          if (!regex.hasMatch(val))
                            return 'Enter a valid email address';
                        },
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 3.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white70.withOpacity(.7),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          prefixIcon: Icon(
                            Icons.email,
                            size: 24,
                            color: Colors.white,
                          ),

                          labelText: 'Email',

                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(color: Colors.white),

                          // hintText: hint,
                          //  hintStyle: kBodyText,
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      padding:
                          EdgeInsets.only(right: width / 8, left: width / 8),
                      height: height * 0.1,
                      width: width * 1.0,

                      // decoration: BoxDecoration(
                      //   color: Colors.grey[500].withOpacity(0.5),
                      //   borderRadius: BorderRadius.circular(16),
                      // ),
                      child: TextFormField(
                        controller: password,
                        obscureText: _obscureText,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "please enter your password";
                          }
                          if (val.length < 6) {
                            return "password length must be more than 6 ";
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: _toggle,
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                              )),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 3.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white70.withOpacity(.7),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            size: 24,
                            color: Colors.white,
                          ),

                          labelText: 'Password',

                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(color: Colors.white),

                          // hintText: hint,
                          //  hintStyle: kBodyText,
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      padding:
                          EdgeInsets.only(right: width / 8, left: width / 8),
                      height: height * 0.1,
                      width: width * 1.0,

                      // decoration: BoxDecoration(
                      //   color: Colors.grey[500].withOpacity(0.5),
                      //   borderRadius: BorderRadius.circular(16),
                      // ),
                      child: TextFormField(
                        controller: repassword,
                        obscureText: _obscureText,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "please enter your new password number";
                          }
                          if (password.text != val) {
                            return "Not Matched";
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: _toggle,
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                              )),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 3.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white70.withOpacity(.7),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            size: 24,
                            color: Colors.white,
                          ),

                          labelText: 'retype Password',

                          labelStyle: TextStyle(color: Colors.white),
                          hintStyle: TextStyle(color: Colors.white),

                          // hintText: hint,
                          //  hintStyle: kBodyText,
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      padding:
                          EdgeInsets.only(right: width / 8, left: width / 8),
                      height: height * 0.1,
                      width: width * 1.0,

                      // decoration: BoxDecoration(
                      //   color: Colors.grey[500].withOpacity(0.5),
                      //   borderRadius: BorderRadius.circular(16),
                      // ),
                      child: TextFormField(
                        controller: number,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "please enter your Phone";
                          }
                          if (val.length < 10) {
                            return "Phone length must be more than 10";
                          }
                        },
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 3.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.white70.withOpacity(.7),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(13),
                          ),
                          prefixIcon: Icon(
                            Icons.phone,
                            size: 28,
                            color: Colors.white,
                          ),

                          labelText: 'Phone number',

                          labelStyle: TextStyle(color: Colors.white),
                          // hintText: hint,
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        style: TextStyle(color: Colors.white),

                        //  style: kBodyText,
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.only(
                              top: height / 45,
                              bottom: height / 45,
                              left: width / 10,
                              right: width / 10)),
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromRGBO(19, 26, 44, 1.0)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      side: BorderSide(
                                          color: Color.fromRGBO(
                                              19, 26, 44, 1.0))))),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            showLoadingDialog(context);
                          });

                          dynamic res = await CreateUserwithEmailAndPassword(
                              email.text.trim(), password.text);

                          if (res.ch == 0) {
                            setState(() {
                              Navigator.of(context).pop();
                              showBar(context, res.data, 0);
                            });
                          } else {
                            int? a = int.tryParse(number.text);
                            auth.User? user = FirebaseAuth.instance.currentUser;
                            user!.updateDisplayName(name.text.trim());
                            await user.reload();
                            await saveUserPhone(
                                uid: user.uid, number: a!, name: name.text);
                            setState(() {
                              Navigator.of(context).pop();
                              showBar(
                                  context, "User created !! Back to Login", 1);
                            });
                          }
                        }
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                            fontSize: 20.0, color: Colors.yellow[800]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  void showBar(BuildContext context, String msg, int ch) {
    var bar = SnackBar(
      backgroundColor: ch == 0 ? Colors.red : Colors.green,
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(bar);
  }
}
