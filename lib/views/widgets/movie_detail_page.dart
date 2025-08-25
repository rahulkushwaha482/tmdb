import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdbapp/core/constant.dart';
import 'package:tmdbapp/models/movie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tmdbapp/viewmodels/movie_viewmodel.dart';

class MovieDetailsPage extends ConsumerWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(movieRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share(
                "Check out this movie: ${movie.title} - fakeapp://movie/${movie.id}",
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Image.network("${Constant.imageBaseUrl}${movie.posterPath}"),
          Text(movie.overview ?? "No description"),
          ElevatedButton(
            onPressed: () async {
              await repo.saveMovie(movie);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Bookmarked!")));
            },
            child: const Text("Bookmark"),
          ),
        ],
      ),
    );
  }
}
