import 'package:chat_app/reusable_widght/reusable_textform_field.dart';
import 'package:chat_app/screens/auth_screen/sigup/signup_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant_widget/constant_colors.dart';
import '../../../reusable_widght/custom_button.dart';
import 'login_screen_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  // final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColor.scafoldcolor,
        body: GetBuilder<LoginController>(
        init: LoginController(),
        builder: (loginScreenController) {
          return
            Form(
            key: loginScreenController.loginKey,
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
                            return loginScreenController.validate_email(val);
                          },
                          controller: loginScreenController.emailController,
                          hintText: "Email Your Email",
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        kCustomeTextField(
                          validate: (val) {
                            return loginScreenController.validate_password(val);
                          },
                          controller: loginScreenController.passwordC,
                          isPassword: loginScreenController.isVisible,
                          hintText: "Enter Password here...",
                          icon: IconButton(
                            onPressed: () {
                              loginScreenController.changeVisibilityPassword();
                            },
                            icon: loginScreenController.isVisible
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Obx(() => loginScreenController.isLoading.value == true
                            ? Center(
                            child: CircularProgressIndicator(
                              color: ConstantColor.appbarcolor,
                            ))
                            : CustomButton(
                          buttonFunction: () async {
                            loginScreenController.validateForm();
                          },
                          textString: 'LOGIN',
                          buttonColor: ConstantColor.appbarcolor,
                          buttonHeight: 50,
                          buttonWidth: MediaQuery.of(context).size.width,
                          textColor: Colors.white,
                          textSize: 20,
                          textWeight: FontWeight.w700,
                        )),

                        // Obx(() => loginScreenController.isLoading.value == true
                        //     ? Center(
                        //         child: CircularProgressIndicator(
                        //         color: ConstantColor.appbarcolor,
                        //       ))
                        //     : CustomButton(
                        //         buttonFunction: () async {
                        //           loginScreenController.validateForm();
                        //         },
                        //         textString: 'LOGIN',
                        //         buttonColor: ConstantColor.appbarcolor,
                        //         buttonHeight: 50,
                        //         buttonWidth: MediaQuery.of(context).size.width,
                        //         textColor: Colors.white,
                        //         textSize: 20,
                        //         textWeight: FontWeight.w700,
                        //       )),
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
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Already have an account?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            CupertinoButton(
                child: Text("Sign Up", style: TextStyle(
                  fontSize: 16,
                ),),
                onPressed: () {
                  Get.to(()=>SignUpScreen());
                }
                )
          ],
        ),
      ),
    );
  }
}
