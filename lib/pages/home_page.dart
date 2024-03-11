import 'package:cinema_movies_app/model/search_country.dart';
import 'package:cinema_movies_app/pages/movie_list_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final SCountry country;
  const HomePage({super.key, required this.country});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late SCountry country;

  void reload(SCountry selected) {
    country = widget.country;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            Material(
              color: Colors.purple[300],
              child: const TabBar(
                indicatorWeight: 5,
                tabs: [
                  Tab(
                    text: 'NOW PLAYING',
                  ),
                  Tab(
                    text: 'UPCOMING',
                  )
                ],
              ),
            ),
            Expanded(
              child: TabBarView(children: [
                MovieListPage(
                  type: 'now_playing',
                  country: widget.country,
                ),
                MovieListPage(
                  type: 'upcoming',
                  country: widget.country,
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
