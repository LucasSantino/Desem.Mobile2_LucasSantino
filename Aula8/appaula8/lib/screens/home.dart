import 'package:flutter/material.dart';
import 'package:appaula8/widgets/destino_widget.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista com 10 destinos com nome, asset, valor diária (valord) e valor por pessoa (valorp)
    final destinos = [
      {'nome': 'Angra dos Reis', 'img': 'assets/images/angra.jpg', 'valord': 384, 'valorp': 70},
      {'nome': 'Jericoacoara', 'img': 'assets/images/jericoacoara.jpg', 'valord': 571, 'valorp': 75},
      {'nome': 'Arraial do Cabo', 'img': 'assets/images/arraial.jpg', 'valord': 534, 'valorp': 65},
      {'nome': 'Florianópolis', 'img': 'assets/images/florianopolis.jpg', 'valord': 348, 'valorp': 85},
      {'nome': 'Madri', 'img': 'assets/images/madri.jpg', 'valord': 401, 'valorp': 85},
      {'nome': 'Paris', 'img': 'assets/images/paris.jpg', 'valord': 546, 'valorp': 95},
      {'nome': 'Orlando', 'img': 'assets/images/orlando.jpg', 'valord': 616, 'valorp': 105},
      {'nome': 'Las Vegas', 'img': 'assets/images/lasvegas.jpg', 'valord': 504, 'valorp': 110},
      {'nome': 'Roma', 'img': 'assets/images/roma.jpg', 'valord': 478, 'valorp': 85},
      {'nome': 'Chile', 'img': 'assets/images/chile.jpg', 'valord': 446, 'valorp': 95},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('S&M Hotel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/checkout');
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: destinos.length,
        itemBuilder: (context, i) {
          final d = destinos[i];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: DestinoWidget(
              nome: d['nome'] as String,
              imagePath: d['img'] as String,
              valord: d['valord'] as int,
              valorp: d['valorp'] as int,
            ),
          );
        },
      ),
    );
  }
}