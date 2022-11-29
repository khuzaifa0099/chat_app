import 'dart:developer';
import 'dart:io';
import 'package:chat_app/models/UserModel.dart';
import 'package:chat_app/screens/auth_screen/complete_profile/profile_screen_controller.dart';
import 'package:chat_app/screens/home_screen/screen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constant_widget/constant_colors.dart';
import '../../../reusable_widght/custom_button.dart';
import '../../../reusable_widght/reusable_textform_field.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const ProfileScreen(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final controller = Get.put(ProfileScreenController());
  TextEditingController fullNameController = TextEditingController();
  File? imageFile;

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 20,
    );
    if (croppedImage != null) {
      setState(() {
        //imageFile = croppedImage as File?;
        imageFile = File(croppedImage.path);
      });
    }
  }

  GlobalKey<FormState> profileformKey = GlobalKey<FormState>();

  validateForm() async {
    //String fulname = fullNameController.text.trim();
    if (!profileformKey.currentState!.validate()) {
      print("Form Not Valid");
    } else {
      print("Form Valid");
      controller.isLoading.value = true;
      uploadData();
      log("Data Uploding....");

    }
  }

  void uploadData() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepictures")
        .child(widget.userModel.uid.toString())
        .putFile(imageFile!);
    TaskSnapshot snapshot = await uploadTask;
    String? imageUrl = await snapshot.ref.getDownloadURL();
    String? fullname = fullNameController.text.trim();
    widget.userModel.fullname = fullname;
    widget.userModel.profilepic = imageUrl;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then((value) {
      Fluttertoast.showToast(
          msg: "Data Uploded",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
      );
      controller.isLoading.value = false;
      log("Data Uploded");
      Get.to(() => HomeScreen(
          userModel: widget.userModel, firebaseUser: widget.firebaseUser));
      controller.isLoading.value = false;
    });
    controller.isLoading.value = false;
  }

  void showPhotoOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Upload Profile Picture"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                  leading: Icon(Icons.photo_album),
                  title: Text("Select from Gallery"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: Icon(Icons.camera_alt),
                  title: Text("Take a Photo"),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColor.scafoldcolor,
      appBar: AppBar(
        backgroundColor: ConstantColor.appbarcolor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("Profile"),
      ),
      body: SafeArea(
        child: Form(
          key: profileformKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                CupertinoButton(
                    child: CircleAvatar(
                      backgroundColor: ConstantColor.appbarcolor,
                      radius: 60,
                      backgroundImage:
                          (imageFile != null) ? FileImage(imageFile!) : null,
                      child: (imageFile == null)
                          ? Icon(
                              Icons.person,
                              size: 60,
                            )
                          : null,
                    ),
                    onPressed: () {
                      showPhotoOptions();
                    }),
                SizedBox(
                  height: 30,
                ),
                kCustomeTextField(
                  validate: (val) {
                    return controller.validate_name(val);
                  },
                  controller: fullNameController,
                  hintText: "Full Name",
                ),
                SizedBox(
                  height: 20,
                ),

                Obx(() => controller.isLoading.value == true
                    ? Center(
                        child: CircularProgressIndicator(
                        color: ConstantColor.appbarcolor,
                      ))
                    : CustomButton(
                        buttonFunction: () async {
                          validateForm();
                        },
                        textString: 'Submit',
                        buttonColor: ConstantColor.appbarcolor,
                        buttonHeight: 50,
                        buttonWidth: MediaQuery.of(context).size.width,
                        textColor: Colors.white,
                        textSize: 20,
                        textWeight: FontWeight.w700,
                      )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
