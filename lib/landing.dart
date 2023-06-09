import 'package:chat/loginsignup/signup.dart';
import 'package:chat/utils/multi3.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'chatInbox.dart';
import 'chatpage.dart';
import 'loginsignup/login.dart';


class Landing extends StatelessWidget {
  const Landing({super.key});
  
  @override
  Widget build(BuildContext context) {
    final Provider11 = Provider.of<Provider1>(context, listen: true);
      var uuid = Uuid();
      
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots();
    
    return Scaffold(
       floatingActionButton: FloatingActionButton(
    child: Text('Action'), onPressed: () { 
      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatInbox()));
     },
  ),
      backgroundColor: Color(0xff1B1B1B),
      appBar: AppBar(backgroundColor: Color(0xff009ae2),),
      body: StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            return GestureDetector(
//               onTap: ()async{
//                 FirebaseFirestore.instance
//           .collection("users")
//           .doc(Provider11.uid).collection("chatPersons").doc(data['uid']).set({
//             "name":data['name'],
//             "uid":data['uid'],
//             "chatId":Provider11.uid!+data['uid']
//           });
//           final chatRoom = FirebaseFirestore.instance.collection('chats').doc(Provider11.uid!+data['uid']).collection("subChat");
//           DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
//     .collection('chats')
//     .doc(Provider11.uid! + data['uid'])
//     .get();
//     if (documentSnapshot.data() != null) {
//   print("exists");
// } else {
//    chatRoom.add({
//     "name":""
//   });
// }

          
//           //       var v1 = uuid.v1();
//           //       FirebaseFirestore.instance
//           // .collection("users")
//           // .doc(Provider11.uid).update({
//           //   "chats":{
//           //     v1
//           //   }
            
            
//           // });
//           //   FirebaseFirestore.instance
//           // .collection("users")
//           // .doc(data['uid']).update({
//           //   "chats":{
//           //     v1
//           //   }
            
            
//           // });
//           //       CollectionReference chatRoom = FirebaseFirestore.instance.collection('chats').doc(v1).collection("subChat");
//                 // chatRoom.add({
//                 //   "name":"",
  
//                 // });
           
//               },
onTap: () async {
  // Create or update the chat person document
  await FirebaseFirestore.instance
    .collection("users")
    .doc(Provider11.uid)
    .collection("chatPersons")
    .doc(data['uid'])
    .set({
      "name":data['name'],
      "uid":data['uid'],
      "chatId":Provider11.uid!+data['uid']
    });

    await FirebaseFirestore.instance
    .collection("users")
    .doc(data['uid'])
    .collection("chatPersons")
    .doc(Provider11.uid)
    .set({
      "name":Provider11.name,
      "uid":Provider11.uid,
      "chatId":Provider11.uid!+data['uid']
    });

  
  // Check if the chat room exists
  Navigator.push(context, MaterialPageRoute(builder: (context) => LandingChat(uid: Provider11.uid! + data['uid'],)));
}
,
              child: Container(
                child: data['uid']==Provider11.uid?Container(): Column(
                  children: [
                    ListTile(
                      title: Multi3(color: Colors.white, subtitle: "${data['email']}", weight: FontWeight.bold, size: 12),
                      subtitle: Multi3(color: Colors.white, subtitle: "${data['name']}", weight: FontWeight.normal, size: 12),
                    ),
                    SizedBox(height: 3.h,),
                    Divider(color: Colors.white,thickness: 1,)
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    ) ,
    );
  }
}