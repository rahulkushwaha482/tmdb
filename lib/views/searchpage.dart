import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdbapp/views/widgets/movie_detail_page.dart';
import '../models/movie.dart';
import '../viewmodels/movie_viewmodel.dart';
import '../core/constant.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    final moviesAsync = query.isEmpty
        ? null
        : ref.watch(searchMoviesProvider(query));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: "Search movies...",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              query = value;
            });
          },
        ),
      ),
      body: query.isEmpty
          ? const Center(child: Text("Type to search movies"))
          : moviesAsync!.when(
              data: (movies) => movies.isEmpty
                  ? const Center(child: Text("No movies found"))
                  : ListView.builder(
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final movie = movies[index];
                        return ListTile(
                          leading: Image.network(
                            "${Constant.imageBaseUrl}${movie.posterPath}",
                            width: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image),
                          ),
                          title: Text(movie.title),
                          subtitle: Text(movie.release_date ?? ""),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MovieDetailsPage(movie: movie),
                              ),
                            );
                          },
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
            ),
    );
  }
}
