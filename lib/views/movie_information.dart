import 'package:flutter/material.dart';
import 'package:firebasetest/services/api_service.dart';
import 'package:firebasetest/views/movie_details_page.dart';

class MoviesInformation extends StatefulWidget {
  const MoviesInformation({super.key});

  @override
  State<MoviesInformation> createState() => _MoviesInformationState();
}

class _MoviesInformationState extends State<MoviesInformation> {
  final MovieService _movieService = MovieService();
  int _page = 1;
  final List<dynamic> _allMovies = [];
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final movies = await _movieService.fetchMovies(page: _page);
      setState(() {
        _allMovies.addAll(movies);
        _page++;
      });
    } catch (error) {
      setState(() {
        _hasError = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const Center(child: Text('Failed to load movies'));
    }

    if (_isLoading && _allMovies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_allMovies.isEmpty) {
      return const Center(child: Text('No movies found'));
    }

    return ListView.builder(
      itemCount: _allMovies.length,
      itemBuilder: (context, index) {
        final movie = _allMovies[index];

        return ListTile(
          leading: Image.network(
              'https://image.tmdb.org/t/p/w500${movie['poster_path'] ?? ''}'),
          title: Text(movie['title'] ?? 'No title available'),
          subtitle: Text('Release Date: ${movie['release_date'] ?? 'Unknown'}'),
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
