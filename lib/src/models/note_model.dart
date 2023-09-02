import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class NoteModel {
  static String collectionName = "myNotes";

  String? uid;

  String? title;
  String? body;

  Timestamp? createdAt;
  Timestamp? updatedAt;

  NoteModel({
    this.uid,
    this.title,
    this.body,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'title': title,
      'body': body,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      body: map['body'] != null ? map['body'] as String : null,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  Future<void> create() async {
    uid ??= const Uuid().v1();
    createdAt ??= Timestamp.now();
    updatedAt ??= Timestamp.now();
    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(uid)
        .set(toMap());
  }

  // update
  Future<void> update() async {
    updatedAt = Timestamp.now();
    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(uid)
        .update(toMap());
  }

  // delete
  Future<void> delete() async {
    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(uid)
        .delete();
  }

  static Stream<List<NoteModel>> steamAll() {
    return FirebaseFirestore.instance
        .collection(collectionName)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => NoteModel.fromMap(e.data())).toList());
  }
}
