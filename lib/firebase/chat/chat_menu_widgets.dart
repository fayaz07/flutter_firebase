import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Color _incomingMessageBackgroundColor = Colors.blueAccent,
    _outgoingMessageBackgroundColor = Colors.greenAccent,
    _textColor = Colors.white;

String _incomingMessage, _outgoingMessage;

EdgeInsetsGeometry _messagePadding =
    const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 8.0, top: 8.0);

double _elevation = 2.0, _radius = 15.0;

class IncomingMessage extends StatefulWidget {
  IncomingMessage(String incoming) {
    _incomingMessage = incoming;
  }

  @override
  _IncomingMessageState createState() => _IncomingMessageState();
}

class _IncomingMessageState extends State<IncomingMessage> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Card(
        elevation: _elevation,
        margin: const EdgeInsets.only(
            left: 15.0, right: 50.0, top: 3.0, bottom: 3.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(_radius))),
        color: _incomingMessageBackgroundColor,
        child: Padding(
            padding: _messagePadding,
            child: SelectableText(
              _incomingMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: _textColor),
            )),
      ),
    );
  }
}

class OutgoingMessage extends StatefulWidget {
  OutgoingMessage(String outgoing) {
    _outgoingMessage = outgoing;
  }

  @override
  _OutgoingMessageState createState() => _OutgoingMessageState();
}

class _OutgoingMessageState extends State<OutgoingMessage> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Card(
        elevation: _elevation,
        margin: const EdgeInsets.only(
            left: 50.0, right: 15.0, top: 3.0, bottom: 3.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(_radius))),
        color: _outgoingMessageBackgroundColor,
        child: Padding(
            padding: _messagePadding,
            child: SelectableText(
              _outgoingMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: _textColor),
            )),
      ),
    );
  }
}

class MessageModel {
  String message, createdAt, author, mid;

  MessageModel({this.message, this.createdAt, this.author, this.mid});
}
