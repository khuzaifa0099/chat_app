import 'package:chat_app/models/UserModel.dart';
import 'package:chat_app/models/firebase_helper.dart';
import 'package:chat_app/screens/auth_screen/login/login_screen.dart';
import 'package:chat_app/screens/home_screen/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? currentuser = FirebaseAuth.instance.currentUser;
  if(currentuser != null){
    UserModel?  thisUserModel =await FirebaseHelper.getUserModelById(currentuser.uid);
    if(thisUserModel != null){
      runApp( MyAppLogged(userModel: thisUserModel, firebaseUser: currentuser,));
    }else{
      runApp(const MyApp());
    }
  }else{
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      //home: (FirebaseAuth.instance.currentUser != null)? HomeScreen() : LoginScreen(),
    );
  }
}

class MyAppLogged extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  const MyAppLogged({Key? key,
  required this.userModel,
    required this.firebaseUser
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(userModel: userModel, firebaseUser: firebaseUser),
    );
  }
}



