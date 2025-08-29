import 'package:flutter_test/flutter_test.dart';
import 'package:tmdbapp/data/movie_doa.dart';
import 'package:tmdbapp/models/movie.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  late Database db;
  late MovieDao movieDao;

  setUp(() async {
    sqfliteFfiInit(); // initialize ffi
    databaseFactory = databaseFactoryFfi;

    db = await openDatabase(
      inMemoryDatabasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE movies (
            id INTEGER PRIMARY KEY,
            title TEXT,
            poster_path TEXT,
            overview TEXT,
            original_language TEXT,
            release_date TEXT
          )
        ''');
      },
    );

    movieDao = MovieDao(db);
  });

  // Cleanup
  tearDown(() async {
    await db.close();
  });

  test('Insert and fetch movie', () async {
    final movie = Movie(
      id: 1,
      title: 'Inception',
      posterPath: '/inception.jpg',
      overview: 'A dream within a dream',
      originalLanguage: 'en',
      releaseDate: '2010-07-16',
    );

    await movieDao.insertMovies(movie);

    final movies = await movieDao.getAllBookmarks();

    expect(movies.length, 1);
    expect(movies.first.title, 'Inception');
  });

  test('Delete movie', () async {
    final movie = Movie(
      id: 2,
      title: 'Interstellar',
      posterPath: '/interstellar.jpg',
      overview: 'Space travel and time',
      originalLanguage: 'en',
      releaseDate: '2014-11-07',
    );

    await movieDao.insertMovies(movie);

    var movies = await movieDao.getAllBookmarks();
    expect(movies.length, 1);

    await movieDao.deleteMovie(movie.id);

    movies = await movieDao.getAllBookmarks();
    expect(movies.isEmpty, true);
  });

  test('Check if bookmarked', () async {
    final movie = Movie(
      id: 3,
      title: 'Tenet',
      posterPath: '/tenet.jpg',
      overview: 'Time inversion',
      originalLanguage: 'en',
      releaseDate: '2020-08-26',
    );

    await movieDao.insertMovies(movie);

    final isBookmarked = await movieDao.isBookmarked(movie.id);

    expect(isBookmarked, true);
  });
}
