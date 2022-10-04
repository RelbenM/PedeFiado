// ignore_for_file: prefer_const_declarations

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {

   static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      """);
  }
// id: indentificador do cliente
// nome, tel, endereço: informações de contato para o cliente
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    final sqlDebtors = """CREATE TABLE debtors(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        firstname TEXT,
        lastname TEXT,
        phone TEXT,
        address TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )""";

    final sqlDebts = """CREATE TABLE debt(
        debt_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        product TEXT,
        price TEXT,
        status TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )""";
    //FOREIGN KEY(debtors_fk) references debtors(id)
    return sql.openDatabase(
      'pedefiado.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await database.execute(sqlDebtors);
        await database.execute(sqlDebts);
      },
    );
  }

  /* <!-- Debtors --> */

  // Create new Debtor
  static Future<int> createItem(String? firstname, String? lastname,
      String? phone, String? address) async {
    final db = await DatabaseHelper.db();

    final data = {
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'address': address
    };
    final id = await db.insert('debtors', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DatabaseHelper.db();
    return db.query('debtors', orderBy: "id");
  }

  // Get a single item by id
  //We dont use this method, it is for you if you want it.
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await DatabaseHelper.db();
    return db.query('debtors', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(int id, String? firstname, String? lastname,
      String? phone, String? address) async {
    final db = await DatabaseHelper.db();

    final data = {
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'address': address,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('debtors', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete("debtors", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  /* <!-- Debts --> */

  //Create new debt
  static Future<int> createDebt(
      String? product, String? price, String? status) async {
    final db = await DatabaseHelper.db();

    final data = {'product': product, 'price': price, 'status': status};
    final debt_id = await db.insert('debt', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return debt_id;
  }

  // Get a single item by id
  //We dont use this method, it is for you if you want it.
  static Future<List<Map<String, dynamic>>> getDebts(int debt_id) async {
    final db = await DatabaseHelper.db();
    return db.query('debt',
        where: "debt_id = ?", whereArgs: [debt_id], limit: 1);
  }

   static Future<List<Map<String, dynamic>>> getDebt() async {
    final db = await DatabaseHelper.db();
    return db.query('debt', orderBy: "debt_id");
  }

  // Update an item by id
  static Future<int> updateDebt(
      int debt_id, String? product, String? price, String? status) async {
    final db = await DatabaseHelper.db();

    final data = {
      'product': product,
      'price': price,
      'status': status,
      'createdAt': DateTime.now().toString()
    };

    final result = await db
        .update('debt', data, where: "debt_id = ?", whereArgs: [debt_id]);
    return result;
  }

  // Delete
  static Future<void> deleteDebt(int debt_id) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete("debt", where: "debt_id = ?", whereArgs: [debt_id]);
    } catch (err) {
      debugPrint("Algo deu errado ao deletar o produto: $err");
    }
  }
}
