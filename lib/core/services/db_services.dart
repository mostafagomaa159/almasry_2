import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/response/favorite/favorite_product_model.dart';
import '../models/response/notify_me/notify_subscription_model.dart';

class DbServices {
  DbServices._();

  static final DbServices instance = DbServices._();

  static Database? _database;

  static const String _databaseName = 'favorites.db';

  /// v2 added [notifyTableName]. Bump this and extend `onUpgrade` whenever a
  /// table changes, otherwise existing installs keep the old schema.
  static const int _databaseVersion = 2;

  static const String tableName = 'favorites';
  static const String notifyTableName = 'notify_subscriptions';

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

        await _createNotifyTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createNotifyTable(db);
        }
      },
    );
  }

  Future<void> _createNotifyTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $notifyTableName (
        sku TEXT PRIMARY KEY,
        productName TEXT NOT NULL,
        imagePath TEXT NOT NULL,
        fcmToken TEXT NOT NULL,
        createdAt INTEGER NOT NULL
      )
    ''');
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
    await db.delete(tableName, where: 'id = ?', whereArgs: [productId]);
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

    return result.map((map) => FavoriteProductModel.fromMap(map)).toList();
  }

  Future<void> toggleFavorite(FavoriteProductModel product) async {
    final exists = await isFavorite(product.id);

    if (exists) {
      await removeFavorite(product.id);
    } else {
      await addFavorite(product);
    }
  }

  /// Notify-me subscriptions

  Future<void> addNotifySubscription(
    NotifySubscriptionModel subscription,
  ) async {
    final db = await database;
    await db.insert(
      notifyTableName,
      subscription.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeNotifySubscription(String sku) async {
    final db = await database;
    await db.delete(notifyTableName, where: 'sku = ?', whereArgs: [sku]);
  }

  Future<bool> isNotifySubscribed(String sku) async {
    final db = await database;
    final result = await db.query(
      notifyTableName,
      where: 'sku = ?',
      whereArgs: [sku],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<List<NotifySubscriptionModel>> getNotifySubscriptions() async {
    final db = await database;
    final result = await db.query(notifyTableName, orderBy: 'createdAt DESC');

    return result.map((map) => NotifySubscriptionModel.fromMap(map)).toList();
  }
}
