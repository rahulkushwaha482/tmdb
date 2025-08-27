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
      // appBar: AppBar(
      //   title: Text(movie.title),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.share),
      //       onPressed: () {
      //         Share.share(
      //           "Check out this movie: ${movie.title} - fakeapp://movie/${movie.id}",
      //         );
      //       },
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    20,
                  ), // radius for all corners
                  child: Image.network(
                    "${Constant.imageBaseUrl}${movie.posterPath}",
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(Icons.cancel_rounded),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            Text(
              textAlign: TextAlign.center,

              movie.title.toString(),
              style: TextStyle(
                fontSize: 23,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 9,
              children: [
                Text(movie.release_date.toString()),
                Text(movie.original_language.toString()),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 9),
              child: Text(
                movie.overview ?? "No description",
                style: TextStyle(fontSize: 15, fontStyle: FontStyle.normal),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    Share.share(
                      "Check out this movie: ${movie.title} - fakeapp://movie/${movie.id}",
                    );
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () async {
                    await repo.saveMovie(movie);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Bookmarked!")),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
