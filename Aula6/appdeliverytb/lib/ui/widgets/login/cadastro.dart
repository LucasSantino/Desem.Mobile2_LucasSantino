import 'package:flutter/material.dart';

class CadastroScreen extends StatelessWidget {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController = TextEditingController();

  CadastroScreen({super.key});


  InputDecoration customInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey), 
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue), 
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo do app
                Image.asset(
                  'assets/logo.png',
                  width: 160,
                ),
                const SizedBox(height: 40),

                // Campo de nome
                TextField(
                  controller: nomeController,
                  decoration: customInputDecoration("Nome", Icons.person),
                ),
                const SizedBox(height: 16),

                
                TextField(
                  controller: emailController,
                  decoration: customInputDecoration("E-mail", Icons.email),
                ),
                const SizedBox(height: 16),

                
                TextField(
                  controller: senhaController,
                  obscureText: true,
                  decoration: customInputDecoration("Senha", Icons.lock),
                ),
                const SizedBox(height: 16),

               
                TextField(
                  controller: confirmarSenhaController,
                  obscureText: true,
                  decoration: customInputDecoration("Confirmar Senha", Icons.lock_outline),
                ),
                const SizedBox(height: 24),

                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (senhaController.text == confirmarSenhaController.text) {
                        Navigator.pushReplacementNamed(context, "/home");
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("As senhas não coincidem")),
                        );
                      }
                    },
                    child: const Text("Cadastrar"),
                  ), 
                ),

                const SizedBox(height: 12),

                
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, "/login");
                  },
                  child: const Text("Já tem conta? Faça login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
