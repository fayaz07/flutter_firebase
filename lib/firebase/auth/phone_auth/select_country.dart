import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/data_models/country.dart';
import 'package:flutter_firebase/providers/countries.dart';
import 'package:flutter_firebase/utils/widgets.dart';
import 'package:provider/provider.dart';

class SelectCountry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final countriesProvider = Provider.of<CountryProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Search your country'),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 50.0),
          child:
              SearchCountryTF(controller: countriesProvider.searchController),
        ),
      ),
      body: ListView.builder(
        itemCount: countriesProvider.searchResults.length,
        itemBuilder: (BuildContext context, int i) {
          return SelectableWidget(
            country: countriesProvider.searchResults[i],
            selectThisCountry: (Country c) {
              print(i);
              countriesProvider.selectedCountry = c;
              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }
}
