import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: ChatScreen()));

class Session {
  static bool isSelectMode = false;
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();
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

  int getLength(AsyncSnapshot<List<Message>> snapshot) {
    var length = 0;
    if (snapshot.data != null) {
      length = snapshot.data!.length;
    }
    return length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
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
                          itemCount: getLength(snapshot) + 1,
                          itemBuilder: (context, index) {
                            return getLength(snapshot) == index
                                ? const SizedBox(height: 40.0)
                                : TextMessage(message: snapshot.data![index]);
                          },
                          physics: const BouncingScrollPhysics(),
                        )
                      : Container()
                  : Container();
            }),
      ),
      bottomSheet: getSendMessageField(),
    );
  }

  sendMessage(message) {
    if (_textEditingController.text.isNotEmpty) {
      _textEditingController.clear();
      list.add(
        Message(
          message: message,
          timestamp: DateTime.now().toString(),
          type: list.length % 2 == 0
              ? MessageType.incomingText
              : MessageType.outgoingText,
          author: "",
          timestampValue: "",
        ),
      );
      messages.sink.add(list);
      Future.delayed(const Duration(milliseconds: 100)).whenComplete(() {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut);
      });
    }
  }

  Widget getSendMessageField() {
    return Row(
      key: const Key('sendMessageField'),
      children: <Widget>[
        Expanded(
          key: const Key('textField'),
          child: Container(
            margin: const EdgeInsets.all(8.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 300.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: TextFormField(
                  controller: _textEditingController,
                  maxLines: null,
                  showCursor: true,
                  cursorColor: Colors.blue,
                  keyboardType: TextInputType.text,
                  // maxLengthEnforced: false,
                  cursorWidth: 3.0,
                  style: const TextStyle(color: Colors.black),
                  onSaved: (String? message) {
                    if (message != null && message.isNotEmpty) {
                      sendMessage(message);
//                          _textEditingController.clear();
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Type your message here..',
                    contentPadding: const EdgeInsets.only(
                        bottom: 15.0, left: 20.0, right: 20.0, top: 10.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.orangeAccent.withOpacity(0.4)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(30.0)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        CupertinoButton(
          padding: const EdgeInsets.all(0.0),
          onPressed: () {
            if (kDebugMode) {
              print("button pressed");
              print(_textEditingController.text);
            }
            sendMessage(_textEditingController.text);
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(50.0))),
            child: const Icon(Icons.send, color: Colors.white, size: 22.0),
          ),
        ),
        const SizedBox(width: 10.0)
      ],
    );
  }
}

class Message {
  final String message, author, timestamp, timestampValue;
  final MessageType type;

  Message(
      {required this.message,
      required this.author,
      required this.timestamp,
      required this.timestampValue,
      required this.type});
}

enum MessageType { incomingText, outgoingText }

class TextMessage extends StatefulWidget {
  final Message message;

  const TextMessage({super.key, required this.message});

  @override
  TextMessageState createState() => TextMessageState();
}

class TextMessageState extends State<TextMessage> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: selected
          ? Container(color: Colors.blue.withOpacity(0.4), child: child())
          : child(),
      onLongPress: () {
        if (!Session.isSelectMode) {
          setState(() {
            Session.isSelectMode = true;
            selected = true;
          });
        }
      },
      onTap: () {
        if (Session.isSelectMode) {
          setState(() {
            selected = !selected;
          });
        }
      },
    );
  }

  Widget child() => Align(
        alignment: widget.message.type == MessageType.incomingText
            ? Alignment.topLeft
            : Alignment.topRight,
        child: Card(
          elevation: 1.5,
          margin: const EdgeInsets.only(
              left: 8.0, right: 8.0, bottom: 3.5, top: 3.5),
          color: widget.message.type == MessageType.incomingText
              ? Colors.white
              : const Color(0xFFDCF8C6),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: BorderSide(color: Colors.grey.withOpacity(0.1))),
          child: Container(
            margin: const EdgeInsets.only(
                top: 5.0, bottom: 5.0, left: 8.0, right: 8.0),
            constraints: const BoxConstraints(maxWidth: 250.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        widget.message.message,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    widget.message.timestamp,
                    style: const TextStyle(color: Colors.black, fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
