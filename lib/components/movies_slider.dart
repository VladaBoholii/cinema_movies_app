import 'package:cinema_movies_app/components/movie_tile.dart';
import 'package:cinema_movies_app/model/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';

class MoviesSlider extends StatefulWidget {
  final List<Movie> moviesList;
  const MoviesSlider({super.key, required this.moviesList});

  @override
  State<MoviesSlider> createState() => _MoviesSliderState();
}

class _MoviesSliderState extends State<MoviesSlider> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      unlimitedMode: true,
      scrollDirection: Axis.horizontal,
      itemCount: widget.moviesList.length,
      viewportFraction: 0.9,
      slideBuilder: (index) {
        final movie = widget.moviesList[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  children: [
                    MovieTile(movie: movie),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(movie.title,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.purple[600],
                              fontStyle: FontStyle.italic)),
                    )
                  ],
                ),
              )),
        );
      },
    );
  }
}
