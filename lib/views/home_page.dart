import 'package:flutter/material.dart';
import 'package:firebasetest/services/api_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'movie_details_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Movies List"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: const MoviesInformation(),
    );
  }
}

class MovieSearchDelegate extends SearchDelegate {
  final MovieService _movieService = MovieService();
  List<dynamic> _allMovies = [];

  MovieSearchDelegate() {
    _fetchAllMovies();
  }

  Future<void> _fetchAllMovies() async {
    _allMovies = await _movieService.fetchMovies();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          close(context, null); // Close the search and return to the main page
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close the search and return to the main page
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<dynamic> results = _allMovies.where((movie) {
      final String title = movie['title'] ?? '';
      return title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final movie = results[index];
        return ListTile(
          leading: Image.network('https://image.tmdb.org/t/p/w500${movie['poster_path']}'),
          title: Text(movie['title']),
          subtitle: RatingBarIndicator(
            rating: (movie['vote_average'] ?? 0) / 2,
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 20.0,
            direction: Axis.horizontal,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailsPage(movieId: movie['id']),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<dynamic> suggestions = _allMovies.where((movie) {
      final String title = movie['title'] ?? '';
      return title.toLowerCase().startsWith(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final movie = suggestions[index];
        return ListTile(
          leading: Image.network('https://image.tmdb.org/t/p/w500${movie['poster_path']}'),
          title: Text(movie['title']),
          subtitle: RatingBarIndicator(
            rating: (movie['vote_average'] ?? 0) / 2,
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 20.0,
            direction: Axis.horizontal,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailsPage(movieId: movie['id']),
              ),
            );
          },
        );
      },
    );
  }
}

class MoviesInformation extends StatefulWidget {
  const MoviesInformation({super.key});

  @override
  State<MoviesInformation> createState() => _MoviesInformationState();
}

class _MoviesInformationState extends State<MoviesInformation> {
  final MovieService _movieService = MovieService();
  late Future<List<dynamic>> _movies;

  @override
  void initState() {
    super.initState();
    _movies = _fetchMovies();
  }

  Future<List<dynamic>> _fetchMovies() async {
    return await _movieService.fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<dynamic>>(
            future: _movies,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No movies found'));
              }

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final movie = snapshot.data![index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: Image.network('https://image.tmdb.org/t/p/w500${movie['poster_path']}'),
                      title: Text(movie['title']),
                      subtitle: RatingBarIndicator(
                        rating: (movie['vote_average'] ?? 0) / 2,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailsPage(movieId: movie['id']),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
