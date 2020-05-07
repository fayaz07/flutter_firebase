import 'dart:convert' show json;

import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart' show TextEditingController, debugPrint;
import 'package:flutter_firebase/data_models/country.dart';

class CountryProvider with ChangeNotifier {
  /// loading countries data from json
  /// setting up listeners
  ///
  CountryProvider() {
    loadCountriesFromJSON();
    searchController.addListener(_search);
  }

  List<Country> _countries = [];

  List<Country> get countries => _countries;

//  set countries(List<Country> value) {
//    _countries = value;
//    notifyListeners();
//  }

  List<Country> _searchResults = [];

  List<Country> get searchResults => _searchResults;

  set searchResults(List<Country> value) {
    _searchResults = value;
    print('SearchResults ${searchResults.length}');
    notifyListeners();
  }

  Country _selectedCountry = Country();

  Country get selectedCountry => _selectedCountry;

  set selectedCountry(Country value) {
    _selectedCountry = value;
    notifyListeners();
  }

  final TextEditingController _searchController = TextEditingController();

  TextEditingController get searchController => _searchController;

  Future loadCountriesFromJSON() async {
    try {
      if (countries.length <= 0) {
        var _file =
            await rootBundle.loadString('data/country_phone_codes.json');
        var _countriesJson = json.decode(_file);
        List<Country> _listOfCountries = [];
        for (var country in _countriesJson) {
          _listOfCountries.add(Country.fromJson(country));
        }
        _countries = _listOfCountries;
        notifyListeners();
        // Selecting India
        selectedCountry = _listOfCountries[100];
        searchResults = _listOfCountries;
      }
    } catch (err) {
      debugPrint("Unable to load countries data");
      throw err;
    }
  }

  ///  This will be the listener for searching the query entered by user for their country, (dialog pop-up),
  ///  searches for the query and returns list of countries matching the query by adding the results to the sink of [searchResults]
  void _search() {
    String query = searchController.text;
    print(query);
    if (query.length == 0 || query.length == 1) {
      searchResults = countries;
    } else {
      List<Country> _results = [];
      countries.forEach((Country c) {
        if (c.toString().toLowerCase().contains(query.toLowerCase()))
          _results.add(c);
      });
      searchResults = _results;
      print("results length: ${searchResults.length}");
//      print('added few countries based on search ${searchResults.length}');
    }
  }

  void resetSearch() {
    searchResults = countries;
  }
}
