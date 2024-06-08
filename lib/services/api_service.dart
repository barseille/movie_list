import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieService {
  final String _apiKey = dotenv.env['API_KEY']!; // Assurez-vous que la clé API est chargée correctement

  Future<List<dynamic>> fetchMovies() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=$_apiKey&language=en-US&page=1'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId?api_key=$_apiKey&language=en-US'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<List<dynamic>> fetchMovieActors(int movieId) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$_apiKey&language=en-US'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['cast'];
    } else {
      throw Exception('Failed to load movie actors');
    }
  }

  Future<String?> fetchMovieTrailerKey(int movieId) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$_apiKey&language=en-US'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'];
      if (results.isNotEmpty) {
        return results[0]['key'];
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load movie trailer');
    }
  }
}
