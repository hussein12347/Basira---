/// An abstract interface defining standard Create, Read, Update, and Delete (CRUD) operations.
///
/// Implementing this class ensures a consistent database structure and makes
/// it easy to switch or mock database implementations in the future.
abstract class CRUD {

  /// Inserts a new record into the database.
  ///
  /// [tableName] is the name of the table.
  /// [values] is a map containing the column names as keys and the data as values.
  /// Returns `true` if the insertion was successful, otherwise `false`.
  Future<bool> insert({
    required String tableName,
    required Map<String, dynamic> values,
  });

  /// Updates an existing record in the database.
  ///
  /// [ColumnIDName] is the name of the primary key column used to find the record.
  /// [tableName] is the name of the table.
  /// [id] is the specific ID of the record to update.
  /// [values] contains the updated data mapped to their respective column names.
  /// Returns `true` if the update was successful, otherwise `false`.
  Future<bool> update({
    required String ColumnIDName,
    required String tableName,
    required int id,
    required Map<String, dynamic> values,
  });

  /// Deletes a specific record from the database.
  ///
  /// [tableName] is the name of the table.
  /// [id] is the ID of the record to be deleted.
  /// [ColumnIDName] is the name of the primary key column used to match the [id].
  /// Returns `true` if the deletion was successful, otherwise `false`.
  Future<bool> delete({
    required String tableName,
    required int id,
    required String ColumnIDName,
  });

  /// Retrieves records from the database based on a specific condition.
  ///
  /// [tableName] is the name of the table to query.
  /// [where] is the SQL WHERE clause (e.g., "id = 1") to filter the results.
  /// Returns a list of maps, where each map represents a database row.
  Future<List<Map<String, Object?>>> select({
    required String tableName,
    required String where,
  });

  /// Executes a raw SQL query and returns the results.
  ///
  /// [query] is the complete SQL SELECT statement.
  /// Useful for complex queries, joins, or aggregations that aren't covered by [select].
  /// Returns a list of maps representing the rows fetched.
  Future<List<Map<String, Object?>>> selectUsingQuery({
    required String query,
  });

// ==========================================
// Planned / Future Features
// ==========================================

// /// Searches for records in the database matching a specific keyword.
// ///
// /// [tableName] is the name of the table.
// /// [searchWord] is the keyword to look for.
// Future<List<Map<String, Object?>>> search({
//   required String tableName,
//   required String searchWord,
// });
}