import 'package:tmdbapp/core/constant.dart';
import 'package:tmdbapp/data/movie_doa.dart';

import '../core/api_client.dart';
import '../models/movie.dart';

class MovieRepository {
  final ApiClient apiClient;
  final MovieDao movieDao;

  MovieRepository(this.apiClient, this.movieDao);

  Future<List<Movie>> getTrendingMovies() async {
    final response = await apiClient.getTrendingMovies(Constant.apiKey);
    return response.results;
  }

  Future<List<Movie>> getNowPlayingMovies() async {
    final response = await apiClient.getNowPlayingMovies(Constant.apiKey);
    return response.results;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await apiClient.searchMovies(Constant.apiKey, query);
    return response.results;
  }

  Future<void> saveMovie(Movie movie) async =>
      await movieDao.insertMovie(movie);
  Future<List<Movie>> getBookmarks() async => await movieDao.getAllMovies();
  Future<void> removeMovie(int id) async => await movieDao.deleteMovie(id);
  Future<bool> isBookmarked(int id) async => await movieDao.isBookmarked(id);
}
