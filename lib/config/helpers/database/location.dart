import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:weather_app/infrastructure/models/location_model.dart';

class LocationDB {
  static const nameDB = 'Agenda';
  static int versionDB = 1;

  static Database? _database;

  Future<Database?> get getDatabase async {
    if( _database != null ) return _database!;
    return _database = await _initDatabase();
  }
  
  Future<Database?> _initDatabase() async {

    Directory folder = await getApplicationDocumentsDirectory();
    String pathDB = join(folder.path, nameDB);
    return openDatabase(
      pathDB,
      version: versionDB,
      onCreate: _createTables
    );
  }

  FutureOr<void> _createTables (Database db, int version) {
      String query = '''create table tblLocations(
                          idLocation integer primary key,
                          latitude double,
                          longitude duble,
                          name varchar(50),
                          icon varchar(10),
                          temp double
                        );''';
      db.execute(query);
    }

  Future<int> insert(Map<String, dynamic> data) async {
    var connection = await getDatabase;

    return connection!.insert('tblLocations', data);
  }

  Future<int> delete(int id) async {
    var connection = await getDatabase;
    return connection!.delete('tblLocations',
                              where: 'id = ?', 
                              whereArgs: [id]);
  }

  Future<List<LocationModel>> getAllLocations() async {
    var connection = await getDatabase;
    var result = await connection!.query('tblLocations');

    return result.map((location) => LocationModel.fromJson(location)).toList();
  }
    
}