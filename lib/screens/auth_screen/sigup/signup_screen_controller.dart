import 'dart:developer';
import 'package:chat_app/models/UserModel.dart';
import 'package:chat_app/screens/auth_screen/complete_profile/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  bool CurrenttVisible = true;
  bool newVisiblePassword = true;
  bool ischangeConfirmPassword = true;
  var isLoading = false.obs;
  bool isVisible = true;
  bool isVisibleConfirmPassword = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController conformPasswordController = TextEditingController();
  GlobalKey<FormState> signUpKey = GlobalKey<FormState>();

  validateForm() async {
    String email = emailController.text.trim();
    String password = passwordC.text.trim();
    String conformPasswordController = emailController.text.trim();
    if (!signUpKey.currentState!.validate()) {
      log("Form Not Valid");
    } else {
     isLoading.value = true;
      log("Form Valid");
      signUp(email, password);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
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
      UserModel newuser = UserModel(
        uid: uid,
        email: email,
        fullname: "",
        profilepic: "",
      );
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newuser.toMap())
          .then((value){
        Fluttertoast.showToast(
            msg: "New User Created",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0
        );
        isLoading.value = false;
            print("New User Created");
            Get.to(()=>  ProfileScreen(userModel: newuser, firebaseUser: credential!.user!));
        isLoading.value = false;
      });
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

  String? validate_conformpassword(val) {
    if (val.length < 6) {
      return "please Enter minimum 6 character";
    } else if (passwordC.value.text != conformPasswordController.value.text) {
      return "password does not match";
    }
    ;
  }

  changeVisibilityPassword() {
    isVisible = !isVisible;
    update();
  }

  changeVisibilityConfirmPassword() {
    isVisibleConfirmPassword = !isVisibleConfirmPassword;
    update();
  }
}
