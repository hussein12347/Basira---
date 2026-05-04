import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sqlDatabase;

import '../../../const/constant.dart';
import 'crud.dart';

/// A concrete implementation of the [CRUD] interface using SQLite.
///
/// This class handles the initialization, schema creation, and execution of
/// database operations for the application using the `sqflite` package.
class MySqlDataBase extends CRUD {
  sqlDatabase.Database? _db;

  /// Retrieves the active database instance.
  ///
  /// If the database is not initialized or has been closed, it calls
  /// [_initDatabase] to open it before returning the instance.
  Future<sqlDatabase.Database?> getDatabase() async {
    if (_db == null || !_db!.isOpen) {
      await _initDatabase();
    }
    return _db;
  }

  /// Initializes the SQLite database.
  ///
  /// Sets up the database file path, version, and opens the connection.
  /// It also enforces foreign key constraints whenever the database is opened.
  Future<void> _initDatabase() async {
    String databasePath = await sqlDatabase.getDatabasesPath();
    String databaseName = "quran.db";
    String realDatabasePath = join(databasePath, databaseName);
    int version = 1;

    _db = await sqlDatabase.openDatabase(
      realDatabasePath,
      version: version,
      onCreate: _onCreate,
      onOpen: (db) async {
        // Enable foreign key constraints for SQLite
        await db.execute('PRAGMA foreign_keys = ON;');
      },
    );
  }

  /// Called when the database is created for the first time.
  ///
  /// This is where all the initial tables and schemas should be defined.
  Future<void> _onCreate(sqlDatabase.Database db, int version) async {
    // ==========================================
    // Bookmarks Table Schema
    // ==========================================
    await db.execute('''
  CREATE TABLE IF NOT EXISTS $kBookmarksTableName (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    $kSurahNumberColumn INTEGER NOT NULL,
    $kVerseNumberColumn INTEGER NOT NULL,
    $kNoteColumn TEXT, 
    $kColorColumn INTEGER NOT NULL,
    $kCreatedAtColumn TEXT NOT NULL
  )
''');
  }

  @override
  Future<bool> delete({
    required String tableName,
    required int id,
    required String ColumnIDName,
  }) async {
    final db = await getDatabase();
    int deleted = await db!.delete(
      tableName,
      where: "$ColumnIDName = ?",
      whereArgs: [id],
    );
    // Returns true if at least one row was affected.
    return deleted > 0;
  }

  @override
  Future<bool> insert({
    required String tableName,
    required Map<String, dynamic> values,
  }) async {
    final db = await getDatabase();
    int inserted = await db!.insert(tableName, values);
    // Returns true if the row was successfully inserted.
    return inserted > 0;
  }

  /// Inserts a row into the database and returns its auto-generated ID.
  ///
  /// Unlike [insert], which returns a boolean success status, this method
  /// is useful when you need the ID of the newly created record for subsequent operations.
  Future<int> insertReturnedId({
    required String tableName,
    required Map<String, dynamic> values,
  }) async {
    final db = await getDatabase();
    int inserted = await db!.insert(tableName, values);
    return inserted;
  }

  @override
  Future<List<Map<String, Object?>>> select({
    required String tableName,
    required String? where,
  }) async {
    final db = await getDatabase();
    // If no 'where' clause is provided, fetch all records from the table.
    if (where == null) {
      return await db!.query(tableName);
    } else {
      return await db!.query(tableName, where: where);
    }
  }

  @override
  Future<bool> update({
    required String tableName,
    required String ColumnIDName,
    required int id,
    required Map<String, dynamic> values,
  }) async {
    final db = await getDatabase();
    int updated = await db!.update(
      tableName,
      values,
      where: "$ColumnIDName = ?",
      whereArgs: [id],
    );
    // Returns true if at least one row was successfully updated.
    return updated > 0;
  }

  @override
  Future<List<Map<String, Object?>>> selectUsingQuery({
    required String query,
    List<Object?>? arguments,
  }) async {
    final db = await getDatabase();
    // Use rawQuery with optional arguments to prevent SQL injection.
    return await db!.rawQuery(query, arguments);
  }
}