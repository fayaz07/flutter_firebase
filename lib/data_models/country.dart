class Country {
  String name, code, dialCode, flag, searchTag;

  Country(
      {required this.name,
      required this.code,
      required this.dialCode,
      required this.flag,
      required this.searchTag});

  factory Country.fromJson(Map<String, dynamic> json) => Country(
      name: json["name"],
      code: json["code"],
      dialCode: json["dial_code"],
      flag: json["flag"],
      searchTag: json["name"].toLowerCase());

  @override
  String toString() {
    return 'Country{name: $name, code: $code, dialCode: $dialCode}';
  }
}
