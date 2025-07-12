import 'package:drip_store/model/data/detail_product_model.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseService {
  static const String _dbName = 'drip_store.db';
  static const String _tableName = 'products';
  static const int _databaseVersion = 1;

  Future<void> createTables(Database database) async {
    await database.execute(
    """ 
      CREATE TABLE $_tableName(
        id INTEGER PRIMARY KEY,
        name TEXT,
        name_product TEXT,
        price TEXT,
        description TEXT,
        category TEXT,
        quantity INTEGER,
        image TEXT,
        name_store TEXT,
        store_id INTEGER,
        logo TEXT,
        user_id INTEGER,
        product_sizes TEXT
      )
    """);
  }

  Future<Database>_intializeDb() async {
    return openDatabase(
      _dbName,
      version: _databaseVersion,
      onCreate: (Database database, int version) async {
        await createTables(database);
      }
    );
  }

  Future<int> insertItem(DetailProductModel product, int userId) async {
    final db = await _intializeDb();

    final data = product.toJson();
    data['user_id'] = userId;
    final id = await db.insert(_tableName, data, conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  Future<List<DetailProductModel>> getAllProducts(int userId) async {
    final db = await _intializeDb();
    final results = await db.query(
      _tableName,
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return results.map((product)=> DetailProductModel.fromJson(product)).toList();
  }

  Future<DetailProductModel> getDataId(int id) async {
    final db = await _intializeDb();
    final results = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return results.map((product)=> DetailProductModel.fromJson(product)).first;
  }

  Future<String> removeItem(int id) async {
    final db = await _intializeDb();
    final results = await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.toString();
  }
}