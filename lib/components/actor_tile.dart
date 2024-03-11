import 'package:cinema_movies_app/model/actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ActorTile extends StatefulWidget {
  final Actor actor;

  const ActorTile({super.key, required this.actor});

  @override
  State<ActorTile> createState() => _ActorTileState();
}

class _ActorTileState extends State<ActorTile> {
  TextStyle name = TextStyle(color: Colors.purple[600], fontSize: 16, fontWeight: FontWeight.w700);
  TextStyle character = TextStyle(color: Colors.purple[400], fontSize: 14, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1.0 / 1.5,
            child: widget.actor.profilePath !=
                    "https://image.tmdb.org/t/p/originalnull"
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(widget.actor.profilePath),
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.black, // Add color property if needed
                      ),
                    ),
                  ),
          ),
        ),
        
      ],
    );
  }
}
