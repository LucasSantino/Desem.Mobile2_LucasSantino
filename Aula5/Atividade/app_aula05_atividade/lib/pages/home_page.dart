import 'package:app_aula05_atividade/data/aluno.dao.dart';
import 'package:app_aula05_atividade/models/aluno.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dao = AlunoDao(); // classe que vai permitir fazer o crud no banco de dados
  final _nomeCtrl = TextEditingController();
  final _disciplinaCtrl = TextEditingController();
  final _notaCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();

  Aluno? _editing; // Variável para verificar se o aluno está sendo editado
  Future<List<Aluno>>? _futureAlunos;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() {
      final q = _searchCtrl.text.trim();
      _futureAlunos = q.isEmpty ? _dao.getAll() : _dao.searchByName(q);
    });
  }

  void _clearForm() {
    _nomeCtrl.clear();
    _disciplinaCtrl.clear();
    _notaCtrl.clear();
    _editing = null;
  }

  void _edit(Aluno aluno) {
    setState(() {
      _editing = aluno;
      _nomeCtrl.text = aluno.nomeAluno;
      _disciplinaCtrl.text = aluno.disciplina;
      _notaCtrl.text = aluno.nota.toString();
    });
  }

  Future<void> _save() async {
    final nome = _nomeCtrl.text.trim();
    final disciplina = _disciplinaCtrl.text.trim();
    final notaStr = _notaCtrl.text.trim();

    if (nome.isEmpty || disciplina.isEmpty || notaStr.isEmpty) {
      _snack('Preencha todos os campos');
      return;
    }

    final nota = double.tryParse(notaStr);
    if (nota == null) {
      _snack('Nota precisa ser um número válido');
      return;
    }

    if (_editing == null) {
      await _dao.insert(Aluno(nomeAluno: nome, disciplina: disciplina, nota: nota));
      _snack('Aluno cadastrado');
    } else {
      await _dao.update(
        _editing!.copyWith(nomeAluno: nome, disciplina: disciplina, nota: nota),
      );
      _snack('Aluno atualizado');
    }
    _clearForm();
    _reload();
  }

  Future<void> _delete(int id) async {
    await _dao.delete(id);
    _snack('Aluno removido');
    _reload();
  }

  void _cancelEdit() {
    _clearForm();
    _snack('Edição cancelada');
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _disciplinaCtrl.dispose();
    _notaCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editing != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Alunos - sqflite'),
      ),
      body: Column(
        children: [
          // Campo de busca
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                labelText: 'Busca por nome',
                hintText: 'Ex: Lucas Santino',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    _searchCtrl.clear();
                    _reload();
                  },
                  tooltip: 'Limpar busca',
                  icon: const Icon(Icons.clear),
                ),
              ),
              onChanged: (_) => _reload(),
            ),
          ),

          // Formulário de cadastro
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _nomeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nome do aluno',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _disciplinaCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Disciplina',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _notaCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nota',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _save,
                      icon: Icon(isEditing ? Icons.save : Icons.add),
                      label: Text(isEditing ? 'Salvar alterações' : 'Adicionar'),
                    ),
                  ),
                  if (isEditing) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _cancelEdit,
                        icon: const Icon(Icons.close),
                        label: const Text('Cancelar'),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),

          const Divider(height: 0),

          // Lista de alunos
          Expanded(
            child: FutureBuilder<List<Aluno>>(
              future: _futureAlunos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }

                final alunos = snapshot.data ?? [];
                if (alunos.isEmpty) {
                  return const Center(child: Text('Nenhum aluno encontrado.'));
                }

                return ListView.builder(
                  itemCount: alunos.length,
                  itemBuilder: (context, index) {
                    final aluno = alunos[index];
                    return ListTile(
                      title: Text(aluno.nomeAluno),
                      subtitle: Text(
                          'Disciplina: ${aluno.disciplina} | Nota: ${aluno.nota}'),
                      leading:
                          CircleAvatar(child: Text((aluno.id ?? 0).toString())),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Editar',
                            icon: const Icon(Icons.edit),
                            onPressed: () => _edit(aluno),
                          ),
                          IconButton(
                            tooltip: 'Excluir',
                            icon: const Icon(Icons.delete),
                            onPressed: () => _delete(aluno.id!),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
