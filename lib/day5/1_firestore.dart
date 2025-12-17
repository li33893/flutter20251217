import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore fs =FirebaseFirestore.instance;
    //假如想接近users->fs.collection("users")
    //fs.collection("users").add()
    //fs.collection("users").get()
    //fs.collection("users").update()
    //fs.collection("users").delete()

    Future <void> createUser() async{
      // Map <String, dynamic> user=
      // await fs.collection("users").add({
      //   "name":"honggildong",
      //   "age":30,
      //   "addr":"hello",
      //   "cdate":Timestamp.now()
      // } );

      await fs.collection("users").doc("documentIDzzz").set({
        "name":"honggildong",
        "age":30,
        "addr":"hello",
        "cdate":Timestamp.now()
      } );


      await fs.collection("users").doc("abcd").set({
        "name":"honggildong",
        "age":30,
        "addr":"hello",
        "cdate":Timestamp.now()
      } );



    }

    Future <void> readUser() async{

     // final snapshot= await fs.collection("users").get();

     final snapshot= await fs.collection("users")
                              // .where("age",isGreaterThan: 20)//age>20
                              .where("age",isGreaterThanOrEqualTo: 20)//age>=20
                             .orderBy("age",descending: true)
                             .get();
     print(snapshot.docs[0].data());//返回的是Map <String, dynamic>形式的数据
      for(var doc in snapshot.docs){
        Map <String, dynamic> data=doc.data();
        print("docId:${doc.id},name:${data["name"]},age:${data["age"]}");

      }


    }


    Future <void> updateUser() async{
      await fs.collection("users").doc("DYZZXedWRZZwR5z9iD4N").update({
        "name":"kimcheolsu",
        "age":30,
      });
    }

    Future <void> deleteUser() async{
      await fs.collection("users").doc("abcd").delete();
    }

    return MaterialApp(
        home:Scaffold(
          body: Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: createUser, child: Text("삽입")),
                ElevatedButton(onPressed: readUser, child: Text("목록")),
                ElevatedButton(onPressed: updateUser, child: Text("수정")),
                ElevatedButton(onPressed: deleteUser, child: Text("삭제")),
              ],
            )
          ),

        )
    );
  }
}