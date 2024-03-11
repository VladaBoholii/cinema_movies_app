import 'package:cinema_movies_app/components/actor_tile.dart';
import 'package:cinema_movies_app/components/main_info.dart';
import 'package:cinema_movies_app/components/overview.dart';
import 'package:cinema_movies_app/model/actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cinema_movies_app/model/movie.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MoviePage extends StatefulWidget {
  final Movie movie;

  const MoviePage({super.key, required this.movie});

  @override
  State<MoviePage> createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  late YoutubePlayerController _playerController;
  final favoriteBox = Hive.box('favoriteMovies');
  final List<int> favoriteList = [];
  final DateFormat format = DateFormat.yMMMMd();

  final TextStyle main = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.purple[600],
  );

  final TextStyle titleStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: Colors.purple[600],
  );

  TextStyle name = TextStyle(
      color: Colors.purple[600], fontSize: 16, fontWeight: FontWeight.w700);
  TextStyle character = TextStyle(
      color: Colors.purple[400], fontSize: 14, fontWeight: FontWeight.w500);

  @override
  void initState() {
    super.initState();
    _playerController = YoutubePlayerController(
      initialVideoId: widget.movie.trailerKey,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
      ),
    );
    getFavorite();
  }

  void getFavorite() {
    favoriteList.clear();
    for (var element in favoriteBox.values) {
      favoriteList.add(element);
    }
    setState(() {});
  }

  void addToFavorite(Movie movie) async {
    int index = favoriteList.indexOf(movie.id);
    if (index != -1) {
      favoriteBox.deleteAt(index);
    } else {
      favoriteBox.put(movie.id, movie.id);
    }

    setState(() {
      getFavorite();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        //appBar

        appBar: AppBar(
          automaticallyImplyLeading: false,
          leadingWidth: 40,
          titleSpacing: 0,
          title: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 48,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Text(
                  widget.movie.title,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: IconButton(
                icon: Icon(
                  favoriteList.contains(widget.movie.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 34,
                ),
                color: Colors.white,
                onPressed: () => addToFavorite(widget.movie),
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),

                  //poster

                  child: Container(
                    width: 200,
                    child: AspectRatio(
                      aspectRatio: 2 / 3,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(widget.movie.posterPath),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                //main info

                Expanded(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: MainInfo(
                        release_date: DateTime.parse(widget.movie.releaseDate),
                        originalTitle: widget.movie.originalTitle,
                        countries: widget.movie.productionCountries,
                        genres: widget.movie.genres,
                        titleStyle: titleStyle,
                        style: main,
                        runtime: widget.movie.runtime,
                      ),
                    ),
                  ),
                )
              ],
            ),

            //title

            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: Text(
                widget.movie.title,
                style: titleStyle,
                textAlign: TextAlign.left,
              ),
            ),

            //tagline

            if (widget.movie.tagline != '')
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  widget.movie.tagline,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple[600],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),

            //genres

            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      widget.movie.genres
                          .map((country) => country.name)
                          .join(', '),
                      style: main)
                ],
              ),
            ),

            //overview

            OverView(text: widget.movie.overview),

            //cast

            if (widget.movie.cast!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cast',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.purple[600],
                        ))
                  ],
                ),
              ),

            SizedBox(
              height: 320,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.movie.cast!.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 15),
                  itemBuilder: (context, index) {
                    Actor actor = widget.movie.cast![index];
                    return Column(
                      children: [
                        SizedBox(height: 200, child: ActorTile(actor: actor)),
                        Expanded(
                          child: SizedBox(
                            width: 150,
                            child: Column(
                              children: [
                                Flexible(
                                    child: Text(
                                  actor.name,
                                  style: name,
                                  textAlign: TextAlign.center,
                                )),
                                Flexible(
                                    child: Text(
                                  actor.character,
                                  style: character,
                                  textAlign: TextAlign.center,
                                )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            //trailer
            if (_playerController.initialVideoId != '')
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Teaser',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.purple[600],
                        ))
                  ],
                ),
              ),

            Container(
                child: _playerController.initialVideoId == ''
                    ? null
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: YoutubePlayer(
                            controller: _playerController,
                            showVideoProgressIndicator: true,
                          ),
                        ),
                      ))
          ],
        ));
  }
}
