// On importe le package pour décoder le JSON
import 'dart:convert';

// On importe le package http pour faire des requêtes web
import 'package:http/http.dart' as http;

// On importe le package dotenv pour charger les variables d'environnement
import 'package:flutter_dotenv/flutter_dotenv.dart';

// On crée une classe pour le service des films
class MovieService {
  // On récupère la clé API depuis les variables d'environnement
  final String _apiKey = dotenv.env['API_KEY']!; 
  
  // On crée une méthode pour obtenir les films populaires
  Future<List<dynamic>> fetchMovies() async {
    // On fait une requête GET à l'API pour obtenir les films populaires
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=$_apiKey&language=en-US&page=1'));

    // Si la requête réussit, on décode les données et on retourne la liste des films
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      // Si la requête échoue, on lance une exception
      throw Exception('Failed to load movies');
    }
  }

  // On crée une méthode pour obtenir les détails d'un film
  Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    // On fait une requête GET à l'API pour obtenir les détails du film
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId?api_key=$_apiKey&language=en-US'));

    // Si la requête réussit, on décode les données et on retourne les détails du film
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      // Si la requête échoue, on lance une exception
      throw Exception('Failed to load movie details');
    }
  }

  // On crée une méthode pour obtenir les acteurs d'un film
  Future<List<dynamic>> fetchMovieActors(int movieId) async {
    // On fait une requête GET à l'API pour obtenir les acteurs du film
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$_apiKey&language=en-US'));

    // Si la requête réussit, on décode les données et on retourne la liste des acteurs
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['cast'];
    } else {
      // Si la requête échoue, on lance une exception
      throw Exception('Failed to load movie actors');
    }
  }

  // On crée une méthode pour obtenir la clé de la bande-annonce d'un film
  Future<String?> fetchMovieTrailerKey(int movieId) async {
    // On fait une requête GET à l'API pour obtenir la bande-annonce du film
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$_apiKey&language=en-US'));

    // Si la requête réussit, on décode les données et on retourne la clé de la bande-annonce
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'];
      if (results.isNotEmpty) {
        return results[0]['key'];
      } else {
        return null;
      }
    } else {
      // Si la requête échoue, on lance une exception
      throw Exception('Failed to load movie trailer');
    }
  }
}
