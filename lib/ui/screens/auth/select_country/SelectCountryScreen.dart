import 'package:flutter/material.dart';
import 'package:flutter_firebase/data_models/country.dart';
import 'package:flutter_firebase/providers/countries.dart';
import 'package:flutter_firebase/ui/widgets/SearchCountryTextField.dart';
import 'package:flutter_firebase/ui/widgets/SelectableWidget.dart';
import 'package:flutter_firebase/utils/assets.dart';
import 'package:flutter_firebase/utils/spacing.dart';
import 'package:provider/provider.dart';

class SelectCountryScreen extends StatelessWidget {
  const SelectCountryScreen({super.key});

  PreferredSizeWidget appbar(CountryProvider countriesProvider) {
    return AppBar(
      title: const Text('Search your country'),
      bottom: PreferredSize(
        preferredSize: const Size(double.infinity, spacing100),
        child: SearchCountryTextField(
            key: const Key("select-country-app-bar"),
            controller: countriesProvider.searchController,
            isSearching: countriesProvider.searching),
      ),
    );
  }

  Widget buildCountriesList(
      List<Country> searchResults, Function(Country c) onCountrySelected) {
    return Scrollbar(
      radius: const Radius.circular(spacing20),
      thumbVisibility: true,
      thickness: spacing20,
      child: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (BuildContext context, int i) {
          return SelectableWidget(
            key: ValueKey("country-$i"),
            country: searchResults[i],
            selectThisCountry: (Country c) {
              onCountrySelected(c);
              // Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }

  Widget buildEmptyListWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: spacing100),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(Assets.cat),
          const Text(
            "No results found",
            style: TextStyle(fontSize: 20.0),
          )
        ],
      ),
    );
  }

  Widget buildBody(CountryProvider countriesProvider) {
    if (countriesProvider.searchResults.isEmpty) {
      return buildEmptyListWidget();
    }
    return buildCountriesList(
        countriesProvider.searchResults, countriesProvider.onCountrySelected);
  }

  @override
  Widget build(BuildContext context) {
    final countriesProvider = Provider.of<CountryProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(countriesProvider),
      body: buildBody(countriesProvider),
    );
  }
}
