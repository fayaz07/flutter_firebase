class Country {
  String name, code, dialCode, flag;

  Country({this.name, this.code, this.dialCode, this.flag});

  factory Country.fromJson(Map<String, dynamic> json) => Country(
      name: json["name"],
      code: json["code"],
      dialCode: json["dial_code"],
      flag: json["flag"]);

  @override
  String toString() {
    return 'Country{name: $name, code: $code, dialCode: $dialCode}';
  }
}
