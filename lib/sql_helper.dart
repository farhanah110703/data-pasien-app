import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
    CREATE TABLE patiens_database(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      nama TEXT,
      ttl TEXT,
      umur TEXT,
      diagnosa TEXT
    )
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('patiens_database.db', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  // add
  static Future<int> addPatien(
      String nama, String ttl, String umur, String diagnosa) async {
    final db = await SQLHelper.db();
    final data = {'nama': nama, 'ttl': ttl, 'umur': umur, 'diagnosa': diagnosa};
    return await db.insert('patiens_database', data);
  }

  // read
  static Future<List<Map<String, dynamic>>> getPatiens() async {
    final db = await SQLHelper.db();
    return db.query('patiens_database');
  }

  // update
  static Future<int> updatePatiens(
      int id, String nama, String ttl, String umur, String diagnosa) async {
    final db = await SQLHelper.db();

    final data = {'nama': nama, 'ttl': ttl, 'umur': umur, 'diagnosa': diagnosa};
    return await db.update('patiens_database', data, where: "id = $id");
  }

  // delete
  static Future<void> deletePatien(int id) async {
    final db = await SQLHelper.db();
    await db.delete('patiens_database', where: "id = $id");
  }
}
