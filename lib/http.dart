import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';

class RequestResult {
  dynamic data;
  int ch;
  RequestResult(this.data, this.ch);
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final CollectionReference realestate =
    FirebaseFirestore.instance.collection('Car_Care');
Future<RequestResult> signInwithEmailAndPassword2(
  String email,
  String password,
) async {
  late String msg;
  try {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return RequestResult(credential.user, 1);
  } on auth.FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      msg = 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      msg = 'Wrong password provided for that user.';
    } else {
      msg = 'hello';
    }

    return RequestResult(msg, 0);
  }
}

Future<RequestResult> CreateUserwithEmailAndPassword(
  String email,
  String password,
) async {
  late String msg;
  try {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return RequestResult(credential, 1);
  } on auth.FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      msg = 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      msg = 'The account already exists for that email.';
    }
    return RequestResult(msg, 0);
  }
}

Future<RequestResult> addItemWithLocation({
  required String uid,
  required String name,
  required String url,
  required String description,
  required String purpose,
  required String location,
  required int? price,
  required int? sqm,
  required int num_bed,
  required int num_bath,
  required int num_ket,
  required int num_bark,
  required List image,
  required GeoPoint map_location,
}) async {
  DocumentReference documentReferencer = realestate.doc();

  Map<String, dynamic> data = <String, dynamic>{
    "uid": uid,
    "name": name,
    "image": url,
    "description": description,
    "purpose": purpose,
    "location": location,
    "price": price,
    "sqm": sqm,
    "num_bed": num_bed,
    "num_bath": num_bath,
    "num_ket": num_ket,
    "num_bark": num_bark,
    "images": image,
    "map_location": map_location,
    "status": 2,
  };
  // final credential = await documentReferencer.set(data).whenComplete(() {
  //   return RequestResult("Notes item added to the database", 0);
  // });
  try {
    var res = await documentReferencer.set(data);
    return RequestResult("RealEstate item added to the database", 1);
  } catch (e) {
    return RequestResult(e.toString(), 0);
  }
}

Future<RequestResult> addItem({
  required String uid,
  required String name,
  required String type,
  required String workerid,
  required String workername,
  required int price,
  required int workernumber,
  required String description,
  required GeoPoint map_location,
}) async {
  DocumentReference documentReferencer =
      FirebaseFirestore.instance.collection('Progress').doc();

  Map<String, dynamic> data = <String, dynamic>{
    "uid": uid,
    "workerid": workerid,
    "name": name,
    "worker": workername,
    "price": price,
    "worker_number": workernumber,
    "type": type,
    "map_location": map_location,
    "description": description,
    "time": DateTime.now().day,
    "month": DateTime.now().month,
    "year": DateTime.now().year,
    "status": 0,
  };
  // final credential = await documentReferencer.set(data).whenComplete(() {
  //   return RequestResult("Notes item added to the database", 0);
  // });
  try {
    var res = await documentReferencer.set(data);
    return RequestResult("Your Progress added", 1);
  } catch (e) {
    return RequestResult(e, 0);
  }
}

Future<RequestResult> saveUserPhone({
  required String uid,
  required String name,
  required int number,
}) async {
  Map<String, dynamic> data = <String, dynamic>{
    "uid": uid,
    "name": name,
    "phone": number,
  };
  try {
    var res =
        await FirebaseFirestore.instance.collection('users').doc().set(data);
    return RequestResult("phone added to the database", 1);
  } catch (e) {
    return RequestResult(e, 0);
  }
}
