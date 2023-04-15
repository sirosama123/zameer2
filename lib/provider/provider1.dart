import 'dart:collection';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';

import '../landing.dart';
import '../loginsignup/login.dart';

class Provider1 extends ChangeNotifier {
  bool load = false;
  String? uid;

  String? gmail;
  String? name;
  String? phone;
  Sign_up(String? email, String? password, String? name, String? phone,
      context) async {
    try {
      load = true;
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.toString(), password: password.toString());

      uid = userCredential.user!.uid;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "name": name,
        "phone": phone,
        "email": email,
        "uid": userCredential.user!.uid.toString()
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => LogIn()));
      load = false;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: "$e",
        toastLength: Toast.LENGTH_SHORT,
      );
      load = false;
    }
  }


   log_in(String? email,String? password,context,  ) async {
      try {
       
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: email.toString(), password: password.toString());
        print("done");
        var data = await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user!.uid)
            .get();
        gmail = data['email'];
        uid = data['uid'];
        name = data['name'];
        phone = data['phone'];
        print("${data['email']}=====>email");

       print("done");
       Navigator.push(context, MaterialPageRoute(builder: (context) => Landing()));
      } on FirebaseAuthException catch (e) {
       
        Fluttertoast.showToast(
          msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    }

  notifyListeners();
}
