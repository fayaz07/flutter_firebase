import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data_models/country.dart';
import 'constants.dart';

class Logo extends StatelessWidget {
  final double height;

  const Logo({Key key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Material(
          type: MaterialType.transparency,
          elevation: 10.0,
          child: Image.asset(
            Assets.firebase,
            height: height ?? MediaQuery.of(context).size.height * .2,
          ),
        ),
      ),
    );
  }
}

class AppTextFormField extends StatelessWidget {
  final Color color;
  final String hint;
  final String label;
  final int validateLength;
  final Function(String) save;
  final bool isObscure;
  final int maxLength;
  final TextEditingController controller;
  final int maxLines;
  final String initialValue;
  final bool enabled;

  const AppTextFormField(
      {Key key,
      this.hint,
      this.label,
      this.validateLength,
      this.save,
      this.isObscure,
      this.maxLength,
      this.controller,
      this.maxLines = 1,
      this.initialValue,
      this.enabled = true,
      this.color})
      : assert(label != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    //  type of keyboard
    var keyboard;
    if (label.toLowerCase().contains("phone"))
      keyboard = TextInputType.phone;
    else if (label.toLowerCase().contains("email"))
      keyboard = TextInputType.emailAddress;
    else if (label.toLowerCase().contains("age") &&
        !label.toLowerCase().contains("language"))
      keyboard = TextInputType.number;
    else
      keyboard = TextInputType.text;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (validateLength == 0) return null;
          if (value == null) return "Invalid input";

          if (value.length < validateLength)
            return "${label ?? "Input"} must be valid";
//            return "${label ?? "Input"} must be atleast $validateLength characters long";
          return null;
        },
        toolbarOptions:
            ToolbarOptions(copy: true, cut: true, paste: true, selectAll: true),
        obscureText: isObscure ?? false,
        onSaved: save,
        maxLines: maxLines,
        enabled: enabled,
        maxLength: maxLength,
        keyboardType: keyboard,
        initialValue: initialValue,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: color ?? Theme.of(context).primaryColor, width: 2.0)),
          enabledBorder: OutlineInputBorder(
              borderSide: color != null
                  ? BorderSide(color: color, width: 2.0)
                  : BorderSide(width: 1.00)),
//          disabledBorder:
//              OutlineInputBorder(borderSide: BorderSide(width: 1.0)),
          border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: color ?? Theme.of(context).primaryColor)),
          contentPadding: maxLines > 1
              ? const EdgeInsets.only(
                  top: 12.0, bottom: 12.0, right: 16.0, left: 16.0)
              : const EdgeInsets.only(
                  top: 2.0, bottom: 2.0, right: 16.0, left: 16.0),
          hintText: hint ?? ' ',
          labelText: label ?? ' ',
          labelStyle: TextStyle(color: color ?? Theme.of(context).primaryColor),
          hintStyle: TextStyle(color: color ?? Theme.of(context).primaryColor),
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}

class SearchCountryTF extends StatelessWidget {
  final TextEditingController controller;

  const SearchCountryTF({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 2.0, right: 8.0),
      child: Card(
        child: TextFormField(
          autofocus: false,
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Search your country',
            contentPadding: const EdgeInsets.only(
                left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String prefix;

  const PhoneNumberField({Key key, this.controller, this.prefix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Text("  " + prefix + "  ", style: TextStyle(fontSize: 16.0)),
          SizedBox(width: 8.0),
          Expanded(
            child: TextFormField(
              controller: controller,
              autofocus: false,
              keyboardType: TextInputType.phone,
              key: Key('EnterPhone-TextFormField'),
              decoration: InputDecoration(
                border: InputBorder.none,
                errorMaxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SubTitle extends StatelessWidget {
  final String text;

  const SubTitle({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(' $text',
            style: TextStyle(color: Colors.white, fontSize: 14.0)));
  }
}

class ShowSelectedCountry extends StatelessWidget {
  final VoidCallback onPressed;
  final Country country;

  const ShowSelectedCountry({Key key, this.onPressed, this.country})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 4.0, right: 4.0, top: 8.0, bottom: 8.0),
          child: Row(
            children: <Widget>[
              Expanded(child: Text(' ${country.flag}  ${country.name} ')),
              Icon(Icons.arrow_drop_down, size: 24.0)
            ],
          ),
        ),
      ),
    );
  }
}

class SelectableWidget extends StatelessWidget {
  final Function(Country) selectThisCountry;
  final Country country;

  const SelectableWidget({Key key, this.selectThisCountry, this.country})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      type: MaterialType.canvas,
      child: InkWell(
        onTap: () => selectThisCountry(country), //selectThisCountry(country),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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
                fontSize: 18.0,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String asset;
  final VoidCallback onPressed;

  const SocialButton({Key key, this.asset, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8.0),
      onTap: onPressed,
      child: Material(
        elevation: 8.0,
        color: Colors.transparent,
        type: MaterialType.circle,
        child: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage(asset),
        ),
      ),
    );
  }
}

class RoundBorderedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;

  const RoundBorderedButton(
      {Key key, this.text, this.onPressed, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
      onPressed: onPressed,
      color: backgroundColor ?? Theme
          .of(context)
          .primaryColor,
      borderRadius: BorderRadius.circular(32.0),
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Text('$text', style: TextStyle(color: Colors.white)),
      ),
    )
        : RaisedButton(
      onPressed: onPressed,
      color: backgroundColor ?? Theme
          .of(context)
          .primaryColor,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0)),
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Text('$text', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
