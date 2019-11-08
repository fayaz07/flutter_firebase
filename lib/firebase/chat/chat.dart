import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'chat_menu_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

int messageCounter;

List<MessageModel> _messages = [];

String currentMessage = "";

String roomId;
String agentId;

void main() {
  runApp(MaterialApp(
    home: Chat('1', "111"),
  ));
}

class AppUtils {
  static bool isEnglish = true;
}

class Chat extends StatefulWidget {
  Chat(String room_id, String agent) {
    roomId = room_id;
    agentId = agent;
  }

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  var formKey = GlobalKey<FormState>();
  ScrollController _scrollController = new ScrollController();
  TextEditingController _textEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                title: Text(
                    AppUtils.isEnglish ? 'Chat screen' : 'Tela de bate-papo')),
            body: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection(roomId)
                  .orderBy('createdAt')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text(AppUtils.isEnglish
                      ? 'Error: ${snapshot.error}'
                      : 'Erro: ${snapshot.error}');
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    _messages.clear();

                    for (var c in snapshot.data.documents) {
                      _messages.add(MessageModel(
                          createdAt: c['createdAt'].toString(),
                          message: c['message'],
                          author: c['author']));
                    }
                    return getMessageHistoryBody();
                }
              },
            ),
            bottomSheet: getSendMessageField()));
  }

  Widget getMessageHistoryBody() {
    return ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        itemCount: _messages.length,
        itemBuilder: (BuildContext context, int i) {
          if (i != _messages.length - 1) {
            return _messages[i].author == 'a'
                ? IncomingMessage(_messages[i].message)
                : OutgoingMessage(_messages[i].message);
          }
          return Container(
              child: _messages[i].author == 'a'
                  ? IncomingMessage(_messages[i].message)
                  : OutgoingMessage(_messages[i].message),
              margin: EdgeInsets.only(bottom: 50.0));
        });
  }

  Widget getSendMessageField() {
    return Row(
      key: Key('sendMessageField'),
      children: <Widget>[
        Expanded(
          key: Key('textField'),
          child: Container(
              margin: EdgeInsets.all(8.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300.0),
                child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: TextFormField(
                          controller: _textEditingController,
                          maxLines: null,
                          showCursor: true,
                          cursorColor: Colors.blue,
                          keyboardType: TextInputType.text,
                          maxLengthEnforced: false,
                          cursorWidth: 3.0,
                          style: TextStyle(color: Colors.black),
                          onSaved: (String message) {
                            if (message.length != 0) {
                              sendMessage(message);
                              _textEditingController.clear();
                            }
                          },
                          decoration: InputDecoration(
                              hintText: AppUtils.isEnglish
                                  ? 'Type your message here..'
                                  : 'Digite sua mensagem..',
                              contentPadding: EdgeInsets.only(
                                  bottom: 15.0,
                                  left: 20.0,
                                  right: 20.0,
                                  top: 10.0),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          Colors.orangeAccent.withOpacity(0.4)),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(30.0))))),
                    )),
              )),
        ),
        CupertinoButton(
            padding: EdgeInsets.all(0.0),
            onPressed: () {
              formKey.currentState.save();
            },
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(50.0))),
              child: Icon(Icons.send, color: Colors.white, size: 22.0),
            )),
        SizedBox(width: 10.0)
      ],
    );
  }

  Future getMessagesFromServer() {
    setState(() {
      Firestore.instance
          .collection(roomId)
          .orderBy('createdAt')
          .snapshots()
          .listen((QuerySnapshot data) {
        for (var c in data.documents) {
          _messages.add(MessageModel(
              message: c.data['message'],
              author: c.data['author'],
              createdAt: c.data['createdAt']));
        }
      });
    });
  }

  sendMessage(String message) {
    setState(() {
      var now = new DateTime.now();
      var formatter = new DateFormat('MM/dd/yyyy h:mm:ss a');
      String formatted = formatter.format(now);
      //print(formatted); // something like 2013-04-20
//      _messages.add(MessageModel(
//          message: message, createdAt: DateTime.now().toString(), author: 'b'));

      Firestore.instance
          .collection(roomId)
          .add({'message': message, 'author': 'b', 'createdAt': formatted});

      _scrollController.position.animateTo(
          _scrollController.position.maxScrollExtent > 0
              ? _scrollController.position.maxScrollExtent + 30
              : _scrollController.position.maxScrollExtent + 10,
          duration: Duration(milliseconds: 100),
          curve: Curves.decelerate);
    });
  }
}
