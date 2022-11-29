import 'package:chat_app/reusable_widght/reusable_textform_field.dart';
import 'package:chat_app/screens/auth_screen/login/login_screen.dart';
import 'package:chat_app/screens/auth_screen/sigup/signup_screen_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant_widget/constant_colors.dart';
import '../../../reusable_widght/custom_button.dart';


class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE9F5E4),
      body: GetBuilder<SignUpController>(
        init: SignUpController(),
        builder: (signUpScreenController) {
          return Form(
            key: signUpScreenController.signUpKey,
            child: Container(
              child: SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          children: [
                            Image.asset("assets/images/chatapp_icon.png",
                            height: 200,
                              width: 200,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            kCustomeTextField(
                              validate: (val) {
                                return signUpScreenController.validate_email(val);
                              },
                              controller: signUpScreenController.emailController,
                              hintText: "Email Your Email",
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            kCustomeTextField(
                              validate: (val) {
                                return signUpScreenController.validate_password(val);
                              },
                              controller: signUpScreenController.passwordC,
                              isPassword: signUpScreenController.isVisible,
                              hintText: "Enter Password here...",
                              icon: IconButton(
                                onPressed: () {
                                  signUpScreenController.changeVisibilityPassword();
                                },
                                icon: signUpScreenController.isVisible
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            kCustomeTextField(
                              validate: (val) {
                                return signUpScreenController
                                    .validate_conformpassword(val);
                              },
                              controller:
                              signUpScreenController.conformPasswordController,
                              isPassword: signUpScreenController
                                  .isVisibleConfirmPassword,
                              hintText: "Enter Conform Password here...",
                              icon: IconButton(
                                onPressed: () {
                                  signUpScreenController
                                      .changeVisibilityConfirmPassword();
                                },
                                icon: signUpScreenController
                                    .isVisibleConfirmPassword
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),


                            Obx(() => controller.isLoading.value == true
                                ? Center(
                                child: CircularProgressIndicator(
                                  color: ConstantColor.appbarcolor,
                                ))
                                : CustomButton(
                              buttonFunction: () async {
                                signUpScreenController.validateForm();
                              },
                              textString: 'Sign Up',
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
                  )),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        color: Color(0xffE9F5E4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            CupertinoButton(
                child: Text("Login", style: TextStyle(
                  fontSize: 16,
                ),),
                onPressed: () {
                  Get.to(()=>LoginScreen());
                }
            )
          ],
        ),
      ),
    );
  }
}
