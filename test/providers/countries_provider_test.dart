import 'package:flutter/widgets.dart';
import 'package:flutter_firebase/providers/countries_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group("CountriesProvider Tests", () {
    final provider = CountriesProvider();

    test("load countries from asset", () async {
      await provider.loadCountriesFromJSON();
      expect(provider.countries.length, greaterThan(200));
    });

    test("search country - India", () async {
      await provider.loadCountriesFromJSON();
      provider.searchController.text = "India";
      expect(provider.searchResults.length, 2);
    });

    test("search country - Turkey", () async {
      await provider.loadCountriesFromJSON();
      provider.searchController.text = "Turkey";
      expect(provider.searchResults.length, 1);
    });

    test("select country and test if selected", () async {
      await provider.loadCountriesFromJSON();
      provider.searchController.text = "Turkey";
      provider.selectCountry(provider.searchResults[0]);
      expect(provider.selectedCountry, provider.searchResults[0]);
    });

    test("when search text is empty, user should see all countries", () async {
      await provider.loadCountriesFromJSON();
      provider.searchController.text = "Turkey";
      provider.selectCountry(provider.searchResults[0]);

      provider.searchController.text = "";
      expect(provider.searchResults, provider.countries);
    });
  });
}
