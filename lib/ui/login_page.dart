import 'dart:async';

import 'package:firebase_demo/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth firebaseAuth = FirebaseAuth.instance;
GoogleSignIn googleSignIn = new GoogleSignIn();
TextEditingController emailController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: RaisedButton(
                onPressed: () => _gSignIn(),
                color: Colors.blueAccent,
                child: Text("Google Sign In"),
                textColor: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: RaisedButton(
                onPressed: () => _gSignIn(),
                color: Colors.orange.shade300,
                child: Text("Sign In with Email"),
                textColor: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: RaisedButton(
                onPressed: () => _showDialog(),
                color: Colors.redAccent,
                child: Text("Create Account"),
                textColor: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: RaisedButton(
                onPressed: () => _signInDialog(),
                color: Colors.blueGrey,
                child: Text("Sign In With Email"),
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<FirebaseUser> _gSignIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    FirebaseUser firebaseUser = await firebaseAuth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    print("User is: ${firebaseUser.displayName}");
  }

  _showDialog() {
    var alert = AlertDialog(
      title: Text("Create Account"),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: emailController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Email",
              icon: Icon(Icons.email),
            ),
          ),
          TextField(
            controller: passwordController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Password",
              icon: Icon(Icons.lock),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _createUser();
            Navigator.pop(context);
          },
          child: Text("Sign Up"),
        ),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  _signInDialog() {
    var alert = AlertDialog(
      title: Text("Sign In"),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: emailController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Email",
              icon: Icon(Icons.email),
            ),
          ),
          TextField(
            controller: passwordController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: "Password",
              icon: Icon(Icons.lock),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            _signInWithEmail();
          },
          child: Text("Sign In"),
        ),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancel"))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  Future _createUser() async {
    FirebaseUser user = await firebaseAuth
        .createUserWithEmailAndPassword(
        email: emailController.text, password: passwordController.text)
        .then((newUser) {
      print("User Created ${newUser.email}");
      var route = MaterialPageRoute(builder: (BuildContext context) {
        return MyHomePage();
      });
      Navigator.of(context).push(route);
    });
    emailController.clear();
    passwordController.clear();


  }
  Future _signInWithEmail() async {
    FirebaseUser user = await firebaseAuth
        .signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text)
        .then((newUser) {
      print("User Signed ${newUser.email}");
      var route = MaterialPageRoute<Map>(
          builder: (BuildContext context) {
            return MyHomePage(
              email: newUser.email,
            );
          });
      Navigator.of(context).push(route);
  });
    emailController.clear();
    passwordController.clear();
}
}
