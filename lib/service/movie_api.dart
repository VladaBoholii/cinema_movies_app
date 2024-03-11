import 'dart:convert';
import 'package:cinema_movies_app/model/actor.dart';
import 'package:cinema_movies_app/service/release_date_api.dart';
import 'package:http/http.dart' as http;
import 'package:cinema_movies_app/model/movie.dart';

const apiKey = '1a405d0a1b8aa13ac96612cf6f943a4a';
final ReleaseDateApi releaseDateApi = ReleaseDateApi();

class MovieApi {
  final String type;
  final String region;
  final String language;
  final http.Client client;
  MovieApi({required this.region, required this.type, required this.language})
      : client = http.Client();

  Future<List<Movie>> getMovieListByIds(List<String> movieIDs) async {
    final List<String> movieIds = movieIDs;
    final List<Future<Movie>> movieFutures = [];
    for (String movieId in movieIds) {
      movieFutures.add(getMovie(movieId));
    }

    final List<Movie> movies = await Future.wait(movieFutures);
    return movies;
  }

  Future<List<int>> getIds() async {
    final List<int> movieIds = [];
    for (int i = 1; i < 4; i++) {
      final url =
          'https://api.themoviedb.org/3/movie/$type?api_key=$apiKey&language=$language&region=$region&page=$i';
      final uri = Uri.parse(url);

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final body = response.body;
        final Map<String, dynamic> json = jsonDecode(body);
        final List<dynamic> results = json['results'];

        movieIds.addAll(
            results.map<int>((json) => Movie.fromJson(json).id).toList());
      } else {
        throw Exception(
            'Failed to load movie IDs. Status code: ${response.statusCode}');
      }
    }

    return movieIds;
  }

  Future<List<Movie>> getMovies() async {
    final List<Future<Movie>> movieFutures = [];
    final List<int> movieIds = await getIds();

    for (var movieId in movieIds) {
      movieFutures.add(getMovie('$movieId'));
    }

    final List<Movie> movies = await Future.wait(movieFutures);

    movies.removeWhere(
        (item) => item.posterPath == 'https://image.tmdb.org/t/p/originalnull');

    for (int i = 0; i < movies.length; i++) {
      final String trailerKey = await getTrailerKey('${movies[i].id}');
      movies[i].setTrailerKey(trailerKey);
    }

    return movies;
  }

  Future<Movie> getMovie(String movieId) async {
    final url =
        'https://api.themoviedb.org/3/movie/$movieId?append_to_response=credits&api_key=$apiKey&language=$language&page=1&region=$region';
    final uri = Uri.parse(url);
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final movie = Movie.fromJson(jsonData);

      List<dynamic> castList = jsonData['credits']['cast'];
      List<Actor> actors =
          castList.map((json) => Actor.fromJson(json)).toList();

      final String trailerKey = await getTrailerKey(movieId);
      movie.setCast(actors);
      movie.setTrailerKey(trailerKey);
      return movie;
    } else {
      throw Exception('Failed to load movie data');
    }
  }

  Future<String> getTrailerKey(String movieId) async {
    final url =
        'https://api.themoviedb.org/3/movie/${movieId}/videos?api_key=$apiKey&language=$language&page=1&region=$region';
    final uri = Uri.parse(url);

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data.containsKey('results') && data['results'] is List) {
        List<dynamic> results = data['results'];

        for (var result in results) {
          if (result['type'] == 'Teaser' || result['type'] == 'Trailer') {
            String trailerKey = result['key'];
            return trailerKey;
          }
        }
      }
    }
    return '';
  }

  Future<String?> getReleaseDate(String movieId) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/release_dates?api_key=$apiKey'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> results = responseData['results'];
        final uaRelease = results.firstWhere(
          (release) => release['iso_3166_1'] == '$region',
          orElse: () => null,
        );

        if (uaRelease != null) {
          final dynamic releaseDates = uaRelease['release_dates'];
          if (releaseDates is List) {
            final String releaseDate = releaseDates.isNotEmpty
                ? (releaseDates.first['release_date'] ??
                    "No release date available")
                : "No release date available";
            return releaseDate;
          } else if (releaseDates is Map<String, dynamic>) {
            final String releaseDate =
                releaseDates['release_date'] ?? "No release date available";
            return releaseDate;
          } else {
            print('Unexpected format for release_dates');
            return null;
          }
        } else {
          print('No release date found for Ukraine (ISO: $region)');
          return null;
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }
}
