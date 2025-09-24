import 'package:flutter/material.dart';
import 'screens/login.dart'; // Tela de Login
import 'screens/cadastro.dart'; // Tela de Cadastro
import 'screens/home.dart'; // Tela de Home

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'S&M Hotel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/cadastro': (context) => CadastroScreen(),
        '/home': (context) => Home(),
      },
    );
  }
}
