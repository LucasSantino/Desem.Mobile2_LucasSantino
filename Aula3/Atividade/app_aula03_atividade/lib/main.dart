import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(TelaHome());
}

class TelaHome extends StatelessWidget {
  const TelaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App SharedPreferences',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color.fromARGB(255, 111, 159, 199),
        scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 5, 24, 44),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
            side: BorderSide(color: const Color.fromARGB(255, 252, 252, 252)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          contentTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      home: TelaApp(),
    );
  }
}

class TelaApp extends StatefulWidget {
  const TelaApp({super.key});

  @override
  State<TelaApp> createState() => _TelaAppState();
}

class _TelaAppState extends State<TelaApp> {
  final _ctrlNome = TextEditingController();
  final _ctrlIdade = TextEditingController();
  final _ctrlEndereco = TextEditingController();
  final _ctrlRG = TextEditingController();
  List<String> _registros = [];

  static const String _kRegistros = 'registros';

  @override
  void initState() {
    super.initState();
    _carregarRegistros();
  }

  @override
  void dispose() {
    _ctrlNome.dispose();
    _ctrlIdade.dispose();
    _ctrlEndereco.dispose();
    _ctrlRG.dispose();
    super.dispose();
  }

  Future<void> _salvarRegistro() async {
    final prefs = await SharedPreferences.getInstance();
    final nome = _ctrlNome.text.trim();
    final idade = _ctrlIdade.text.trim();
    final endereco = _ctrlEndereco.text.trim();
    final rg = _ctrlRG.text.trim();

    if (nome.isEmpty || idade.isEmpty || endereco.isEmpty || rg.isEmpty) {
      _snack('Preencha nome, idade, endereço e RG');
      return;
    }

    if (int.tryParse(idade) == null) {
      _snack('Idade inválida');
      return;
    }

    final registro = '$nome:$idade:$endereco:$rg';
    final atuais = prefs.getStringList(_kRegistros) ?? [];

    if (atuais.contains(registro)) {
      _snack('Esse registro já existe');
      return;
    }

    atuais.add(registro);
    await prefs.setStringList(_kRegistros, atuais);

    setState(() => _registros = List<String>.from(atuais));
    _ctrlNome.clear();
    _ctrlIdade.clear();
    _ctrlEndereco.clear();
    _ctrlRG.clear();
    _snack('Registro salvo com sucesso!');
  }

  Future<void> _carregarRegistros() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _registros = prefs.getStringList(_kRegistros) ?? []);
  }

  Future<void> _removerRegistro(String registro) async {
    final prefs = await SharedPreferences.getInstance();
    final atuais = prefs.getStringList(_kRegistros) ?? [];
    atuais.remove(registro);
    await prefs.setStringList(_kRegistros, atuais);
    setState(() => _registros = List<String>.from(atuais));
    _snack('Registro removido: $registro');
  }

  Future<void> _limparTudo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kRegistros);
    setState(() => _registros = []);
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App SharedPreferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Digite nome, idade, endereço e RG e salve localmente',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _ctrlNome,
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 12),
            TextField(
              controller: _ctrlIdade,
              decoration: InputDecoration(
                labelText: 'Idade',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 12),
            TextField(
              controller: _ctrlEndereco,
              decoration: InputDecoration(
                labelText: 'Endereço',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 12),
            TextField(
              controller: _ctrlRG,
              decoration: InputDecoration(
                labelText: 'RG',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _salvarRegistro(),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _salvarRegistro,
                    icon: Icon(Icons.save),
                    label: Text('Salvar'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _carregarRegistros,
                    icon: Icon(Icons.refresh),
                    label: Text('Carregar'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _registros.isEmpty ? null : _limparTudo,
                    icon: Icon(Icons.delete),
                    label: Text('Remover Todos'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: _registros.isEmpty
                  ? Center(child: Text('Sem registros salvos'))
                  : ListView.separated(
                      itemCount: _registros.length,
                      separatorBuilder: (_, __) => Divider(height: 1),
                      itemBuilder: (context, i) {
                        final registro = _registros[i];
                        final partes = registro.split(':');
                        final nome = partes[0];
                        final idade = partes[1];
                        final endereco = partes[2];
                        final rg = partes[3];

                        return Dismissible(
                          key: ValueKey(registro),
                          background: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(Icons.delete),
                          ),
                          secondaryBackground: Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(Icons.delete),
                          ),
                          onDismissed: (_) => _removerRegistro(registro),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(nome.isNotEmpty
                                  ? nome[0].toUpperCase()
                                  : '?'),
                            ),
                            title: Text('$nome (idade: $idade)'),
                            subtitle: Text('Endereço: $endereco\nRG: $rg'),
                            trailing: IconButton(
                              onPressed: () => _removerRegistro(registro),
                              icon: Icon(Icons.delete),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text('Total: ${_registros.length}'),
            ),
          ],
        ),
      ),
    );
  }
}
