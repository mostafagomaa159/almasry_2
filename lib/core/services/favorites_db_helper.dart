import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/response/response_favorite_product.dart';

class FavoritesDbHelper {
  FavoritesDbHelper._();

  static final FavoritesDbHelper instance = FavoritesDbHelper._();

  static Database? _database;

  static const String _databaseName = 'favorites.db';
  static const int _databaseVersion = 1;

  static const String tableName = 'favorites';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            imagePath TEXT NOT NULL,
            price TEXT NOT NULL,
            oldPrice TEXT NOT NULL,
            category TEXT NOT NULL,
            description TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> addFavorite(FavoriteProductModel product) async {
    final db = await database;
    await db.insert(
      tableName,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String productId) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  Future<bool> isFavorite(String productId) async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [productId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<List<FavoriteProductModel>> getFavorites() async {
    final db = await database;
    final result = await db.query(tableName);

    return result
        .map((map) => FavoriteProductModel.fromMap(map))
        .toList();
  }

  Future<void> toggleFavorite(FavoriteProductModel product) async {
    final exists = await isFavorite(product.id);

    if (exists) {
      await removeFavorite(product.id);
    } else {
      await addFavorite(product);
    }
  }
}
