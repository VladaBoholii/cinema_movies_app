import 'package:cinema_movies_app/model/movie.dart';
import 'package:cinema_movies_app/pages/movie_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MovieTile extends StatefulWidget {
  final Movie movie;

  const MovieTile({Key? key, required this.movie}) : super(key: key);

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
            Positioned(
              bottom: 0,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 130),
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.only(topRight: Radius.circular(8)),
                  color: Colors.purple.shade100,
                ),
                padding: const EdgeInsets.all(8),
                child: Text(
                  widget.movie.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.purple[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
