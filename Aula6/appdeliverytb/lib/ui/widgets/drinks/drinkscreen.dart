import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appdeliverytb/model/drinks.dart';
import 'package:appdeliverytb/ui/_core/app_colors.dart';
import 'package:appdeliverytb/ui/widgets/bag_provider.dart';

class DrinkScreen extends StatelessWidget {
  final List<Drink> drinks;

  const DrinkScreen({super.key, required this.drinks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bebidas"),
        backgroundColor: AppColors.mainColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: drinks.length,
        itemBuilder: (context, index) {
          final drink = drinks[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(drink.name),
              subtitle: Text(drink.description),
              trailing: FittedBox(
                fit: BoxFit.scaleDown, // força o ajuste no espaço disponível
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("R\$${drink.price.toString()}"),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        Provider.of<BagProvider>(context, listen: false)
                            .addDrink(drink);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("${drink.name} adicionado à sacola")),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
