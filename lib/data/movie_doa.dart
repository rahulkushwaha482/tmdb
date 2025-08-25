import 'package:sqflite/sqflite.dart';
import 'package:tmdbapp/core/dbhelper.dart';
import '../../models/movie.dart';

class MovieDao {
  Future<void> insertMovie(Movie movie) async {
    final db = await DBHelper().db;
    await db.insert(
      "bookmarks",
      movie.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Movie>> getAllMovies() async {
    final db = await DBHelper().db;
    final res = await db.query("bookmarks");
    return res.map((e) => Movie.fromJson(e)).toList();
  }

  Future<void> deleteMovie(int id) async {
    final db = await DBHelper().db;
    await db.delete("bookmarks", where: "id = ?", whereArgs: [id]);
  }
}
