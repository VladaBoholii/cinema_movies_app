import 'package:cinema_movies_app/components/movie_tile.dart';
import 'package:cinema_movies_app/model/movie.dart';
import 'package:cinema_movies_app/model/search_country.dart';
import 'package:cinema_movies_app/service/movie_api.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoritePage extends StatefulWidget {
  final SCountry country;

  const FavoritePage({super.key, required this.country});

  @override
  FavoritePageState createState() => FavoritePageState();
}

class FavoritePageState extends State<FavoritePage> {
  late SCountry country;
  final favoriteBox = Hive.box('favoriteMovies');

  @override
  void initState() {
    super.initState();
    country = widget.country;
  }

  @override
  void didUpdateWidget(covariant FavoritePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.country != oldWidget.country) {
      country = widget.country;
      _updateMovies();
    }
  }

  Future<void> _updateMovies() async {
    setState(() {});
  }

  Future<List<Movie>> _fetchMovies(List<String> movieIds) async {
    final MovieApi movieApi =
        MovieApi(type: '', region: '', language: country.language);
    return await movieApi.getMovieListByIds(movieIds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: favoriteBox.listenable(),
        builder: (context, Box<dynamic> box, _) {
          List<String> favoriteList = [];
          for (var element in box.values) {
            favoriteList.add('$element');
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List<Movie>>(
              future: _fetchMovies(favoriteList),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List<Movie> favoriteMoviesList = snapshot.data ?? [];

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 2 / 3,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: favoriteMoviesList.length,
                    itemBuilder: (context, index) {
                      final movie = favoriteMoviesList[index];
                      return MovieTile(movie: movie);
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.purple[300],
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
      backgroundColor: Colors.purple.shade100,
    );
  }
}
