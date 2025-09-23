import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtr = TextEditingController();
  final _passCtr = TextEditingController();
  bool loading = false;
  final String baseUrl = 'http://10.0.2.2:3000'; // ajuste conforme seu ambiente

  Future<void> _login() async {
    setState(() => loading = true);
    try {
      final uri = Uri.parse('$baseUrl/usuario');
      final resp = await http.get(uri);
      if (resp.statusCode == 200) {
        final List users = jsonDecode(resp.body) as List;
        final found = users.firstWhere(
          (u) => u['email'] == _emailCtr.text && u['password'] == _passCtr.text,
          orElse: () => null,
        );
        if (found != null) {
          // login ok
          Navigator.pushReplacementNamed(context, '/');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Credenciais inválidas')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro no servidor')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtr.dispose();
    _passCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _emailCtr, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 8),
            TextField(controller: _passCtr, decoration: const InputDecoration(labelText: 'Senha'), obscureText: true),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loading ? null : _login,
              child: loading ? const CircularProgressIndicator() : const Text('Entrar'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Criar conta'),
            ),
          ],
        ),
      ),
    );
  }
}
