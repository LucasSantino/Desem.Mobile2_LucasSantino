import 'package:app_aula05_atividade/data/app_database.dart';
import 'package:app_aula05_atividade/models/aluno.dart';
import 'package:sqflite/sqflite.dart';

class AlunoDao {
  static const table = 'alunos'; // nome da tabela no banco de dados

  // Método para inserir um aluno no banco
  Future<int> insert(Aluno aluno) async {
    final db = await AppDatabase.instance.database;
    return db.insert(
      table,
      aluno.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Método para listar todos os alunos cadastrados
  Future<List<Aluno>> getAll() async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query(table, orderBy: 'id DESC');
    return maps.map((m) => Aluno.fromMap(m)).toList();
  }

  // Método para atualizar um aluno já cadastrado
  Future<int> update(Aluno aluno) async {
    final db = await AppDatabase.instance.database;
    return db.update(
      table,
      aluno.toMap(),
      where: 'id = ?',
      whereArgs: [aluno.id],
    );
  }

  // Método para deletar um aluno pelo ID
  Future<int> delete(int id) async {
    final db = await AppDatabase.instance.database;
    return db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Método de busca por nome de aluno
  Future<List<Aluno>> searchByName(String query) async {
    final db = await AppDatabase.instance.database;
    final maps = await db.query(
      table,
      where: 'nomeAluno LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'nomeAluno ASC',
    );
    return maps.map((m) => Aluno.fromMap(m)).toList();
  }
}
