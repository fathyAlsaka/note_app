import 'package:flutter/widgets.dart';
import 'package:notes_app/models/database/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NotesDatabase {
  static Future<String> getDBPath() async {
    var databasePath = await getDatabasesPath();
    return join(databasePath, "notes.db");
  }

  static createDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    String path = await getDBPath();
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute(
            'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,content TEXT,creationDate TEXT, modifyDate TEXT)');
      },
    );
  }

  static createNote(Note note) async {
    final db = await createDB();
    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Note>> notes() async {
    final db = await createDB();
    final List<Map<String, dynamic>> maps = await db.query('notes');

    return List.generate(maps.length, (i) {
      return Note(
          id: maps[i]['id'],
          title: maps[i]['title'],
          content: maps[i]['content'],
          creationDate: maps[i]['creationDate'],
          modifyDate: maps[i]['modifyDate']);
    });
  }

  static updateNote(Note note) async {
    final db = await createDB();

    await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  static Future<void> deleteNote(int id) async {
    final db = await createDB();

    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
