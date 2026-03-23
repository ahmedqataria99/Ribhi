abstract class AppDatabase {
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
  });

  Future<int> insert(String table, Map<String, dynamic> values);

  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  });

  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  });

  // 🔥 أهم تعديل
  Future<T> transaction<T>(Future<T> Function(AppDatabase txn) action);

  Future<void> close();
}