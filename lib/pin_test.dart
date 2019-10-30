import 'package:flutter/material.dart';

class PinTest extends StatefulWidget {
  @override
  _PinTestState createState() => _PinTestState();
}

class _PinTestState extends State<PinTest> {
  @override
  Widget build(BuildContext context) {
    return _getFields();
  }

  Widget _getFields() => Row(
    mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            maxLength: 5,
            enabled: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          )
        ],
      );
}
