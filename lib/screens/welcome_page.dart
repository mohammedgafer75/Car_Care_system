import 'package:car_care/screens/sign_in.dart';
import 'package:car_care/screens/sign_up.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                      top: 90, bottom: 10, left: 10, right: 10),
            child: Image.asset('assets/images/good.jpg'),
          ),
          Center(
            child: TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.only(
                      top: 10, bottom: 10, left: 60, right: 60)),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.yellow[900]),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ))),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignIn()));
              },
              child: const Text(
                'SignIn',
                style: TextStyle(fontSize: 14.0, color: Colors.white),
              ),
            ),
          ),
          Center(
            child: TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.only(
                      top: 10, bottom: 10, left: 60, right: 60)),
                  backgroundColor:
                      MaterialStateProperty.all(Colors.yellow[900]),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ))),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignUp()));
              },
              child: const Text(
                'SignUp',
                style: TextStyle(fontSize: 14.0, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
