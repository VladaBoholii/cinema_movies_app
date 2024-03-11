import 'package:flutter/material.dart';

class OverView extends StatelessWidget {
  final String text;
  const OverView({super.key, required this.text});

  @override
  Widget build(BuildContext context) {

        final TextStyle main = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.purple[600],
    );

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Text(
            text,
            textAlign: TextAlign.justify,
            style: main,
          ),
        ));
  }
}
