// Classe Aluno para armazenar os dados de cadastro
class Aluno {
  final int? id; // nulo ao criar (autoincrement)
  final String nomeAluno; // nome do aluno
  final String disciplina; // nome da disciplina
  final double nota; // nota do aluno na disciplina

  // Construtor
  Aluno({
    this.id,
    required this.nomeAluno,
    required this.disciplina,
    required this.nota,
  });

  // Função que copia os parâmetros da classe (usada para atualizações)
  Aluno copyWith({
    int? id,
    String? nomeAluno,
    String? disciplina,
    double? nota,
  }) {
    return Aluno(
      id: id ?? this.id,
      nomeAluno: nomeAluno ?? this.nomeAluno,
      disciplina: disciplina ?? this.disciplina,
      nota: nota ?? this.nota,
    );
  }

  // Converte a classe para Map (usado no sqflite)
  Map<String, dynamic> toMap() => {
        'id': id,
        'nomeAluno': nomeAluno,
        'disciplina': disciplina,
        'nota': nota,
      };

  // Cria um objeto Aluno a partir de um Map (usado ao buscar no banco)
  factory Aluno.fromMap(Map<String, dynamic> map) => Aluno(
        id: map['id'] as int?,
        nomeAluno: map['nomeAluno'] as String,
        disciplina: map['disciplina'] as String,
        nota: map['nota'] is int
            ? (map['nota'] as int).toDouble()
            : map['nota'] as double,
      );
}
