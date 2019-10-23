import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_firebase/data_models/countries.dart';
import 'package:flutter_firebase/utils/constants.dart';

/*
 *  PhoneAuthUI - this file contains whole ui and controllers of ui
 *  Background code will be in other class
 *  This code can be easily re-usable with any other service type, as UI part and background handling are completely from different sources
 *  TODO: Add other class to control background processes in phone auth verification using Firebase
 */

// ignore: must_be_immutable
class PhoneAuth extends StatefulWidget {
  /*
   *  cardBackgroundColor & logo values will be passed to the constructor
   *  here we access these params in the _PhoneAuthState using "widget"
   */
  Color cardBackgroundColor = Color(0xFF6874C2);
  String logo = Assets.firebase;

  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  /*
   *  _height & _width:
   *    will be calculated from the MediaQuery of widget's context
   *  countries:
   *    will be a list of Country model, Country model contains name, dialCode, flag and code for various countries
   *    and below params are all related to StreamBuilder
   */
  double _height, _width, _logoPadding;

  List<Country> countries = [];
  StreamController<List<Country>> _countriesStreamController;
  Stream<List<Country>> _countriesStream;
  Sink<List<Country>> _countriesSink;

  /*
   *  _searchCountryController - This will be used as a controller for listening to the changes what the user is entering
   *  and it's listener will take care of the rest
   */
  TextEditingController _searchCountryController = TextEditingController();

  /*
   *  This will be the index, we will modify each time the user selects a new country from the dropdown list(dialog),
   *  As a default case, we are using India as default country, index = 31
   */
  int _selectedCountryIndex = 31;

  @override
  void initState() {
    // Initialising components required for StreamBuilder
    // We will not be using _countriesStreamController anywhere, but just to initalize Stream & Sink from that
    // _countriesStream will give us the data what we need(output) - that will be used in StreamBuilder widget
    // _countriesSink is the place where we send the data(input)
    _countriesStreamController = StreamController();
    _countriesStream = _countriesStreamController.stream;
    _countriesSink = _countriesStreamController.sink;

    super.initState();
  }

  @override
  void dispose() {
    // While disposing the widget, we should close all the streams and controllers

    // Disposing Stream components
    _countriesSink.close();
    _countriesStreamController.close();

    // Disposing _countriesSearchController
    _searchCountryController.dispose();
    super.dispose();
  }

  Future<List<Country>> loadCountriesJson() async {
    //  Cleaning up the countries list before we put our data in it
    countries.clear();

    //  Fetching the json file, decoding it and storing each object as Country in countries(list)
    var value = await DefaultAssetBundle.of(context)
        .loadString("data/country_phone_codes.json");
    var countriesJson = json.decode(value);
    for (var country in countriesJson) {
      countries.add(Country.fromJson(country));
    }

    //Finally adding the initial data to the _countriesSink
    _countriesSink.add(countries);
    return countries;
  }

  @override
  Widget build(BuildContext context) {
    //  Fetching height & width parameters from the MediaQuery
    //  _logoPadding will be a constant, scaling it according to device's size
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _logoPadding = _height * 0.025;

    //  Scaffold: Using a Scaffold widget as parent
    //  SafeArea: As a precaution - wrapping all child descendants in SafeArea, so that even notched phones won't loose data
    //  Center: As we are just having Card widget - making it to stay in Center would really look good
    //  SingleChildScrollView: There can be chances arising where
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: _getBody(),
          ),
        ),
      ),
    );
  }

  /*
   *  Widget hierarchy ->
   *    Scaffold -> SafeArea -> Center -> SingleChildScrollView -> Card()
   *    Card -> FutureBuilder -> Column()
   *
   */
  Widget _getBody() => Card(
        color: widget.cardBackgroundColor,
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: SizedBox(
          height: _height * 8 / 10,
          width: _width * 8 / 10,

          // Fetching countries data from JSON file and storing them in a List of Country model:
          // ref:- List<Country> countries
          // Until the data is fetched, there will be CircularProgressIndicator showing, describing something is on it's way
          child: FutureBuilder<List<Country>>(
              future: loadCountriesJson(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Country>> snapshot) {
                return snapshot.hasData
                    ? _getColumnBody()
                    : Center(child: CircularProgressIndicator());
              }),
        ),
      );

  Widget _getColumnBody() => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(_logoPadding),
            child: _getLogo(),
          ),

          //  Select your country, this will be a custom DropDown menu, rather than just as a dropDown
          //  onTap of this, will show a Dialog asking the user to select country they reside,
          //  according to their selection, prefix will change in the PhoneNumber TextFormField
          Padding(
            padding: EdgeInsets.only(left: _logoPadding, right: _logoPadding),
            child: _dropDownWidgetSelectCountry(),
          ),

          //  PhoneNumber TextFormFielda
          Padding(
            padding: EdgeInsets.all(_logoPadding),
            child: Card(
              child: TextFormField(
                key: Key('EnterPhone-TextFormField'),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  errorMaxLines: 1,
                ),
              ),
            ),
          ),
        ],
      );

  /*
   *  This will trigger a dialog, that will let the user to select their country, so the dialcode
   *  of their country will be automatically added at the end
   *
   */
  void selectCountries() {
    showDialog(
        context: context,
        builder: (BuildContext context) => selectCountryWidget());
    _searchCountryController.addListener(searchCountries);
  }

  searchCountries() {
    String query = _searchCountryController.text;
    if (query.length == 0 || query.length == 1) {
      _countriesSink.add(countries);
    } else if (query.length >= 2 && query.length <= 5) {
      List<Country> searchResults = [];
      searchResults.clear();
      countries.forEach((Country c) {
        if (c.toString().contains(query)) searchResults.add(c);
      });
      _countriesSink.add(searchResults);
    } else {
      //No results
      List<Country> searchResults = [];
      _countriesSink.add(searchResults);
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
                    controller: _searchCountryController,
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
                    key: Key('Countries-StreamBuilder'),
                    stream: _countriesStream,
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

  //  Logo: scaling to occupy 2 parts of 10 in the whole height of deive
  Widget _getLogo() => Material(
        type: MaterialType.transparency,
        elevation: 50.0,
        child: Image.asset(widget.logo, height: _height * 2 / 10),
      );

  Widget _dropDownWidgetSelectCountry() => Card(
        child: InkWell(
          onTap: () {
            selectCountries();
          },
          child: Padding(
            padding: const EdgeInsets.only(
                left: 4.0, right: 4.0, top: 8.0, bottom: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                        ' ${countries[_selectedCountryIndex].flag}  ${countries[_selectedCountryIndex].name} ')),
                Icon(Icons.arrow_drop_down, size: 24.0)
              ],
            ),
          ),
        ),
      );
}
