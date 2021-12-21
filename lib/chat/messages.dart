import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'messagebubble.dart';

class Messages extends StatelessWidget {
  CollectionReference chat = FirebaseFirestore.instance.collection('chat');
  CollectionReference users = FirebaseFirestore.instance.collection('users');


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: chat.orderBy('time', descending: true).snapshots(),
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
      //  final map = <String, dynamic>{};
       // print(map.runtimeType);
       // print('${map is Map<String, dynamic>}');

       Map<String,dynamic> querySnapshot = users.get() as Map<String, dynamic>  ;
       // querySnapshot is Map<String, dynamic>;
       // print('${querySnapshot.docs is Map<String, dynamic>}');
        var docs = querySnapshot.docs as Map<dynamic, dynamic> ;
        docs = docs.map((doc) => doc.get('users')).toList();
        final user = FirebaseAuth.instance.currentUser;
        print(querySnapshot.runtimeType);

        return ListView.builder(
          reverse: true,
          itemCount: docs.length,
          itemBuilder: (ctx, index) => MessageBubble(
            docs[index]['text'],
            docs[index]['username'],
            docs[index]['userId'] == user!.uid,
            key: ValueKey(docs[index]!.documentID),
          ),
        );
      },
    );
  }
}
