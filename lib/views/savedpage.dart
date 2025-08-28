import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdbapp/core/constant.dart';
import 'package:tmdbapp/models/movie.dart';
import 'package:tmdbapp/viewmodels/movie_viewmodel.dart';
import 'package:tmdbapp/views/widgets/movie_detail_page.dart';

class SavedPage extends ConsumerWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(movieRepositoryProvider);

    return FutureBuilder<List<Movie>>(
      future: repo.getBookmarks(), // fetch saved movies
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }
        final movies = snapshot.data ?? [];

        if (movies.isEmpty) {
          return const Scaffold(body: Center(child: Text("No saved movies")));
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Saved Movies")),
          body: GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.65, // poster-like ratio
            ),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  // open movie details
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MovieDetailsPage(movie: movie),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    "${Constant.imageBaseUrl}${movie.posterPath}",
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
