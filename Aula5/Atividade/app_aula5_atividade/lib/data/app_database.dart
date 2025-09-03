import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// classe que inicializa o banco de dados
class AppDatabase {
  // Singleton
  AppDatabase._internal();
  static final AppDatabase instance = AppDatabase._internal();

  static const _dbName = 'alunos.db'; // nome do banco de dados
  static const _dbVersion = 1;

  Database? _db;

  // Getter para retornar o banco (abre se ainda não foi aberto)
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  // Método para abrir/criar o banco de dados
  Future<Database> _open() async {
    final dbPath = await getDatabasesPath(); 
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        // Criar tabela de alunos
        await db.execute('''
          CREATE TABLE alunos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            matricula TEXT NOT NULL
          )
        ''');

        // Criar tabela de disciplinas
        await db.execute('''
          CREATE TABLE disciplinas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL
          )
        ''');

        // Criar tabela de notas
        await db.execute('''
          CREATE TABLE notas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            aluno_id INTEGER NOT NULL,
            disciplina_id INTEGER NOT NULL,
            nota REAL NOT NULL,
            FOREIGN KEY (aluno_id) REFERENCES alunos (id) ON DELETE CASCADE,
            FOREIGN KEY (disciplina_id) REFERENCES disciplinas (id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }
}
