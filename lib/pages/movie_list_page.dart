import 'package:cinema_movies_app/components/movies_slider.dart';
import 'package:cinema_movies_app/model/movie.dart';
import 'package:cinema_movies_app/model/search_country.dart';
import 'package:cinema_movies_app/service/movie_api.dart';
import 'package:flutter/material.dart';

class MovieListPage extends StatefulWidget {
  final SCountry country;
  final String type;

  const MovieListPage({super.key, required this.country, required this.type});

  @override
  State<MovieListPage> createState() => MovieListPageState();
}

class MovieListPageState extends State<MovieListPage> {
  List<Movie> nowPlayingMovies = [];
  late SCountry country;
  late MovieApi nowPlayingApi;

  @override
  void initState() {
    super.initState();
    country = widget.country;
    nowPlayingApi = MovieApi(
      type: widget.type,
      region: widget.country.iso,
      language: widget.country.language,
    );
    _fetchMovieList();
  }

  //get movies list
  void _fetchMovieList() async {
    final nowPlayingMoviesList = await nowPlayingApi.getMovies();
    setState(() {
      nowPlayingMovies = nowPlayingMoviesList;
    });
  }

  @override
  void didUpdateWidget(covariant MovieListPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.country != oldWidget.country) {
      country = widget.country;
      nowPlayingApi = MovieApi(
        type: widget.type,
        region: widget.country.iso,
        language: widget.country.language,
      );
      _fetchMovieList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: nowPlayingApi.getMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Movie> nowPlayingMovies = snapshot.data ?? [];

            //EMPTY list
            if (nowPlayingMovies.isEmpty) {
              return Center(
                child: Text(
                  'No movies for ${country.name}',
                  style: TextStyle(
                    color: Colors.purple[300],
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }

            //list NOT EMPTY
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: MoviesSlider(moviesList: nowPlayingMovies),
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
      ),
    );
  }
}
