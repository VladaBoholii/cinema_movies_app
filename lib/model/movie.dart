import 'package:cinema_movies_app/model/actor.dart';
import 'package:cinema_movies_app/model/country.dart';
import 'package:cinema_movies_app/model/genre.dart';

class Movie {
  final bool adult;
  final String backdropPath;
  final List<Genre> genres;
  final int id;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final List<Country> productionCountries;
  final int runtime;
  final String tagline;
  final String title;
  List<Actor>? cast;
  String trailerKey;
  final String releaseDate;

  Movie(
      {required this.adult,
      required this.backdropPath,
      required this.genres,
      required this.id,
      required this.originalTitle,
      required this.overview,
      required this.posterPath,
      required this.productionCountries,
      required this.runtime,
      required this.tagline,
      required this.title,
      required this.releaseDate,
      this.trailerKey = ''});

  void setTrailerKey(String trailerKey) {
    this.trailerKey = trailerKey;
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      releaseDate: json['release_date'],
      adult: json['adult'],
      backdropPath:
          'https://image.tmdb.org/t/p/original${json['backdrop_path']}',
      genres: List<Genre>.from(
        (json['genres'] as List<dynamic>?)
                ?.map((genre) => Genre.fromJson(genre)) ??
            [],
      ),
      id: json['id'] ?? 0,
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: 'https://image.tmdb.org/t/p/original${json["poster_path"]}',
      productionCountries: List<Country>.from(
        (json['production_countries'] as List<dynamic>?)
                ?.map((country) => Country.fromJson(country)) ??
            [],
      ),
      runtime: json['runtime'] ?? 0,
      tagline: json['tagline'] ?? '',
      title: json['title'] ?? '',
    );
  }

  void setCast(List<Actor> cast) {
    this.cast = cast;
  }
}
