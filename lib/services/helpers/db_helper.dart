/*import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'debts.dart';
 
class DBHelper {
  static late Database _db;
  static const String Debt_id = 'deb_id';
  static const String Product = 'product';
  static const String Price = 'price';
  static const String Fk_debtor = 'fk_debtor';
  static const String TABLE = 'debt';
  static const String DB_NAME = 'pedefiado.db';
 
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }
 
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }
 
  _onCreate(Database db, int version) async {
    await db
        .execute("CREATE TABLE $TABLE ($Debt_id INTEGER PRIMARY KEY, $Product TEXT, $Price REAL, $Fk_debtor INTEGER)");
  }
 
  Future<Debts> save(Debts debts) async {
    var dbClient = await db;
    debts.debt_id = await dbClient.insert(TABLE, debts.toMap());
    return debts;
    /*
    await dbClient.transaction((txn) async {
      var query = "INSERT INTO $TABLE ($NAME) VALUES ('" + employee.name + "')";
      return await txn.rawInsert(query);
    });
    */
  }
 
   Future<List<Employee>> getEmployees() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Employee> employees = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        employees.add(Debts.fromMap(maps[i]));
      }
    }
    return employees;
  }
 
 
  Future<int> deleteDebt(int debt_id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$Debt_id = ?', whereArgs: [debt_id]);
  }
 
  Future<int> updateDebt(Debts debts) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, debts.toMap(),
        where: '$Debt_id = ?', whereArgs: [debts.debt_id]);
  }
 
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}*/