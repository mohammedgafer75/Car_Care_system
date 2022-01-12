import 'package:car_care/http.dart';
import 'package:car_care/screens/homepage.dart';
import 'package:car_care/screens/sign_up.dart';
import 'package:car_care/screens/text_field_input.dart';
import 'package:car_care/background-image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SignIn extends StatefulWidget {
  SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextStyle kBodyText =
      TextStyle(fontSize: 14, color: Colors.white, height: 1.5);

  Color kWhite = Colors.white;
  Color kBlue = Color(0xff5663ff);
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

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
    print(_obscureText);
    Size size = MediaQuery.of(context).size;
    final data = MediaQuery.of(context);
    final width = data.size.width;
    final height = data.size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Stack(
            children: [
              BackgroundImage(image: 'assets/images/car.jpg'),
              Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: size.height / 5.0),
                      child: Center(
                        child: Text(
                          'Car Repair',
                          style: TextStyle(
                              color: Colors.yellow[800],
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 60,
                    // ),

                    Container(
                      padding: EdgeInsets.only(
                        top: data.padding.top * .7,
                        // bottom: data.padding.bottom * .3),
                      ),
                      height: height * 0.6,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Container(
                              padding: EdgeInsets.only(
                                  right: width / 8, left: width / 8),
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
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 3.0),
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
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
                              padding: EdgeInsets.only(
                                  right: width / 8, left: width / 8),
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
                                        color:
                                            Theme.of(context).primaryColorDark,
                                      )),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 3.0),
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2.0),
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
                          SizedBox(height: height * 0.03),
                          Center(
                            child: TextButton(
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.only(
                                          top: height / 45,
                                          bottom: height / 45,
                                          left: width / 10,
                                          right: width / 10)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Color.fromRGBO(19, 26, 44, 1.0)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(13),
                                          side: BorderSide(
                                              color:
                                                  Color.fromRGBO(19, 26, 44, 1.0))))),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    showLoadingDialog(context);
                                  });

                                  dynamic res =
                                      await signInwithEmailAndPassword2(
                                          email.text.trim(), password.text);
                                  if (res.ch == 0) {
                                    setState(() {
                                      Navigator.of(context).pop();
                                      showBar(context, res.data, 0);

                                      //print('this is result:$res');
                                    });
                                  } else {
                                    print(res.data);
                                    setState(() {
                                      Navigator.of(context).pop();
                                      go(res);
                                    });
                                  }
                                }
                              },
                              child: Text(
                                'SignIn',
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.yellow[800]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: kBodyText,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow[800],
                                fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
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

  Future go(dynamic res) async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => HomePage()),
        (Route<dynamic> route) => false);
  }
}
