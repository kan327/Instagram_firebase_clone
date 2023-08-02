// import 'dart:ffi';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/models/user.dart' as model;
import 'package:instagram_flutter/resource/storage_method.dart';
// import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    return model.User.fromSnap(snap);
  }

  // sign up
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "some error occured :3";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);
        // adding photo to database
        String photoUrl = await StorageMethods()
            .uploadImageToStorage("profileImg", file, false);
        // add user to firebase 🔥

        model.User user = model.User(
          email: email,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          username: username,
          bio: bio,
          followers: [],
          following: [],
        );

        await _firestore.collection("users").doc(cred.user!.uid).set(
              user.toJson(),
            );
        res = "success";
      }
    }
    // on FirebaseAuthException catch (e) {
    // if (e == 'invalid-email') {
    //   res = 'The Email Is Badly Formatted';
    // } else if (e == 'weak-password') {
    //   res = 'Your Password Should Be At Least 6 Character';
    // // }
    // res = e.toString();
    // }
    catch (e) {
      res = e.toString();
    }
    return res;
  }

  // login
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "some error occured :3";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "please enter all of the fields";
      }
    }
    // on FirebaseAuthException catch (e) {
    // if (e == 'user-not-found') {
    //   res = 'The Email Is Badly Formatted';
    // } else if (e == 'wrong-password') {
    //   res = 'Your Password Should Be At Least 6 Character';
    // // }
    // res = e.toString();
    // }
    catch (e) {
      res = e.toString();
    }
    return res;
  }
}
