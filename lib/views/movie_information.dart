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

  @override
  void initState() {
    super.initState();
    _fetchMoreMovies();
  }

  Future<void> _fetchMoreMovies() async {
    try {
      final movies = await _movieService.fetchMovies(page: _page);
      setState(() {
        _allMovies.addAll(movies);
        _page++;
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _allMovies.length + 1,
      itemBuilder: (context, index) {
        if (index == _allMovies.length) {
          // Load more button
          return ElevatedButton(
            onPressed: _fetchMoreMovies,
            child: const Text('Load More'),
          );
        }
        final movie = _allMovies[index];
        return ListTile(
          leading: Image.network('https://image.tmdb.org/t/p/w500${movie['poster_path']}'),
          title: Text(movie['title']),
          subtitle: Text(movie['release_date']),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MovieDetailsPage(movieId: movie['id']),
            ));
          },
        );
      },
    );
  }
}
