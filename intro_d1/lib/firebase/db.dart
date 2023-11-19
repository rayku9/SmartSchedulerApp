import 'package:cloud_firestore/cloud_firestore.dart';
import 'authentication.dart';

String collection = 'scheduler';

Future<Map?> getUserInfo() async {
  Map? data;
  String uid = AuthenticationHelper().uid;
  try {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        data = documentSnapshot.data() as Map?;
        print('Document data: ${documentSnapshot.data()}');
      } else {
        print('Document does not exist on the database');
      }
    });
  } catch (e) {
    print(e);
  }

  return data;
}

Future<bool> editUserInfo(Map<String, dynamic> data) async {
  String uid = AuthenticationHelper().uid;

  FirebaseFirestore.instance
      .collection(collection)
      .doc(uid)
      .set(data, SetOptions(merge: true));
  return true;
}

Future<bool> deleteTask(String task) async {
  String uid = AuthenticationHelper().uid;
  var db = FirebaseFirestore.instance.collection(collection);
  db.doc(uid).update({task: FieldValue.delete()});
  return true;
}

Future<bool> updateSchedule(data) async {
  String uid = AuthenticationHelper().uid;
  var db = FirebaseFirestore.instance.collection(collection);
  try{
    db.doc(uid).update({'schedule': data});
  }catch(e){
    editUserInfo(data);
  }

  return true;
}