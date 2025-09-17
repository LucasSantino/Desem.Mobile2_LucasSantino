import 'package:flutter/material.dart';
import 'package:appdeliverytb/ui/widgets/home/home_Screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  LoginScreen({super.key});

  // Função para padronizar campos de texto
  InputDecoration customInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey), // linha cinza
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue), // linha azul ao focar
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo no topo
            Image.asset(
              'assets/logo.png',
              width: 160,
            ),
            const SizedBox(height: 40),

            // Campo de email
            TextField(
              controller: emailController,
              decoration: customInputDecoration("E-mail", Icons.email),
            ),
            const SizedBox(height: 16),

            // Campo de senha
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: customInputDecoration("Senha", Icons.lock),
            ),
            const SizedBox(height: 24),

            // Botão de login
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String email = emailController.text.trim();
                  String senha = senhaController.text.trim();

                  // Aqui você coloca sua lógica de login
                  if (email.isNotEmpty && senha.isNotEmpty) {
                    // Exemplo simples: vai direto para HomeScreen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Preencha email e senha"),
                      ),
                    );
                  }
                },
                child: const Text("Entrar"),
              ),
            ),

            const SizedBox(height: 12),

            // Link para cadastro
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/cadastro");
              },
              child: const Text("Não tem conta? Cadastre-se"),
            ),
          ],
        ),
      ),
    );
  }
}
