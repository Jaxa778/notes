import 'package:notes/models/note_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  LocalDatabase._();

  static final _yagona = LocalDatabase._();

  factory LocalDatabase() {
    return _yagona;
  }

  final String tableName = "notes";

  Database? _database;

  Future<void> init() async {
    _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getApplicationDocumentsDirectory();
    // C:Salom/Documents/todos.db
    final path = "${databasePath.path}/$tableName.db";
    return openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute("""CREATE TABLE $tableName(
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     remainder TEXT NOT NULL,
     date TEXT NOT NULL,
     level TEXT DEFAULT 'midle'
    )""");
  }

  Future<List<NoteModel>> get() async {
    final data = await _database?.query(tableName);

    List<NoteModel> notes = [];

    if (data != null) {
      for (var note in data) {
        notes.add(NoteModel.fromMap(note));
      }
    }
    return notes;
  }

  Future<int?> insert(NoteModel note) async {
    return await _database?.insert(tableName, note.toMap());
  }

  Future<void> update(NoteModel note) async {
    await _database?.update(
      tableName,
      note.toMap(),
      where: "id=?",
      whereArgs: [note.id],
    );
  }

  Future<void> delete(int id) async {
    await _database?.delete(tableName, where: "id=?", whereArgs: [id]);
  }

  Future<void> close() async {
    _database?.close();
  }
}
