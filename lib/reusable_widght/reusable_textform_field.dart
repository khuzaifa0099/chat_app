import 'package:flutter/material.dart';

class kCustomeTextField extends StatefulWidget {
  String? hintText;
  TextEditingController? controller;
  Widget? icon;
  bool isPassword;
  var validate;
  bool check;
  final int? maxlines;
  final TextInputAction? inputAction;
  final FocusNode? focusNode;
  kCustomeTextField({
    this.hintText,
    this.controller,
    this.validate,
    this.isPassword=false,
    this.icon,
    this.check=false,
    this.maxlines,
    this.inputAction,
    this.focusNode,
  });
  @override
  State<kCustomeTextField> createState() => _kCustomeTextFieldState();
}
class _kCustomeTextFieldState extends State<kCustomeTextField> {
  bool visible=false;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xff9EA6BE)
          //color: Color(0xff0B0A3E)
        ),
        child: TextFormField(
          // maxLines: widget.maxlines,
          controller: widget.controller,
          validator: widget.validate,
          style: TextStyle(
              color: Colors.black
          ),
          cursorColor: Colors.white,
          focusNode: widget.focusNode,
          textInputAction: widget.inputAction,
          obscureText: widget.isPassword==false?false:widget.isPassword,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            fillColor: Colors.white10,
            contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            hintText: widget.hintText??"hint Text",
            suffixIcon: widget.icon,
            focusedBorder: OutlineInputBorder(
                borderSide: Divider.createBorderSide(context),
                borderRadius: BorderRadius.circular(10)
            ),
            enabledBorder:  OutlineInputBorder(
                borderSide: Divider.createBorderSide(context),
                borderRadius: BorderRadius.circular(10)
            ),
            filled: true,
          ),
        )
    );
  }
}