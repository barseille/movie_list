// On importe les packages nécessaires pour notre application
import 'package:flutter/material.dart';
import 'package:firebasetest/services/api_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// On crée une classe pour la page de détails du film
class MovieDetailsPage extends StatefulWidget {
  // On déclare une variable pour l'ID du film
  final int movieId;

  // Le constructeur de la classe, qui prend l'ID du film en paramètre
  const MovieDetailsPage({super.key, required this.movieId});

  // On crée l'état de la page de détails du film
  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

// On crée la classe pour l'état de la page de détails du film
class _MovieDetailsPageState extends State<MovieDetailsPage> {
  // On déclare un contrôleur pour la vidéo YouTube
  late YoutubePlayerController _youtubePlayerController;

  // Cette méthode est appelée quand l'objet est détruit
  @override
  void dispose() {
    // On libère les ressources utilisées par le contrôleur YouTube
    _youtubePlayerController.dispose();
    super.dispose();
  }

  // Cette méthode construit l'interface utilisateur de la page
  @override
  Widget build(BuildContext context) {
    // On crée une instance du service de films
    final MovieService _movieService = MovieService();

    // On retourne un Scaffold, qui est la structure de base d'une page Flutter
    return Scaffold(
      // On crée une AppBar (barre d'application) avec un titre et une couleur de fond
      appBar: AppBar(
        title: const Text("Movie Details"),
        backgroundColor: Colors.teal,
      ),
      // On utilise un FutureBuilder pour obtenir les détails du film
      body: FutureBuilder<Map<String, dynamic>>(
        // On appelle le service pour obtenir les détails du film
        future: _movieService.fetchMovieDetails(widget.movieId),
        // On construit l'interface en fonction de l'état du Future
        builder: (context, snapshot) {
          // Si une erreur s'est produite, on affiche un message d'erreur
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          // Si les données sont en cours de chargement, on affiche un indicateur de progression
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Si aucune donnée n'est disponible, on affiche un message indiquant qu'aucun détail n'a été trouvé
          if (!snapshot.hasData) {
            return const Center(child: Text('No details found'));
          }

          // On récupère les détails du film depuis le snapshot
          final movie = snapshot.data!;
          // On utilise un autre FutureBuilder pour obtenir les acteurs du film
          return FutureBuilder<List<dynamic>>(
            // On appelle le service pour obtenir les acteurs du film
            future: _movieService.fetchMovieActors(widget.movieId),
            // On construit l'interface en fonction de l'état du Future
            builder: (context, actorsSnapshot) {
              // Si une erreur s'est produite, on affiche un message d'erreur
              if (actorsSnapshot.hasError) {
                return const Center(child: Text('Failed to load movie actors'));
              }

              // Si les données sont en cours de chargement, on affiche un indicateur de progression
              if (actorsSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // On récupère la liste des acteurs depuis le snapshot
              final List<dynamic>? cast = actorsSnapshot.data;

              // On prend seulement les trois premiers acteurs
              final List<dynamic> mainActors =
                  cast != null ? cast.take(3).toList() : [];

              // On retourne un Padding pour ajouter des marges autour du contenu
              return Padding(
                padding: const EdgeInsets.all(16.0),
                // On utilise un ListView pour afficher les détails du film
                child: ListView(
                  children: [
                    // On utilise un autre FutureBuilder pour obtenir la clé de la bande-annonce
                    FutureBuilder<String?>(
                      // On appelle le service pour obtenir la clé de la bande-annonce
                      future:
                          _movieService.fetchMovieTrailerKey(widget.movieId),
                      // On construit l'interface en fonction de l'état du Future
                      builder: (context, trailerSnapshot) {
                        // Si les données sont en cours de chargement, on affiche un indicateur de progression
                        if (trailerSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        // Si une erreur s'est produite ou qu'aucune donnée n'est disponible, on affiche un message indiquant qu'aucune bande-annonce n'est disponible
                        if (trailerSnapshot.hasError ||
                            !trailerSnapshot.hasData ||
                            trailerSnapshot.data == null) {
                          return Text('No trailer available',
                              style: Theme.of(context).textTheme.bodyMedium);
                        }

                        // On récupère la clé de la bande-annonce depuis le snapshot
                        final trailerKey = trailerSnapshot.data!;
                        // On initialise le contrôleur YouTube avec la clé de la bande-annonce
                        _youtubePlayerController = YoutubePlayerController(
                          initialVideoId: trailerKey,
                          flags: const YoutubePlayerFlags(
                            autoPlay: false,
                            mute: false,
                          ),
                        );

                        // On retourne un YoutubePlayer pour afficher la vidéo de la bande-annonce
                        return YoutubePlayer(
                          controller: _youtubePlayerController,
                          showVideoProgressIndicator: true,
                        );
                      },
                    ),

                    // On ajoute un espace vertical de 16 pixels
                    const SizedBox(height: 16),
                    // On affiche le titre du film
                    Text(
                      movie['title'] ?? 'No title available',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    // On ajoute un espace vertical de 16 pixels
                    const SizedBox(height: 16),
                    // On affiche la date de sortie du film
                    Text(
                      'Release Date: ${movie['release_date'] ?? 'Unknown'}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    // On ajoute un espace vertical de 16 pixels
                    const SizedBox(height: 16),

                    // On affiche la note moyenne du film sous forme d'étoiles
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

                    // On ajoute un espace vertical de 24 pixels
                    const SizedBox(height: 24),

                    // On affiche le titre "Overview"
                    Text(
                      'Overview',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    // On ajoute un espace vertical de 8 pixels
                    const SizedBox(height: 8),
                    // On affiche le résumé du film
                    Text(
                      movie['overview'] ?? 'No overview available',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    // On ajoute un espace vertical de 24 pixels
                    const SizedBox(height: 24),

                    // On affiche le titre "Genres"
                    Text(
                      'Genres',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    // On ajoute un espace vertical de 8 pixels
                    const SizedBox(height: 8),
                    // On affiche les genres du film sous forme de chips
                    Wrap(
                      spacing: 6.0, // Espacement entre chaque chip
                      children: movie['genres'] != null
                          ? (movie['genres'] as List<dynamic>).map((genre) {
                              return Chip(
                                label: Text(genre['name']),
                                backgroundColor: Colors.teal,
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                              );
                            }).toList()
                          : [
                              const Chip(label: Text('No genres available'))
                            ], // Si aucun genre n'est disponible, afficher un chip avec ce texte
                    ),

                    // On ajoute un espace vertical de 24 pixels
                    const SizedBox(height: 24),

// On affiche le titre "Actors"
                    Text(
                      'Actors',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
// On ajoute un espace vertical de 8 pixels
                    const SizedBox(height: 8),
// On affiche les principaux acteurs du film
                    Wrap(
                      spacing: 16.0, // Espacement entre chaque image d'acteur
                      children: mainActors.isNotEmpty
                          ? mainActors.map((actor) {
                              // Récupérer l'URL de l'image de l'acteur depuis l'API
                              String? actorImageUrl = actor['profile_path'];
                              // Récupérer le nom de l'acteur
                              String? actorName = actor['name'];

                              // Si l'URL de l'image est disponible, afficher l'image avec le nom de l'acteur
                              return actorImageUrl != null
                                  ? Column(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            'https://image.tmdb.org/t/p/w200$actorImageUrl',
                                          ),
                                          radius:
                                              50.0, // Taille du cercle de l'avatar
                                        ),
                                        const SizedBox(
                                            height:
                                                8), // Espacement entre l'image et le nom de l'acteur
                                        Text(
                                          actorName ?? 'Unknown',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    )
                                  : Container(); // Sinon, afficher un conteneur vide
                            }).toList()
                          : [
                              const Text('No actors available')
                            ], // Si aucun acteur n'est disponible, afficher un texte
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
