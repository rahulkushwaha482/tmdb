import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmdbapp/core/constant.dart';
import 'package:tmdbapp/models/movie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tmdbapp/viewmodels/bookmarkviewmodel.dart';
import 'package:tmdbapp/viewmodels/movie_viewmodel.dart';

class MovieDetailsPage extends ConsumerWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(movieRepositoryProvider);
    final bookmarks = ref.watch(bookmarkProvider);

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
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 10,
              children: [
                Column(
                  spacing: 2,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        Share.share(
                          "Check out this movie: ${movie.title} - fakeapp://movie/${movie.id}",
                        );
                      },
                    ),
                    Text('Share'),
                  ],
                ),

                Column(
                  spacing: 2,
                  children: [
                    IconButton(
                      icon: Icon(
                        bookmarks.any((m) => m.id == movie.id)
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                      ),
                      onPressed: () {
                        ref
                            .read(bookmarkProvider.notifier)
                            .toggleBookmark(movie);

                        final isBookmarked = ref
                            .read(bookmarkProvider.notifier)
                            .isBookmarked(movie.id);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isBookmarked
                                  ? "Bookmarked!"
                                  : "Removed from bookmarks!",
                            ),
                          ),
                        );
                      },
                    ),
                    Text('Bookmark'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
