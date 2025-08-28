// Trending ViewModel
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdbapp/core/api_client.dart';
import 'package:tmdbapp/data/movie_doa.dart';
import 'package:tmdbapp/data/movie_repository.dart';
import 'package:tmdbapp/models/movie.dart';

class TrendingMoviesViewModel extends StateNotifier<AsyncValue<List<Movie>>> {
  final MovieRepository repository;
  TrendingMoviesViewModel(this.repository) : super(const AsyncValue.loading()) {
    loadTrending();
  }

  Future<void> loadTrending() async {
    try {
      final movies = await repository.getTrendingMovies();
      state = AsyncValue.data(movies);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// Now Playing ViewModel
class NowPlayingMoviesViewModel extends StateNotifier<AsyncValue<List<Movie>>> {
  final MovieRepository repository;
  NowPlayingMoviesViewModel(this.repository)
    : super(const AsyncValue.loading()) {
    loadNowPlaying();
  }

  Future<void> loadNowPlaying() async {
    try {
      final movies = await repository.getNowPlayingMovies();
      state = AsyncValue.data(movies);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final dio = Dio();
  final client = ApiClient(dio);
  return MovieRepository(client, MovieDao());
});

final trendingMoviesProvider =
    StateNotifierProvider<TrendingMoviesViewModel, AsyncValue<List<Movie>>>(
      (ref) => TrendingMoviesViewModel(ref.watch(movieRepositoryProvider)),
    );

final nowPlayingMoviesProvider =
    StateNotifierProvider<NowPlayingMoviesViewModel, AsyncValue<List<Movie>>>(
      (ref) => NowPlayingMoviesViewModel(ref.watch(movieRepositoryProvider)),
    );

final searchMoviesProvider = FutureProvider.family<List<Movie>, String>((
  ref,
  query,
) async {
  final repo = ref.read(movieRepositoryProvider);
  return repo.searchMovies(query);
});
