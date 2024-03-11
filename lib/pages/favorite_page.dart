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
      setState(() {});
    }
  }

  //get movie list
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

          return FutureBuilder<List<Movie>>(
            future: _fetchMovies(favoriteList),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<Movie> favoriteMoviesList = snapshot.data ?? [];

                            //EMPTY list
            if (favoriteMoviesList.isEmpty) {
              return Center(
                child: Text(
                  'No Favorite Movies',
                  style: TextStyle(
                    color: Colors.purple[300],
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }
          
                //movies grid
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8,8,8,0),
                  child: GridView.builder(
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
                  ),
                );
              } 
              
              //loading data
              else {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.purple[300],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
