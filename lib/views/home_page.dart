import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdbapp/core/constant.dart';
import 'package:tmdbapp/views/widgets/movie_detail_page.dart';
import '../viewmodels/movie_viewmodel.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesState = ref.watch(movieViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Movies App")),
      body: moviesState.when(
        data: (movies) => GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieDetailsPage(movie: movie),
                ),
              ),
              child: Card(
                child: Column(
                  children: [
                    Image.network(
                      "${Constant.imageBaseUrl}${movie.posterPath}",
                    ),
                    Text(movie.title, maxLines: 2),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}
