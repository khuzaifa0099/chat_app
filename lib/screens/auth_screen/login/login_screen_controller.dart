import 'dart:developer';
import 'package:chat_app/models/UserModel.dart';
import 'package:chat_app/screens/home_screen/screen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../complete_profile/profile_screen.dart';

class LoginController extends GetxController {
  bool CurrenttVisible = true;
  bool newVisiblePassword = true;
  bool ischangeConfirmPassword = true;
  var isLoading = false.obs;
  bool isVisible = true;


  TextEditingController emailController = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();

  void login(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      Fluttertoast.showToast(
          msg: ex.code.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
      );
      print(ex.code.toString());
    }
    if (credential != null) {
      String uid = credential.user!.uid;
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection(
          "users").doc(uid).get();
      UserModel userModel = UserModel.fromMap(userData.data() as
      Map<String , dynamic>
      );
      //isLoading.value = false;
      print("login");
      Get.to(()=> HomeScreen(userModel: userModel, firebaseUser: credential!.user!));
      isLoading.value = false;
    };
  }

  validateForm() async {
    String email = emailController.text.trim();
    String password = passwordC.text.trim();
    if (!loginKey.currentState!.validate()) {
      log("Form Not Valid");
    }
    else {
      isLoading.value = true;
      login(email, password);
      log("Form Valid");
      //isLoading.value = false;

    }
  }

  String? validate_email(val) {
    bool emailValid =
    RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(val);
    if (val.isEmpty) {
      return "Please Enter your email";
    } else if (emailValid == false) {
      return "email is not valid";
    } else
      return null;
  }

  String? validate_password(val) {
    if (val.length < 6) {
      return "please Enter minimum 6 character";
    } else {
      return null;
    }
  }

  changeVisibilityPassword() {
    isVisible = !isVisible;
    update();
  }
}
