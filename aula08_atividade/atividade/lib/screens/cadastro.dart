import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = "";

  // Função para fazer o cadastro
  Future<void> _cadastrar() async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    // Verifica se os campos não estão vazios
    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Por favor, preencha todos os campos!";
      });
      return;
    }

    // Verifica se a senha e a confirmação são iguais
    if (password != confirmPassword) {
      setState(() {
        _isLoading = false;
        _errorMessage = "As senhas não coincidem!";
      });
      return;
    }

    try {
      // URL do JSON Server - ajuste conforme sua configuração
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/usuarios')
, // Altere para o seu endpoint
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        // Cadastro bem-sucedido
        // Redireciona para a tela de Login
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        // Se não for 201 (Created), exibe uma mensagem de erro
        setState(() {
          _isLoading = false;
          _errorMessage = "Erro ao cadastrar o usuário.";
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Erro ao conectar com o servidor.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Usuário',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Confirmar Senha',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            if (_isLoading)
              CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _cadastrar,
                child: Text('Cadastrar'),
              ),
            SizedBox(height: 16),
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
