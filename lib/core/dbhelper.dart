import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._();
  static Database? _db;

  DBHelper._();

  factory DBHelper() => _instance;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), "movies.db");
    return await openDatabase(
      path,
      version: 2, // bump version so schema updates!
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE bookmarks (
            id INTEGER PRIMARY KEY,
            title TEXT,
            poster_path TEXT,
            overview TEXT,
            original_language TEXT,
            release_date TEXT
          )
        """);

        await db.execute("""
          CREATE TABLE movies (
            id INTEGER PRIMARY KEY,
            title TEXT,
            poster_path TEXT,
            overview TEXT,
            original_language TEXT,
            release_date TEXT,
            category TEXT
          )
        """);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // Run migrations here
        if (oldVersion < 2) {
          await db.execute("""
            CREATE TABLE movies (
              id INTEGER PRIMARY KEY,
              title TEXT,
              poster_path TEXT,
              overview TEXT,
              original_language TEXT,
              release_date TEXT,
              category TEXT
            )
          """);
        }
      },
    );
  }
}
