import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/country.dart';
import '../model/genre.dart';

class MainInfo extends StatelessWidget {
  final TextStyle style;
  final TextStyle titleStyle;
  final DateTime release_date;
  final String originalTitle;
  final List<Country> countries;
  final List<Genre> genres;
  final int runtime;
  const MainInfo(
      {super.key,
      required this.runtime,
      required this.titleStyle,
      required this.style,
      required this.release_date,
      required this.originalTitle,
      required this.countries,
      required this.genres});

  @override
  Widget build(BuildContext context) {
    final DateFormat format = DateFormat('dd.MM.yyyy');

    return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(originalTitle,
                style: titleStyle, textAlign: TextAlign.left),
            Divider(
              color: Colors.purple[300],
            ),
            Text(
              format.format(release_date),
              style: style,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  countries.map((country) => country.name).join(',\n'),
                  style: style,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            if (runtime != 0)
              Text(
                '$runtime min.',
                style: style,
              ),
          ],
        ));
  }
}
