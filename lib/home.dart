import 'package:cloud_firestore/cloud_firestore.dart';

import 'Services/firestore.dart';
import 'package:flutter/material.dart';
 class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService firestoreService  = FirestoreService();
   //text controller
  final TextEditingController textcontroller = TextEditingController();

  // open a box
   void openBox({String? docID}){
    showDialog(
      context: context,
      builder: (contex)=> AlertDialog(
      content: TextField(
        controller: textcontroller,
      ),
        actions: [
          ElevatedButton(onPressed: (){
            if(docID==null){
              firestoreService.addNote(textcontroller.text);
            }
            else
              {
                firestoreService.updatesNote(docID,textcontroller.text);
              }
            //clear the text
            textcontroller.clear();
            //close the box
            Navigator.pop(context);
          }, child: Text("Add"))
        ],
    ),
    );
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         backgroundColor: Colors.blue,
         title: Text("CRUD"),
       ),
       floatingActionButton: FloatingActionButton(
         onPressed: openBox,
         child: Icon(Icons.add),
       ),
       body: StreamBuilder<QuerySnapshot>(
         stream: firestoreService.getNote(),
         builder: (context,snapshot){
           if(snapshot.hasData){
             List noteList = snapshot.data!.docs;
             return ListView.builder(
               itemCount: noteList.length,
                 itemBuilder: (context,index){
                   //get each individual doc
                   DocumentSnapshot document = noteList[index];
                   String docID = document.id;
                   //get note from each doc
                   Map<String,dynamic> data = document.data() as Map<String,dynamic>;
                   String noteText = data['note'];
                   //display as list title
                   return ListTile(
                     title: Text(noteText),
                     trailing: Row(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         IconButton(
                           onPressed: () =>openBox(docID: docID),
                           icon: Icon(Icons.settings),
                         ),
                         //delete button
                         IconButton(
                           onPressed: () =>firestoreService.deleteNote(docID),
                           icon: Icon(Icons.delete),
                         ),
                       ],
                     ),
                   );
                 });
           }
           else{
             return const Text("no notes");

           }
         },
       ),
     );
   }
}
