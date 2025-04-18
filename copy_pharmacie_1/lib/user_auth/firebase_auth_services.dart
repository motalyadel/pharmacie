import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class  FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;



  Future<void> sendEmailVerificationLink() async{
    try {
      await _auth.currentUser?.sendEmailVerification();
    }catch(e){
      print(e.toString());
    }
  }

  Future<User?> signUpWithEmailAndPassword(String email,String password) async{
    try {
      UserCredential credential =await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }catch(e) {
      print("erreur de validation");
    }
    return null ;
  }

  Future<User?> signInWithEmailAndPassword(String email,String password) async{
    try {
      UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }catch(e) {
      print("erreur de validation");
    }
    return null ;
  }



}