import 'package:atividade/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para lidar com o JSON

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = "";

  // URL do servidor
  final String url = "http://10.109.83.13:3000/usuarios"; // Altere para a URL correta

  List clientes =<Usuarios>[];
  // Função para login
  Future<void> login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      // Realizando a requisição GET
      http.Response response = await http.get(Uri.parse(url));

      // Verifica se a resposta foi bem-sucedida
      if (response.statusCode == 200) {
        
        clientes = json.decode(response.body);
        bool encuser = false;
        print(clientes);

        // Verifica se algum usuário existe com o login e senha fornecidos
        for (int i = 0; i < clientes.length; i++) {
          if (_usernameController.text == clientes[i]["username"] &&
              _passwordController.text == clientes[i]["password"]) {
            encuser = true;
            break;
          }
        }

        if (encuser) {
          // Se o usuário foi encontrado, navega para a próxima tela
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );

          // Limpa os campos de login e senha
          _usernameController.clear();
          _passwordController.clear();
        } else {
          // Se o usuário não for encontrado, mostra mensagem de erro
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Usuário não cadastrado"),
              duration: Duration(seconds: 2),
            ),
          );

          // Exibe o alert dialog de erro
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text('Usuário ou senha inválidos'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Fechar'),
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Caso a requisição falhe
        setState(() {
          _errorMessage = "Erro ao conectar com o servidor";
        });
      }
    } catch (e) {
      // Caso ocorra uma exceção
      setState(() {
        _errorMessage = "Erro: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo de usuário
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Usuário',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Campo de senha
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Indicador de carregamento
            if (_isLoading)
              CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: login,
                child: Text('Entrar'),
              ),
            SizedBox(height: 16),

            // Exibe mensagens de erro, se houver
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

class Usuarios{
String id;
String login;
String senha;
Usuarios (this.id, this.login,this.senha);
factory Usuarios.fromJson (Map<String, dynamic> json){
return Usuarios (json["id"], json["login"],json["senha"]);
}
}