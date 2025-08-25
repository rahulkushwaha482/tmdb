import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdbapp/core/api_client.dart';
import 'package:tmdbapp/data/movie_doa.dart';
import '../data/movie_repository.dart';
import '../models/movie.dart';

class MovieViewModel extends StateNotifier<AsyncValue<List<Movie>>> {
  final MovieRepository repository;

  MovieViewModel(this.repository) : super(const AsyncValue.loading()) {
    loadMovies();
  }

  Future<void> loadMovies() async {
    try {
      final trending = await repository.getTrendingMovies();
      state = AsyncValue.data(trending);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final movieViewModelProvider =
    StateNotifierProvider<MovieViewModel, AsyncValue<List<Movie>>>((ref) {
      final repo = ref.watch(movieRepositoryProvider);
      return MovieViewModel(repo);
    });

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final dio = Dio();
  final client = ApiClient(dio);
  return MovieRepository(client, MovieDao());
});
