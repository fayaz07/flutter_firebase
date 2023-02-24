import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/spacing.dart';

class SearchCountryTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isSearching;

  const SearchCountryTextField(
      {required Key key, required this.controller, required this.isSearching})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(spacing20),
      child: buildSearchTextField(),
    );
  }

  TextFormField buildSearchTextField() {
    return TextFormField(
      autofocus: false,
      controller: controller,
      decoration: InputDecoration(
        label: const Text("Search your country"),
        hintText: "Ex: India",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: buildLoadingIndicator(),
        contentPadding: const EdgeInsets.symmetric(
          vertical: spacing30,
          horizontal: spacing40,
        ),
        border: InputBorder.none,
      ),
    );
  }

  Widget buildLoadingIndicator() {
    if (isSearching) {
      return const SizedBox(
        width: spacing60,
        child: Center(
          child: SizedBox(
            height: spacing60,
            width: spacing60,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    return const SizedBox();
  }
}
