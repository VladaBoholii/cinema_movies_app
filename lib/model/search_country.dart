class SCountry {
  final String name;
  final String iso;
  final String language;

  SCountry({required this.name, required this.iso, required this.language});

  factory SCountry.fromJson(Map<String, dynamic> json) {
    return SCountry(
      name: json['name'],
      iso: json['iso3166'],
      language: json['language'],
    );
  }
}
