import 'package:cinema_movies_app/model/movie.dart';
import 'package:cinema_movies_app/pages/movie_page.dart';
import 'package:flutter/material.dart';

class MovieTile extends StatefulWidget {
  final Movie movie;

  const MovieTile({super.key, required this.movie});

  @override
  State<MovieTile> createState() => _MovieTileState();
}

class _MovieTileState extends State<MovieTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoviePage(movie: widget.movie),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: 1.0 / 1.5,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(widget.movie.posterPath),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
