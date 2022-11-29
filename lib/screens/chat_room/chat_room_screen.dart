import 'dart:developer';

import 'package:chat_app/main.dart';
import 'package:chat_app/models/UserModel.dart';
import 'package:chat_app/models/chat_Room_Model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time/date_time.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constant_widget/constant_colors.dart';


class ChatRoomScreen extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatroom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoomScreen({Key? key,
    required this.targetUser,
    required this.chatroom,
    required this.userModel,
    required this.firebaseUser})
      : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  TextEditingController messageController = TextEditingController();
  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();
    if (msg != "") {
      var datee = Date.now();
      MessageModel newMessage = MessageModel(
        messageid: uuid.v1(),
        sender: widget.userModel.uid,
        createdon: datee.toString(),
        text: msg,
        seen: false,
      );
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatroom.chatroomid)
          .collection("messages")
          .doc(newMessage.messageid)
          .set(newMessage.toMap());
      log("message sent");
      widget.chatroom.lastMessage = msg;
      FirebaseFirestore.instance.collection("chatrooms").doc(
          widget.chatroom.chatroomid).set(widget.chatroom.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:ConstantColor.scafoldcolor,
      appBar: AppBar(
        backgroundColor: ConstantColor.appbarcolor,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.targetUser.profilepic!),
            ),
            SizedBox(
              width: 10,
            ),
            Text(widget.targetUser.fullname!),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10
                    ),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("chatrooms")
                          .doc(widget.chatroom.chatroomid)
                          .collection("messages")
                          .orderBy("createdon", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.hasData) {
                            QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;
                            return ListView.builder(
                                reverse: true,
                                itemCount: dataSnapshot.docs.length,
                                itemBuilder: (context, index) {
                                  MessageModel currentMessage =
                                  MessageModel.fromMap(dataSnapshot.docs[index]
                                      .data() as Map<String, dynamic>);
                                  return Row(
                                    mainAxisAlignment: (currentMessage.sender ==
                                        widget.userModel.uid) ?
                                    MainAxisAlignment.end : MainAxisAlignment
                                        .start,
                                    children: [
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 5),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 10
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                10),
                                            color: (currentMessage.sender ==
                                                widget.userModel.uid) ? Colors
                                                .grey : Theme
                                                .of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                          child: Text(
                                            currentMessage.text.toString(),
                                            style: TextStyle(
                                                color: Colors.white
                                            ),)),
                                    ],
                                  );
                                });
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                  "An Error Occured! please check your internet connection"),
                            );
                          } else {
                            return Center(
                              child: Text("Say Hi to  your new freind"),
                            );
                          }
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  )),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  children: [
                    Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextField(
                            maxLines: null,
                            controller: messageController,
                            decoration: InputDecoration(
                              hintText: "Enter Message",
                              focusedBorder: OutlineInputBorder(
                                  borderSide: Divider.createBorderSide(context),
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: Divider.createBorderSide(context),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        )),
                    IconButton(
                        onPressed: () {
                          sendMessage();
                        },
                        icon: Icon(
                          Icons.send,
                          color: ConstantColor.appbarcolor,
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
