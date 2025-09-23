import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtr = TextEditingController();
  final _emailCtr = TextEditingController();
  final _passCtr = TextEditingController();
  bool loading = false;
  final String baseUrl = 'http://10.0.2.2:3000'; // ajuste conforme seu ambiente

  Future<void> _register() async {
    if (_emailCtr.text.isEmpty || _passCtr.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha todos os campos')));
      return;
    }
    setState(() => loading = true);
    try {
      final uri = Uri.parse('$baseUrl/cadastro-usuario');
      final resp = await http.post(uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'name': _nameCtr.text, 'email': _emailCtr.text, 'password': _passCtr.text}));
      if (resp.statusCode == 201 || resp.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cadastro realizado com sucesso')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro cadastro: ${resp.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    _nameCtr.dispose();
    _emailCtr.dispose();
    _passCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _nameCtr, decoration: const InputDecoration(labelText: 'Nome')),
            const SizedBox(height: 8),
            TextField(controller: _emailCtr, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 8),
            TextField(controller: _passCtr, decoration: const InputDecoration(labelText: 'Senha'), obscureText: true),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: loading ? null : _register, child: loading ? const CircularProgressIndicator() : const Text('Cadastrar')),
          ],
        ),
      ),
    );
  }
}
