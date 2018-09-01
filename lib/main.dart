import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_demo/model/board.dart';
import 'package:firebase_demo/ui/login_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Community Board',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String email;

  MyHomePage({this.email, Key key}): super(key:key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Board> boardMessages = List();
  Board board;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference databaseReference;

  @override
  void initState() {
    super.initState();

    board = Board("", "");
    databaseReference = database.reference().child("community_board");
    databaseReference.onChildAdded.listen(_onEntryAdded);
    databaseReference.onChildChanged.listen(_onEntryChanged);
//    databaseReference.onChildRemoved.listen(_onChildRemoved);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Community Blog's"),
        centerTitle: true,
      ),
      backgroundColor: Colors.blue.shade200,
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 0,
            child: Center(
              child: Form(
                key: formKey,
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.subject),
                      title: TextFormField(
                        initialValue: "",
                        onSaved: (val) => board.subject = val,
                        validator: (val) => val == "" ? val : null,
                      ),
                    ),

                    ListTile(
                      leading: Icon(Icons.message),
                      title: TextFormField(
                        initialValue: "",
                        onSaved: (val) => board.body = val,
                        validator: (val) => val == "" ? val : null,
                      ),
                    ),

                    //Send or Post button
                    FlatButton(
                      child: Text(
                        "Post",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                      onPressed: () {
                        handleSubmit();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            child: FirebaseAnimatedList(
              query: databaseReference,
              itemBuilder: (_, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return new Card(
                  color: Colors.blue.shade300,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 14.0,
                      child: Text("${boardMessages[index].subject[0]}"),
                    ),
                    title: Text(
                      boardMessages[index].subject,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      boardMessages[index].body,
                      style: TextStyle(color: Colors.black38, fontSize: 15.0),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _onEntryAdded(Event event) {
    setState(() {
      boardMessages.add(Board.fromSnapshot(event.snapshot));
    });
  }

  void handleSubmit() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      form.reset();
      //save form data to the database
      databaseReference.push().set(board.toJson());
    }
  }

  void _onEntryChanged(Event event) {
    var old_entry = boardMessages.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      boardMessages[boardMessages.indexOf(old_entry)] =
          Board.fromSnapshot(event.snapshot);
    });
  }

}
