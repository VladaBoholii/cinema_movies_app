class Actor {
  final String name;
  final String profilePath;
  final String character;

  Actor(
      {required this.name, required this.profilePath, required this.character});

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      name: json['name'],
      profilePath: "https://image.tmdb.org/t/p/original${json['profile_path']}",
      character: json['character'],
    );
  }
}
