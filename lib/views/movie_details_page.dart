import 'package:flutter/material.dart';
import 'package:firebasetest/services/api_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailsPage extends StatefulWidget {
  final int movieId;

  const MovieDetailsPage({Key? key, required this.movieId}) : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late YoutubePlayerController _youtubePlayerController;

  @override
  void dispose() {
    _youtubePlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MovieService _movieService = MovieService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Details"),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _movieService.fetchMovieDetails(widget.movieId),
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
            future: _movieService.fetchMovieActors(widget.movieId),
            builder: (context, actorsSnapshot) {
              if (actorsSnapshot.hasError) {
                return const Center(child: Text('Failed to load movie actors'));
              }

              if (actorsSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final List<dynamic>? cast = actorsSnapshot.data;
              
              // Get only the first three actors
              final List<dynamic> mainActors = cast != null 
                ? cast.take(3).toList()
                : [];

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    FutureBuilder<String?>(
                      future: _movieService.fetchMovieTrailerKey(widget.movieId),
                      builder: (context, trailerSnapshot) {
                        if (trailerSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (trailerSnapshot.hasError || !trailerSnapshot.hasData || trailerSnapshot.data == null) {
                          return Text('No trailer available', style: Theme.of(context).textTheme.bodyMedium);
                        }

                        final trailerKey = trailerSnapshot.data!;
                        _youtubePlayerController = YoutubePlayerController(
                          initialVideoId: trailerKey,
                          flags: const YoutubePlayerFlags(
                            autoPlay: false,
                            mute: false,
                          ),
                        );

                        return YoutubePlayer(
                          controller: _youtubePlayerController,
                          showVideoProgressIndicator: true,
                        );
                      },
                    ),

                    const SizedBox(height: 16),
                    Text(
                      movie['title'] ?? 'No title available',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Release Date: ${movie['release_date'] ?? 'Unknown'}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),

                    RatingBarIndicator(
                      rating: (movie['vote_average'] ?? 0) / 2,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 20.0,
                      direction: Axis.horizontal,
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Overview',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie['overview'] ?? 'No overview available',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Genres',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie['genres'] != null
                          ? (movie['genres'] as List<dynamic>)
                              .map((genre) => genre['name'])
                              .join(', ')
                          : 'No genres available',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Actors',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mainActors.isNotEmpty
                          ? mainActors.map((actor) => actor['name'] ?? 'Unknown').join(', ')
                          : 'No actors available',
                      style: Theme.of(context).textTheme.bodyMedium,
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
