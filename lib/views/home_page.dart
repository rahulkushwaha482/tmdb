import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdbapp/core/constant.dart';
import 'package:tmdbapp/models/movie.dart';
import 'package:tmdbapp/views/widgets/movie_detail_page.dart';
import '../viewmodels/movie_viewmodel.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trending = ref.watch(trendingMoviesProvider);
    final nowPlaying = ref.watch(nowPlayingMoviesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Movies App")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🔥 Trending",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            trending.when(
              data: (movies) => _MovieList(movies: movies),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text("Error: $e"),
            ),
            const SizedBox(height: 20),

            const Text(
              "🎬 Now Playing",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            nowPlaying.when(
              data: (movies) => _MovieList(movies: movies),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text("Error: $e"),
            ),
          ],
        ),
      ),
    );
  }
}

class _MovieList extends StatelessWidget {
  final List<Movie> movies;
  const _MovieList({required this.movies});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieDetailsPage(movie: movie),
                ),
              );
            },
            child: SizedBox(
              width: 120,
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        "${Constant.imageBaseUrl}${movie.posterPath}",
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
