import 'dart:developer';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/UserModel.dart';
import 'package:chat_app/models/chat_Room_Model.dart';
import 'package:chat_app/reusable_widght/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant_widget/constant_colors.dart';
import '../../reusable_widght/reusable_textform_field.dart';
import '../chat_room/chat_room_screen.dart';

class SearchScreen extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const SearchScreen(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // final controller = Get.put(SearchScreenController());
  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();
    if (snapshot.docs.length > 0) {
      log("chat room already created");
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom = ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      chatRoom == existingChatroom;
    } else {
      ChatRoomModel newChatroom =
          ChatRoomModel(chatroomid: uuid.v1(), lastMessage: "", participants: {
        widget.userModel.uid.toString(): true,
        targetUser.uid.toString(): true,
      });
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());
      chatRoom =  newChatroom;
      log("New Chat Room Created");
    }
    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColor.scafoldcolor,
      appBar: AppBar(
        backgroundColor: ConstantColor.appbarcolor,
        title: Text("Search"),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              kCustomeTextField(
                controller: searchController,
                hintText: "Search Here",
              ),
              SizedBox(
                height: 20,
              ),
              CustomButton(
                  buttonFunction: () {
                    setState(() {});
                  },
                  textString: "Search",
                  buttonColor: ConstantColor.appbarcolor,
                  buttonHeight: 50,
                  buttonWidth: MediaQuery.of(context).size.width / 2,
                  textColor: Colors.white,
                  textSize: 20,
                  textWeight: FontWeight.w600),
              SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .where("fullname", isEqualTo: searchController.text)
                    //.where("email", isNotEqualTo: widget.userModel.fullname)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;
                      if (dataSnapshot.docs.length > 0) {
                        Map<String, dynamic> userMap =
                            dataSnapshot.docs[0].data() as Map<String, dynamic>;
                        UserModel searchedUser = UserModel.fromMap(userMap);
                        return ListTile(
                          onTap: () async {
                            ChatRoomModel? chatroomModel =
                            await getChatroomModel(searchedUser);
                            if(chatroomModel != null){
                              Navigator.pop(context);
                              Get.to(() =>
                                  ChatRoomScreen(
                                    targetUser: searchedUser,
                                    chatroom: chatroomModel,
                                    userModel: widget.userModel,
                                    firebaseUser: widget.firebaseUser,
                                  )
                              );
                            }
                          },
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(searchedUser.profilepic!),
                          ),
                          title: Text(searchedUser.fullname!),
                          subtitle: Text(searchedUser.email!),
                          trailing: Icon(Icons.keyboard_arrow_right_rounded),
                        );
                      } else {
                        return Text("No result found");
                      }
                    } else if (snapshot.hasError) {
                      return Text("An Error");
                    } else {
                      return Text("No result found");
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
