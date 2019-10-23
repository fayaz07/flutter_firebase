import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/data_models/countries.dart';
import 'package:flutter_firebase/utils/constants.dart';

// ignore: must_be_immutable
class PhoneAuth extends StatefulWidget {
  Color cardBackgroundColor = Color(0xFF6874C2);
  String logo = Assets.firebase;

  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  double _height, _width, _logoPadding;

  List<Country> countries = [], showThisCountries = [];
  StreamController<List<Country>> controller;
  Stream<List<Country>> countriesStream;
  Sink<List<Country>> countriesSink;

  @override
  void initState() {
    controller = StreamController();
    countriesStream = controller.stream;
    countriesSink = controller.sink;

    loadCountriesJson();
    super.initState();
  }

  @override
  void dispose() {
    countriesSink.close();
    controller.close();
    super.dispose();
  }

  Future<List<Country>> loadCountriesJson() async {
    countries.clear();
    var value = await DefaultAssetBundle.of(context)
        .loadString("data/country_phone_codes.json");
    var countriesJson = json.decode(value);
    for (var country in countriesJson) {
      countries.add(Country.fromJson(country));
    }
    countriesSink.add(countries);
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
          child: SingleChildScrollView(
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
            child: Container(
              child: InkWell(
                onTap: () {
                  selectCountries();
                },
                child: Text('Show it'),
              ),
            ),
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

  TextEditingController searchCountryController = TextEditingController();

  void selectCountries() {
    showDialog(
        context: context,
        builder: (BuildContext context) => selectCountryWidget());
    searchCountryController.addListener(searchCountries);
  }

  searchCountries() {
    String query = searchCountryController.text;
    if (query.length == 0 || query.length == 1) {
      countriesSink.add(countries);
    } else if (query.length >= 2 && query.length <= 5) {
      List<Country> searchResults = [];
      searchResults.clear();
      countries.forEach((Country c) {
        if (c.toString().contains(query)) searchResults.add(c);
      });
      countriesSink.add(searchResults);
    } else {
      //No results
      List<Country> searchResults = [];
      countriesSink.add(searchResults);
    }
  }

  Widget selectCountryWidget() => Dialog(
        elevation: 8.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Container(
          margin: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 8.0, bottom: 2.0, right: 8.0),
                child: Card(
                  child: TextFormField(
                    controller: searchCountryController,
                    decoration: InputDecoration(
                        hintText: 'Search your country',
                        contentPadding: const EdgeInsets.only(
                            left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
                        border: InputBorder.none),
                  ),
                ),
              ),
              SizedBox(
                height: 300.0,
                child: StreamBuilder<List<Country>>(
                    stream: countriesStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) if (snapshot.data.length == 0)
                        return Center(
                          child: Text('Your search found no results'),
                        );
                      else
                        return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int i) =>
                              selectableWidget(snapshot.data[i]),
                        );
                      else if (snapshot.hasError)
                        return Center(
                          child: Text('Seems, there is an error'),
                        );
                      return Center(child: CircularProgressIndicator());
                    }),
              )
            ],
          ),
        ),
      );

  Widget selectableWidget(Country country) => Material(
        color: Colors.white,
        type: MaterialType.canvas,
        child: InkWell(
          onTap: () {
            // TODO: Select this country
          },
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
            child: Text(
              "  " +
                  country.flag +
                  "  " +
                  country.name +
                  " (" +
                  country.dialCode +
                  ")",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      );
}
