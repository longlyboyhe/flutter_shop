import 'dart:io';

import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

///放在Class内部会执行每个方法的时候都置空（可以在每个方法的开始就重新取一遍dbPath）
String dbPath;

///
/// 搜索历史记录数据库存储
/// @author longlyboyhe
/// @date 2019/2/28
///
class HistoryDb {
  String dbName = 'history.db';

  ///存储历史记录最多条数，如果超过就删除第一条
  static final int MAX_HISTORY_NUM = 10;

  ///数据库存储目录
  static final String SP_DISTORY_PATH = "distory_path ";

  String sql_createTable =
      'CREATE TABLE history_table (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL UNIQUE)';

  String sql_query_count = 'SELECT COUNT(*) FROM history_table';

  String sql_query = 'SELECT * FROM history_table';

  String sql_delete =
      'DELETE FROM history_table WHERE id IN (SELECT id FROM history_table LIMIT 1)';

  Future<String> _createNewDb(String dbName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print(documentsDirectory);

    String path = join(documentsDirectory.path, dbName);

    if (await Directory(dirname(path)).exists()) {
      await deleteDatabase(path);
    } else {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print(e);
      }
    }
    return path;
  }

  create() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String path = await sp.getString(SP_DISTORY_PATH);

    print('create = $path');
    if (path == null) {
      dbPath = await _createNewDb(dbName);
      sp.setString(SP_DISTORY_PATH, dbPath);
      Database db = await openDatabase(dbPath);

      await db.execute(sql_createTable);
      await db.close();
    } else {
      dbPath = path;
    }
    print('创建user.db成功，创建user_table成功 dbPath=$dbPath');
  }

  add(String name) async {
    try {
      String sql = "INSERT INTO history_table(name) VALUES('$name')";
      int num = await _queryNum();
      if (num >= MAX_HISTORY_NUM) {
        await _delete();
      }

      Database db = await openDatabase(dbPath);
      await db.transaction((txn) async {
        try {
          int id = await txn.rawInsert(sql);
        } catch (e) {
          print(e);
        }
      });

      await db.close();

      print("插入username=$name,pwd=$name数据成功");
    } catch (e) {
      print("插入数据失败=${e.toString()}");
    }
  }

  _delete() async {
    try {
      Database db = await openDatabase(dbPath);
      await db.execute(sql_delete);
      await db.close();
      print("删除数据成功");
    } catch (e) {
      print("删除数据失败=${e.toString()}");
    }
  }

  Future<int> _queryNum() async {
    try {
      Database db = await openDatabase(dbPath);
      int count = Sqflite.firstIntValue(await db.rawQuery(sql_query_count));
      await db.close();
      print("数据条数：$count");
      return count;
    } catch (e) {
      print("查询数据条数失败=${e.toString()}");
      return 0;
    }
  }

  Future<List<Map>> query() async {
    try {
      Database db = await openDatabase(dbPath);
      List<Map> list = await db.rawQuery(sql_query);
      await db.close();
      print("数据详情：$list");
      return list;
    } catch (e) {
      print("查询数据失败=${e.toString()}");
      return List();
    }
  }

  Future<int> clear() async {
    try {
      Database db = await openDatabase(dbPath);
      int num = await db.delete("history_table");
      await db.close();
      print("删除$num条数据成功");
      return num;
    } catch (e) {
      print("清空数据失败=${e.toString()}");
      return 0;
    }
  }
}
