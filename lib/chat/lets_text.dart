import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(MaterialApp(home: LetsChat()));

class Session {
  static bool isSelectMode = false;
}

class LetsChat extends StatefulWidget {
  @override
  _LetsChatState createState() => _LetsChatState();
}

class _LetsChatState extends State<LetsChat> {
  TextEditingController _textEditingController = TextEditingController();
  StreamController<List<Message>> messages = StreamController();

  ScrollController scrollController = ScrollController();

  List<Message> list = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    messages.close();
    _textEditingController.dispose();
    messages.sink.close();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            top: 4.0, bottom: 20.0, left: 4.0, right: 4.0),
        child: StreamBuilder<List<Message>>(
            stream: messages.stream,
            initialData: list,
            builder:
                (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
              return snapshot.hasData
                  ? snapshot.data != null
                      ? ListView.builder(
                          controller: scrollController,
                          itemCount: snapshot.data.length + 1,
                          itemBuilder: (context, index) {
                            return snapshot.data.length == index
                                ? SizedBox(height: 40.0)
                                : TextMessage(message: snapshot.data[index]);
                          },
                          physics: BouncingScrollPhysics(),
                        )
                      : Container()
                  : Container();
            }),
      ),
      bottomSheet: getSendMessageField(),
    );
  }

  sendMessage(message) {
    if (_textEditingController.text.length > 0) {
      _textEditingController.clear();
      list.add(Message(
          message: message,
          timestamp: DateTime.now().toString(),
          type: list.length % 2 == 0
              ? MessageType.IncomingText
              : MessageType.OutgoingText));
      messages.sink.add(list);
      Future.delayed(Duration(milliseconds: 100)).whenComplete(() {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
      });
    }
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
//                          _textEditingController.clear();
                        }
                      },
                      decoration: InputDecoration(
                          hintText: 'Type your message here..',
                          contentPadding: EdgeInsets.only(
                              bottom: 15.0, left: 20.0, right: 20.0, top: 10.0),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.orangeAccent.withOpacity(0.4)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0))))),
                )),
          ),
        ),
        CupertinoButton(
            padding: EdgeInsets.all(0.0),
            onPressed: () {
              print("button pressed");
              print(_textEditingController.text);
              sendMessage(_textEditingController.text);
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
}

class Message {
  String message, author, timestamp, timestampValue;
  MessageType type;

  Message(
      {this.message,
      this.author,
      this.timestamp,
      this.timestampValue,
      this.type});
}

enum MessageType { IncomingText, OutgoingText }

class TextMessage extends StatefulWidget {
  Message message;

  TextMessage({this.message});

  @override
  _TextMessageState createState() => _TextMessageState();
}

class _TextMessageState extends State<TextMessage> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: selected
            ? Container(color: Colors.blue.withOpacity(0.4), child: child())
            : child(),
      onLongPress: (){
          if(!Session.isSelectMode)
            setState(() {
              Session.isSelectMode = true;
              selected = true;
            });
      },
      onTap: (){
          if(Session.isSelectMode){
            setState(() {
                selected = !selected;
            });
          }
      },
    );
  }

  Widget child() => Align(
        alignment: widget.message.type == MessageType.IncomingText
            ? Alignment.topLeft
            : Alignment.topRight,
        child: Card(
          elevation: 1.5,
          margin: const EdgeInsets.only(
              left: 8.0, right: 8.0, bottom: 3.5, top: 3.5),
          color: widget.message.type == MessageType.IncomingText
              ? Colors.white
              : Color(0xFFDCF8C6),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: BorderSide(color: Colors.grey.withOpacity(0.1))),
          child: Container(
            margin: const EdgeInsets.only(
                top: 5.0, bottom: 5.0, left: 8.0, right: 8.0),
            constraints: BoxConstraints(maxWidth: 250.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        widget.message.message,
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    widget.message.timestamp,
                    style: TextStyle(color: Colors.black, fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
