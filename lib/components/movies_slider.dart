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
      slideBuilder: (index) {
        final movie = widget.moviesList[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Center(child: MovieTile(movie: movie)),
        );
      },
    );
  }
}
