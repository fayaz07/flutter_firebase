import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/data_models/countries.dart';
import 'package:flutter_firebase/utils/constants.dart';
import 'package:flutter_firebase/utils/session_data.dart';

// ignore: must_be_immutable
class PhoneAuth extends StatefulWidget {
  Color cardBackgroundColor = Color(0xFF6874C2);
  String logo = Assets.firebase;

  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  double _height, _width, _logoPadding;

  @override
  void initState() {
    loadCountriesJson();
    super.initState();
  }

  Future<List<Country>> loadCountriesJson() async {
    List<Country> countries = [];
    var value = await DefaultAssetBundle.of(context)
        .loadString("data/country_phone_codes.json");
    var countriesJson = json.decode(value);
    for (var country in countriesJson) {
      countries.add(Country.fromJson(country));
    }
    return countries;
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _logoPadding = _height * 0.025;

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: SafeArea(
        child: Center(
          child: Card(
            color: widget.cardBackgroundColor,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            child: SizedBox(
              height: _height * 8 / 10,
              width: _width * 8 / 10,
              child: getBody(),
            ),
          ),
        ),
      ),
    );
  }

  Widget getBody() => FutureBuilder<List<Country>>(
      future: loadCountriesJson(),
      builder: (BuildContext context, AsyncSnapshot<List<Country>> snapshot) {
        return snapshot.hasData
            ? _get(snapshot.data)
            : Center(child: CircularProgressIndicator());
      });

  Widget _get(List<Country> countries) => Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(_logoPadding),
            child: SizedBox(
                height: _height * 2 / 10,
                child: Material(
                    type: MaterialType.transparency,
                    elevation: 50.0,
                    child: Image.asset(widget.logo))),
          ),
          Padding(
            padding: EdgeInsets.all(1.0),
            child: Container()
          ),
          Padding(
            padding: EdgeInsets.all(_logoPadding),
            child: Card(
              child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  errorMaxLines: 1,
                ),
              ),
            ),
          ),
        ],
      );
}
