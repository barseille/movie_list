import 'package:flutter/material.dart';
import 'package:firebasetest/services/api_service.dart';
import 'movie_details_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Movies"),
      ),
      body: const MoviesInformation(),
    );
  }
}

class MoviesInformation extends StatefulWidget {
  const MoviesInformation({Key? key}) : super(key: key);

  @override
  State<MoviesInformation> createState() => _MoviesInformationState();
}

class _MoviesInformationState extends State<MoviesInformation> {
  final MovieService _movieService = MovieService();
  late Future<List<dynamic>> _movies;
  String _currentFilter = 'date';

  @override
  void initState() {
    super.initState();
    _movies = _fetchMovies();
  }

  Future<List<dynamic>> _fetchMovies() async {
    List<dynamic> movies = await _movieService.fetchMovies();
    return _applyFilter(movies);
  }

  List<dynamic> _applyFilter(List<dynamic> movies) {
    switch (_currentFilter) {
      case 'date':
        movies.sort((a, b) => (a['release_date'] ?? '').compareTo(b['release_date'] ?? ''));
        break;
      case 'author':
        // Sorting logic by author (if available)
        break;
      case 'actor':
        // Sorting logic by actor (if available)
        break;
    }
    return movies;
  }

  void _changeFilter(String filter) {
    setState(() {
      _currentFilter = filter;
      _movies = _fetchMovies(); // Re-fetch and apply sort logic
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: () => _changeFilter('date'), child: const Text('Date')),
            ElevatedButton(onPressed: () => _changeFilter('author'), child: const Text('Auteur')),
            ElevatedButton(onPressed: () => _changeFilter('actor'), child: const Text('Acteur')),
          ],
        ),
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
                  return ListTile(
                    leading: Image.network('https://image.tmdb.org/t/p/w500${movie['poster_path']}'),
                    title: Text(movie['title']),
                    subtitle: Text(movie['release_date']),
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
            },
          ),
        ),
      ],
    );
  }
}
