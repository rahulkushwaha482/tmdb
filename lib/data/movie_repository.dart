import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:tmdbapp/core/constant.dart';
import 'package:tmdbapp/data/movie_doa.dart';

import '../core/api_client.dart';
import '../models/movie.dart';

class MovieRepository {
  final ApiClient apiClient;
  final MovieDao movieDao;

  MovieRepository(this.apiClient, this.movieDao);

  Future<List<Movie>> getTrendingMovies() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      // Offline → return from DB
      return movieDao.getMoviesByCategory("trending");
    } else {
      final movies = await apiClient.getTrendingMovies(Constant.apiKey);
      await movieDao.insertMovies(movies.results, "trending");
      return movies.results;
    }
  }

  Future<List<Movie>> getNowPlayingMovies() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      return movieDao.getMoviesByCategory("now_playing");
    } else {
      final movies = await apiClient.getNowPlayingMovies(Constant.apiKey);
      await movieDao.insertMovies(movies.results, "now_playing");
      return movies.results;
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await apiClient.searchMovies(Constant.apiKey, query);
    return response.results;
  }

  Future<void> saveMovie(Movie movie) async =>
      await movieDao.insertBookmark(movie);
  Future<List<Movie>> getBookmarks() async => await movieDao.getAllBookmarks();
  Future<void> removeMovie(int id) async => await movieDao.deleteMovie(id);
  Future<bool> isBookmarked(int id) async => await movieDao.isBookmarked(id);
}
