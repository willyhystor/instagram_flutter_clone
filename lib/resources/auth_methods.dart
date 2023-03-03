import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> signUp({
    required String email,
    required String password,
    required String username,
    required String bio,
    Uint8List? imageFile,
  }) async {
    String res = 'Some error occured';

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        // register user
        UserCredential userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        log(userCredential.user!.uid);

        String profilePictureUrl = '';
        if (imageFile != null) {
          profilePictureUrl = await StorageMethods().uploadImage(
            childName: 'profile_picture',
            file: imageFile,
          );
        }

        // add user to db
        _firebaseFirestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'uid': userCredential.user!.uid,
          'email': email,
          'username': username,
          'bio': bio,
          'followers': [],
          'following': [],
          'profile_picture_url': profilePictureUrl,
        });
        // another version to add user to db
        // _firebaseFirestore.collection('users').add({
        //   'uid': userCredential.user!.uid,
        //   'email': email,
        //   'username': username,
        //   'bio': bio,
        //   'followers': [],
        //   'following': [],
        // });

        res = 'success';
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    String res = '';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);

        res = 'Success';
      } else {
        res = 'Please enter all the fields';
      }
    }
    // you can do it like this for specific firebase auth exception
    // on FirebaseAuthException catch(e){
    //   if(e.code == 'wrong-password'){
    //     // do something
    //   }
    // }
    catch (e) {
      res = e.toString();
    }

    return res;
  }
}
