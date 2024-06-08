import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieService {
  final String _baseUrl = 'https://api.themoviedb.org/3';
  final String _apiKey = dotenv.env['API_KEY']!;

  Future<List<dynamic>> fetchMovies({int page = 1}) async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&page=$page'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/$movieId?api_key=$_apiKey&append_to_response=videos'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<List<dynamic>> fetchMovieActors(int movieId) async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/$movieId/credits?api_key=$_apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['cast'];
    } else {
      throw Exception('Failed to load movie actors');
    }
  }

  Future<String?> fetchMovieTrailerKey(int movieId) async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/$movieId/videos?api_key=$_apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> videos = data['results'];

      final trailer = videos.firstWhere(
        (video) => video['type'] == 'Trailer' && video['site'] == 'YouTube',
        orElse: () => null,
      );

      if (trailer != null) {
        return trailer['key'];
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load movie trailer');
    }
  }
}
