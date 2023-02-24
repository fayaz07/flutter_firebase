import 'package:flutter/material.dart';
import 'package:flutter_firebase/data_models/country.dart';
import 'package:flutter_firebase/providers/countries_provider.dart';
import 'package:flutter_firebase/ui/widgets/search_country_text_field.dart';
import 'package:flutter_firebase/ui/widgets/selectable_widget.dart';
import 'package:flutter_firebase/utils/assets.dart';
import 'package:flutter_firebase/utils/spacing.dart';
import 'package:provider/provider.dart';

class SelectCountryScreen extends StatelessWidget {
  const SelectCountryScreen({super.key});

  PreferredSizeWidget appbar(CountriesProvider countriesProvider) {
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

  Widget buildBody(CountriesProvider countriesProvider) {
    if (countriesProvider.searchResults.isEmpty) {
      return buildEmptyListWidget();
    }
    return buildCountriesList(
        countriesProvider.searchResults, countriesProvider.selectCountry);
  }

  @override
  Widget build(BuildContext context) {
    final countriesProvider = Provider.of<CountriesProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(countriesProvider),
      body: buildBody(countriesProvider),
    );
  }
}
