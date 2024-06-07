import 'package:flutter/material.dart';
import 'package:firebasetest/services/api_service.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailsPage extends StatelessWidget {
  final int movieId;

  const MovieDetailsPage({Key? key, required this.movieId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MovieService _movieService = MovieService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Details"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _movieService.fetchMovieDetails(movieId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No details found'));
          }

          final movie = snapshot.data!;
          return FutureBuilder<List<dynamic>>(
            future: _movieService.fetchMovieActors(movieId),
            builder: (context, actorsSnapshot) {
              if (actorsSnapshot.hasError) {
                return const Center(child: Text('Failed to load movie actors'));
              }

              if (actorsSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final List<dynamic>? cast = actorsSnapshot.data;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    Image.network(
                        'https://image.tmdb.org/t/p/w500${movie['poster_path'] ?? ''}'),
                    const SizedBox(height: 8),
                    Text(movie['title'] ?? 'No title available',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text('Release Date: ${movie['release_date'] ?? 'Unknown'}'),
                    const SizedBox(height: 8),
                    Text('Overview: ${movie['overview'] ?? 'No overview available'}'),
                    const SizedBox(height: 8),
                    Text(
                        'Genres: ${movie['genres'] != null ? (movie['genres'] as List<dynamic>).map((genre) => genre['name']).join(', ') : 'No genres available'}'),
                    const SizedBox(height: 8),
                    Text(
                        'Actors: ${cast != null && cast.isNotEmpty ? cast.map((actor) => actor['name'] ?? 'Unknown').join(', ') : 'No actors available'}'),
                    const SizedBox(height: 8),
                    FutureBuilder<String?>(
                      future: _movieService.fetchMovieTrailerKey(movieId),
                      builder: (context, trailerSnapshot) {
                        if (trailerSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (trailerSnapshot.hasError || !trailerSnapshot.hasData || trailerSnapshot.data == null) {
                          return const Text('No trailer available');
                        }

                        final trailerKey = trailerSnapshot.data!;
                        return YoutubePlayer(
                          controller: YoutubePlayerController(
                            initialVideoId: trailerKey,
                            flags: const YoutubePlayerFlags(
                              autoPlay: true,
                              mute: false,
                            ),
                          ),
                          showVideoProgressIndicator: true,
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}