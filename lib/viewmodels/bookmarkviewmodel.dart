import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdbapp/viewmodels/movie_viewmodel.dart';
import '../../models/movie.dart';
import '../data/movie_repository.dart';

class BookmarkViewModel extends StateNotifier<List<Movie>> {
  final MovieRepository repository;

  BookmarkViewModel(this.repository) : super([]) {
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    final movies = await repository.getBookmarks();
    state = movies;
  }

  Future<void> toggleBookmark(Movie movie) async {
    final exists = state.any((m) => m.id == movie.id);
    if (exists) {
      await repository.removeMovie(movie.id);
      state = state.where((m) => m.id != movie.id).toList();
    } else {
      await repository.saveMovie(movie);
      state = [...state, movie];
    }
  }

  bool isBookmarked(int id) {
    return state.any((m) => m.id == id);
  }
}

final bookmarkProvider = StateNotifierProvider<BookmarkViewModel, List<Movie>>((
  ref,
) {
  final repo = ref.watch(movieRepositoryProvider);
  return BookmarkViewModel(repo);
});
