import 'dart:convert' show json;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_firebase/data_models/country.dart';
import 'package:flutter_firebase/utils/assets.dart';

class CountriesProvider with ChangeNotifier {
  CountriesProvider() {
    searchController.addListener(_search);
  }

  bool _searching = false;

  bool get searching => _searching;

  final List<Country> _countries = [];

  List<Country> get countries => _countries;

  List<Country> _searchResults = [];

  List<Country> get searchResults => _searchResults;

  set searchResults(List<Country> value) {
    _searchResults = value;
    notifyListeners();
  }

  Country? _selectedCountry;

  Country get selectedCountry => _selectedCountry != null
      ? _selectedCountry!
      : Country(
          name: "Test Country",
          code: "TC",
          dialCode: "+1000",
          flag: "",
          searchTag: "test country");

  final TextEditingController _searchController = TextEditingController();

  TextEditingController get searchController => _searchController;

  Future loadCountriesFromJSON() async {
    try {
      if (countries.isEmpty) {
        var file = await rootBundle.loadString(Assets.countriesJson);
        var countriesJson = json.decode(file);
        for (var country in countriesJson) {
          countries.add(Country.fromJson(country));
        }
        // Selecting India
        _selectedCountry = countries[100];
        searchResults
          ..clear()
          ..addAll(countries);
        notifyListeners();
      }
    } catch (err) {
      rethrow;
    }
  }

  void _setSearching(bool value) {
    _searching = value;
    notifyListeners();
  }

  void _search() {
    _setSearching(true);

    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      resetSearch();
    } else {
      List<Country> filtered = [];
      for (var c in countries) {
        if (c.searchTag.contains(query)) {
          filtered.add(c);
        }
      }
      searchResults = filtered;
    }
    _setSearching(false);
  }

  void resetSearch() {
    searchResults = countries;
  }

  void selectCountry(Country c) {
    _selectedCountry = c;
    notifyListeners();
  }
}
