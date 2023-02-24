import 'package:flutter/material.dart';
import 'package:flutter_firebase/data_models/country.dart';
import 'package:flutter_firebase/utils/spacing.dart';

class SelectableWidget extends StatelessWidget {
  final Function(Country) selectThisCountry;
  final Country country;

  const SelectableWidget({
    required Key key,
    required this.selectThisCountry,
    required this.country,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => selectThisCountry(country), //selectThisCountry(country),
        child: Padding(
          padding: const EdgeInsets.all(spacing40),
          child: Text(
            "${country.flag}  ${country.name} (${country.dialCode})",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
    );
  }
}
