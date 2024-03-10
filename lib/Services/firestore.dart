import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
  //get collection
  final CollectionReference notes = FirebaseFirestore.instance.collection("notes");
  //Create
  Future<void>addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }
    //read
    Stream<QuerySnapshot>getNote(){
      final notestream = notes.orderBy('timestamp',descending: true).snapshots();
      return notestream;
    }
    //Update
    Future<void> updatesNote(String docID,String newNote){
    return notes.doc(docID).update({
      'note':newNote,
      'timestamp':Timestamp.now(),
    });
    }
    //Delete
    Future<void>deleteNote(String docID){
    return notes.doc(docID).delete();
  }

  }


