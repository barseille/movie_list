class Movie {
  final int id;
  final String title;
  final String releaseDate;
  final String posterPath;
  final String overview;
  final List<String> genres;
  final List<String> actors;

  Movie({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.posterPath,
    required this.overview,
    required this.genres,
    required this.actors,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      releaseDate: json['release_date'] ?? '',
      posterPath: json['poster_path'] ?? '',
      overview: json['overview'] ?? '',
      genres: (json['genres'] ?? []).map<String>((genre) => genre['name']).toList(),
      actors: (json['cast'] ?? []).map<String>((actor) => actor['name']).toList(),
    );
  }
}
