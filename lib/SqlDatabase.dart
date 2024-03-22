import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Note {
  final int? id;
  final String title;
  final String content;
  Note({
     this.id,
    required this.title,
    required this.content,
  });
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'content': content};
  }
}

class ToDo {
  final int ?id;
  final String title;
  final int ?value; //checked if the task is done or not ..
  ToDo({
     this.id,
    required this.title,
     this.value=0,
  });
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'value': value};
  }
}

class SqlHelper {
  Database? database;
  Future getDatabase() async {
    if (database != null) return database;
    database = await initDatabase();
    return database;
  }

  // create database
  Future initDatabase() async {
    // path of my database
    String path = join(await getDatabasesPath(),
        'my_database.db'); //  database path /my_database.db
    return await openDatabase(path, version: 1,
        // onUpgrade:(){} ,// works when I upgrade my version and when this on create

        onCreate: (Database db, int version) async {
      // works only one time
      Batch batch = db.batch();
      batch.execute('''
      CREATE TABLE Notes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      content TEXT
      )
      ''');

      batch.execute('''
      CREATE TABLE Todo(
      id INTEGER PRIMARY KEY,
      title TEXT,
      value INTEGER
      )
      ''');
      batch.commit(); //must be written to execute the batch statement
    });
  }

  Future insertNote(Note note) async {
    Database db = await getDatabase();
    Batch batch = db.batch();
    batch.insert(
      'Notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    batch.commit();
  }

  Future insertTodo(ToDo todo) async {
    Database db = await getDatabase();
    Batch batch = db.batch();
    batch.insert(
      'Todo',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    batch.commit();
  }

  // Read
  Future<List<Map>>loadNote() async {
    Database db = await getDatabase();
    List<Map> maps = await db.query(
        'Notes'); // return list of maps -----> goal : convert list of map to notes than can be viewed in our UI
    // List<Map> generatedList = [];
    // for (int i = 0; i < maps.length; i++) {
    //   Map<String, dynamic> generatedMap = {
    //     'id': maps[i]['id'],
    //     'title': maps[i]['title'],
    //     'content': maps[i]['content'],
    //   };
    //   generatedList.add(generatedMap);
    // }
    // return generatedList;
    return List.generate(maps.length, (index) {
      return Note(
        id: maps[index]['id'],
        title: maps[index]['title'],
        content: maps[index]['content'],
      ).toMap();
    });
  }

  Future<List<Map>>loadToDo() async {
    Database db = await getDatabase();
    List<Map> maps = await db.query(
        'Todo'); // return list of maps -----> goal : convert list of map to notes than can be viewed in our UI
    return List.generate(maps.length, (index) {
      return ToDo(
        id: maps[index]['id'],
        title: maps[index]['title'],
        value: maps[index]['value'],
      ).toMap();
    });
  }

  // Update
  Future updateNote(Note note) async {
    Database db = await getDatabase();
    await db.update(
      'Notes',
      note.toMap(),
      where: 'id=?',
      whereArgs: [note.id],
    );
  }
  Future updateTodoChecked(int id, int val)async
  {
    Database db = await getDatabase();
    Map<String,dynamic>values={
      'value': val==0?1:0, // toggle the value from 0 to 1 or from 1 to 0 to indicate the todo is done or not
    };
    await db.update('Todo',
      values,
      where: 'id=?',
      whereArgs: [id],
    );
  }

  // Delete

  Future deleteAllNotes() async {
    Database db = await getDatabase();
    await db.delete('Notes');
  }

  Future deleteAllTodos() async {
    Database db = await getDatabase();
    await db.delete('Todo');
  }

  Future deleteNote(int id) async {
    Database db = await getDatabase();
    await db.delete(
      'Notes',
      where: 'id=?',
      whereArgs: [id],
    );
  }
  Future deleteToDo(int id) async {
    Database db = await getDatabase();
    await db.delete(
      'Todo',
      where: 'id=?',
      whereArgs: [id],
    );
  }
}
