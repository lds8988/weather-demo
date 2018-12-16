import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weather_demo/pojo/city.dart';

class CityDao {
  static const String DB_NAME = "weather.db";

  static const String TABLE_NAME = "city";

  static const String COLUMN_NAME = "name";

  static const String COLUMN_CID = "cid";

  static const String COLUMN_PARENT_CITY = "parent_city";

  static const String COLUMN_ADMIN_AREA = "admin_area";

  static const String COLUMN_CNTY = "cnty";

  Database db;

  Future<String> getDatabasePath() async {
    String databasesPath = await getDatabasesPath();
    return join(databasesPath, DB_NAME);
  }

  Future open() async {
    String path = await getDatabasePath();
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("create table city (" +
          "_id integer primary key autoincrement," +
          "$COLUMN_NAME text not null," +
          "$COLUMN_CID text not null," +
          "$COLUMN_PARENT_CITY text not null," +
          "$COLUMN_ADMIN_AREA text not null," +
          "$COLUMN_CNTY text not null" +
          ")");
    });
  }

  Future<bool> insert(City city) async {
    City cityInDb = await get(city.cid);

    if(cityInDb == null) {
      await db.insert(TABLE_NAME, city.toMap());
      return true;
    }

    return false;
  }

  Future<City> get(String cid) async {
    print(db);
    List<Map> maps = await db.query(TABLE_NAME,
        columns: [COLUMN_NAME, COLUMN_CID, COLUMN_PARENT_CITY, COLUMN_ADMIN_AREA, COLUMN_CNTY],
        where: '$COLUMN_CID = ?',
        whereArgs: [cid]);

    if (maps.length > 0) {
      return City.fromMap(maps.first);
    }
    return null;
  }
  
  Future<List<City>> getAll() async {

    List<Map> maps = await db.rawQuery("SELECT * FROM $TABLE_NAME");

    List<City> cityList = List();

    for(int i = 0; i < maps.length; i++) {
      City city = City.fromMap(maps[i]);
      cityList.add(city);
    }

    return cityList;
  }

  Future<int> delete(String cid) async {
    return await db.delete(TABLE_NAME, where: '$COLUMN_CID = ?', whereArgs: [cid]);
  }

  Future close() async => db.close();
}
