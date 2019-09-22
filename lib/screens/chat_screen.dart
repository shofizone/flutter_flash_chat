import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  String messageText;
  final _firestore = Firestore.instance;
  String loggedUser;
  TextEditingController _textEditingController = TextEditingController();




  @override
  void initState() {
    _auth.currentUser().then((firebaseUser) {
      loggedUser = firebaseUser.email;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => WelcomeScreen()),
                    (_) => false);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('message').snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        List<DocumentSnapshot> messages =
                            snapshot.data.documents.reversed.toList();
                        return ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (messages[index]["sender"] == loggedUser) {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Text(""),
                                title: Material(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      messages[index]["message"],
                                      textAlign: TextAlign.right,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                  messages[index]["sender"],
                                  textAlign: TextAlign.right,
                                ),
                              );
                            } else {
                              return ListTile(
                                title: Material(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      messages[index]["message"],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                  messages[index]["sender"],
                                  textAlign: TextAlign.right,
                                ),
                                trailing: Text(""),
                              );
                            }
                          },
                        );
                      }
                      return Container();
                    })),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      _firestore
                          .collection("message")
                          .document(DateTime.now().toIso8601String()+loggedUser)
                          .setData(
                              {"sender": loggedUser, "message": messageText});

                      _textEditingController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
