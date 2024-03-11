import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = '1a405d0a1b8aa13ac96612cf6f943a4a';

class ReleaseDateApi {
  Future<String?> getReleaseDate(String movieId) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/release_dates?api_key=$apiKey'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> results = responseData['results'];
        final uaRelease = results.firstWhere(
          (release) => release['iso_3166_1'] == 'UA',
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
          print('No release date found for Ukraine (ISO: UA)');
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
