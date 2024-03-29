import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Root(),
    );
  }
}

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {

  @override
  void initState() {
   final  _auth = FirebaseAuth.instance;

    _auth.currentUser().then((FirebaseUser firebaseUser){
      Future.delayed(Duration(seconds: 2)).then((_){
        if(firebaseUser != null){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>ChatScreen()), (_)=>false);
        }

        else{
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>WelcomeScreen()), (_)=>false);
        }

      });

    });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}

