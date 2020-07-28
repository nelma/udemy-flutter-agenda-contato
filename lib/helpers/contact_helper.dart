import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String contactTable = "contactTable";

//Definindo nome das colunas
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

class ContactHelper {
  //var de classe
  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  //criando um construtor interno
  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDb();
    return _db;
  }

  initDb() async {
    final dataBasesPath = await getDatabasesPath();
    final path = join(dataBasesPath, "contactsnew.db");

    String sql =
        "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT,"
        "$phoneColumn TEXT, $imgColumn TEXT)";

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(sql);
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;

    contact.id = await dbContact.insert(contactTable, contact.toMap());
  }

  Future<Contact> getContact(int id) async {
    Database dbContact = await db;

    List<Map> maps = await dbContact.query(contactTable,
        columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
        where: "$idColumn = ?",
        whereArgs: [id]);

    if(maps.length == 0) {
      return null;
    }

    return Contact.fromMap(maps.first);
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await db;

    return await dbContact.delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async{
    Database dbContact = await db;

    return await dbContact.update(contactTable, contact.toMap(), where: "$idColumn = ?", whereArgs: [contact.id]);
  }

  Future<List> getAllContacts() async{
    Database dbContact = await db;

    String query = "SELECT * FROM $contactTable";

    List listMap = await dbContact.rawQuery(query);
    List<Contact> listContact = List();
    for(Map map in listMap) {
      listContact.add(Contact.fromMap(map));
    }
    return listContact;
  }

  Future<int> getNumber() async {
    Database dbContact = await db;

    String query = "SELECT COUNT(*) FROM $contactTable";
    return Sqflite.firstIntValue(await dbContact.rawQuery(query));
  }

  Future close() async {
    Database dbContact = await db;
    dbContact.close();
  }

}

//Definir o que o Contato vai armazenar
class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact();

  //recevbe os dados armazenados
  Contact.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  }

  //armazena em formato dde mapa
  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };

    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }
}
