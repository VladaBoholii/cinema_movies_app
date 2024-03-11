import 'dart:convert';
import 'package:cinema_movies_app/model/search_country.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const apiKey = '1a405d0a1b8aa13ac96612cf6f943a4a';
final http.Client client = http.Client();

class SCountryService {
  Future<List<SCountry>> getCountries() async {
    final String response =
        await rootBundle.loadString('assets/countries.json');

    Map<String, dynamic> jsonMap = json.decode(response);

    List<dynamic> countriesJson = jsonMap['countries'];

    List<SCountry> countries =
        countriesJson.map((json) => SCountry.fromJson(json)).toList();

    return countries;
  }
}
