
import 'package:firebase_database/firebase_database.dart';

class Board{
  String key;
  String body;
  String subject;

  Board(this.body, this.subject);

  Board.fromSnapshot(DataSnapshot snapshot):
      key = snapshot.key,
      subject = snapshot.value["subject"],
      body = snapshot.value["body"];

  toJson(){
    return {
      "subject" : subject,
      "body" : body,
    };
  }
}