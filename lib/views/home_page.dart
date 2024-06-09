import 'package:flutter/material.dart';
import 'package:firebasetest/services/api_service.dart'; // Service pour récupérer des données des films depuis une API.
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Package pour afficher des barres de notation.
import 'movie_details_page.dart'; // Page des détails du film.

class HomePage extends StatelessWidget {
  // Constructeur de la classe HomePage.
  const HomePage({super.key});

  // Méthode qui construit l'interface utilisateur de la page d'accueil.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar est la barre en haut de l'application.
      appBar: AppBar(
        // Titre de l'application affiché dans l'AppBar.
        title: const Text("Movies List"),
        backgroundColor: Colors.teal, // Couleur de fond de l'AppBar.
        actions: [
          // Bouton de recherche dans l'AppBar.
          IconButton(
            icon: const Icon(Icons.search), // Icône de la loupe pour la recherche.
            onPressed: () {
              // Action à exécuter lorsque le bouton de recherche est pressé.
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(), // Délègue la recherche à MovieSearchDelegate.
              );
            },
          ),
        ],
      ),
      body: const MoviesInformation(), // Corps de la page qui affiche les informations des films.
    );
  }
}

// Classe pour gérer la recherche de films.
class MovieSearchDelegate extends SearchDelegate {
  final MovieService _movieService = MovieService(); // Service pour récupérer les films depuis l'API.
  List<dynamic> _allMovies = []; // Liste de tous les films.

  MovieSearchDelegate() {
    // Constructeur qui appelle la méthode pour récupérer tous les films.
    _fetchAllMovies();
  }

  // Méthode pour récupérer tous les films depuis l'API.
  Future<void> _fetchAllMovies() async {
    _allMovies = await _movieService.fetchMovies();
  }

  // Méthode qui construit les actions dans la barre de recherche.
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear), // Icône pour effacer la recherche.
        onPressed: () {
          query = ''; // Efface la requête de recherche.
          close(context, null); // Ferme la recherche et retourne à la page principale.
        },
      ),
    ];
  }

  // Méthode qui construit le widget de retour en arrière dans la barre de recherche.
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back), // Icône pour revenir en arrière.
      onPressed: () {
        close(context, null); // Ferme la recherche et retourne à la page principale.
      },
    );
  }

  // Méthode qui construit les résultats de la recherche.
  @override
  Widget buildResults(BuildContext context) {
    final List<dynamic> results = _allMovies.where((movie) {
      final String title = movie['title'] ?? ''; // Récupère le titre du film.
      return title.toLowerCase().contains(query.toLowerCase()); // Vérifie si le titre contient la requête de recherche.
    }).toList();

    // Retourne une liste de films correspondant à la recherche.
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final movie = results[index]; // Récupère le film à l'index donné.
        return ListTile(
          leading: Image.network('https://image.tmdb.org/t/p/w500${movie['poster_path']}'), // Affiche l'image du film.
          title: Text(movie['title']), // Affiche le titre du film.
          subtitle: RatingBarIndicator(
            rating: (movie['vote_average'] ?? 0) / 2, // Affiche la note du film.
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 20.0,
            direction: Axis.horizontal,
          ),
          onTap: () {
            // Ouvre la page des détails du film lorsqu'on tape dessus.
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

  // Méthode qui construit les suggestions lors de la recherche.
  @override
  Widget buildSuggestions(BuildContext context) {
    final List<dynamic> suggestions = _allMovies.where((movie) {
      final String title = movie['title'] ?? ''; // Récupère le titre du film.
      return title.toLowerCase().startsWith(query.toLowerCase()); // Vérifie si le titre commence par la requête de recherche.
    }).toList();

    // Retourne une liste de suggestions de films.
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final movie = suggestions[index]; // Récupère le film à l'index donné.
        return ListTile(
          leading: Image.network('https://image.tmdb.org/t/p/w500${movie['poster_path']}'), // Affiche l'image du film.
          title: Text(movie['title']), // Affiche le titre du film.
          subtitle: RatingBarIndicator(
            rating: (movie['vote_average'] ?? 0) / 2, // Affiche la note du film.
            itemBuilder: (context, index) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 20.0,
            direction: Axis.horizontal,
          ),
          onTap: () {
            // Ouvre la page des détails du film lorsqu'on tape dessus.
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

// Widget qui affiche les informations des films.
class MoviesInformation extends StatefulWidget {
  const MoviesInformation({super.key});

  @override
  State<MoviesInformation> createState() => _MoviesInformationState();
}

// État associé au widget MoviesInformation.
class _MoviesInformationState extends State<MoviesInformation> {
  final MovieService _movieService = MovieService(); // Service pour récupérer les films.
  late Future<List<dynamic>> _movies; // Liste des films récupérés.

  @override
  void initState() {
    super.initState();
    _movies = _fetchMovies(); // Récupère les films lorsque le widget est initialisé.
  }

  // Méthode pour récupérer les films depuis l'API.
  Future<List<dynamic>> _fetchMovies() async {
    return await _movieService.fetchMovies();
  }

  // Méthode qui construit l'interface utilisateur.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<dynamic>>(
            future: _movies, // Données futures des films.
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong')); // Affiche un message d'erreur s'il y a un problème.
              }

              // en attente de chargement
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator()); // Affiche un indicateur de chargement pendant la récupération des données.
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No movies found')); // Affiche un message si aucun film n'est trouvé.
              }

              // Retourne une liste de films sous forme de cartes.
              return ListView.builder(
                itemCount: snapshot.data!.length, // Nombre de films à afficher.
                itemBuilder: (context, index) {
                  final movie = snapshot.data![index]; // Récupère le film à l'index donné.
                  return Card(
                    margin: const EdgeInsets.all(10.0), // Marge autour de chaque carte.
                    child: ListTile(
                      leading: Image.network('https://image.tmdb.org/t/p/w500${movie['poster_path']}'), // Affiche l'image du film.
                      title: Text(movie['title']), // Affiche le titre du film.
                      subtitle: RatingBarIndicator(
                        rating: (movie['vote_average'] ?? 0) / 2, // Affiche la note du film.
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                      ),
                      onTap: () {
                        // Ouvre la page des détails du film lorsqu'on tape dessus.
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
