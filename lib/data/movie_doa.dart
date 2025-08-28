import 'package:sqflite/sqflite.dart';
import 'package:tmdbapp/core/dbhelper.dart';
import 'package:tmdbapp/models/movie.dart';

class MovieDao {
  Future<void> insertMovies(List<Movie> movies, String category) async {
    final db = await DBHelper().db;
    final batch = db.batch();
    for (final movie in movies) {
      final data = movie.toJson();
      data['category'] = category;
      batch.insert(
        "movies",
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Movie>> getMoviesByCategory(String category) async {
    final db = await DBHelper().db;
    final res = await db.query(
      "movies",
      where: "category = ?",
      whereArgs: [category],
    );
    return res.map((e) => Movie.fromJson(e)).toList();
  }

  Future<void> insertBookmark(Movie movie) async {
    final db = await DBHelper().db;
    await db.insert(
      "bookmarks",
      movie.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Movie>> getAllBookmarks() async {
    final db = await DBHelper().db;
    final maps = await db.query("bookmarks");
    return maps.map((m) => Movie.fromJson(m)).toList();
  }

  Future<void> deleteMovie(int id) async {
    final db = await DBHelper().db;
    await db.delete("bookmarks", where: "id = ?", whereArgs: [id]);
  }

  Future<bool> isBookmarked(int id) async {
    final db = await DBHelper().db;
    final res = await db.query("bookmarks", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty;
  }
}
