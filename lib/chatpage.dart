import 'package:chat/loginsignup/signup.dart';
import 'package:chat/utils/multi2.dart';
import 'package:chat/utils/multi3.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../provider/provider1.dart';
import '../utils/forgotLink.dart';
import '../utils/multiText.dart';


class LandingChat extends StatelessWidget {
  String? uid;
  LandingChat(
    {super.key,
    required this.uid
    });
  
  @override
  final message = TextEditingController();
  Widget build(BuildContext context) {
    final Provider11 = Provider.of<Provider1>(context, listen: true);
      var uuid = Uuid();
      
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('chats').doc(uid!).collection("subChat").snapshots();
    
    return Scaffold(
      backgroundColor: Color(0xff1B1B1B),
      appBar: AppBar(
        backgroundColor: Color(0xff009ae2),
        centerTitle: true,
        title: Column(children: [
          Multi3(color: Colors.white, subtitle: "Group Chat", weight: FontWeight.bold, size: 16),
          Multi(color: Colors.green, subtitle: "Online", weight: FontWeight.bold, size: 12),
        ]),
        ),
      body:Stack(
        children: <Widget>[
          // chat messages here
          // chatMessages(context),
          StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
          
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }
          
              return Padding(
                padding:EdgeInsets.only(bottom: 100.h,right: 15.w,left: 15.w),
                child: ListView(
                  // shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: (){
                       
                      },
                      child: data['uid']==Provider11.uid?ChatBubble(
                      clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.only(top: 20),
                      backGroundColor: Colors.blue,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                Multi2(color: Colors.white, subtitle: data['name'].toString(), weight: FontWeight.normal, size: 8),
                SizedBox(height: 2.h,),
                Text(
                  "${data['message']}",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 2.h,),
                Multi2(color: Colors.white, subtitle: data['time'].toString(), weight: FontWeight.normal, size: 8)
                          ],
                        ),
                      ),
                    ):ChatBubble(
                      clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(top: 20),
                      backGroundColor: Color(0xffb929be),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                Multi2(color: Colors.white, subtitle: data['name'].toString(), weight: FontWeight.normal, size: 8),
                SizedBox(height: 2.h,),
                Text(
                  "${data['message']}",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 2.h,),
                Multi2(color: Colors.white, subtitle: data['time'].toString(), weight: FontWeight.normal, size: 8)
                          ],
                        ),
                      ),
                    )
                    );
                  }).toList(),
                ),
              );
            },
              ),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[700],
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  controller: message,
                  style: const TextStyle(color: Colors.white),
                  decoration:InputDecoration(
                    hintText: "Send a message...",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                    border: InputBorder.none,
                  ),
                )),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    CollectionReference chatRoom = FirebaseFirestore.instance.collection('chats').doc(uid).collection("subChat");
                    chatRoom.add({
                      "name":Provider11.name,
                      "uid":Provider11.uid,
                      "message":message.text,
                      "timestamp":DateTime.now(),
                      "time":"${DateTime.now().hour}:${DateTime.now().minute}"
                    });
                    message.clear();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}