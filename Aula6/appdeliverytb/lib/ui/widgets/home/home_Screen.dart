import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appdeliverytb/ui/widgets/home/widgets/category_widget.dart';
import 'package:appdeliverytb/ui/widgets/drinks/drinkscreen.dart';
import 'package:appdeliverytb/data/categories_data.dart';
import 'package:appdeliverytb/data/restaurant_data.dart';
import 'package:appdeliverytb/model/drinks.dart';
import 'package:appdeliverytb/ui/_core/app_colors.dart';
import 'package:appdeliverytb/ui/widgets/home/widgets/restaurant_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RestaurantData restaurantData = Provider.of<RestaurantData>(context);

    // Lista de bebidas sem imagens
    List<Drink> drinks = [
      Drink(
          id: "1",
          name: "Coca-Cola",
          description: "Refrigerante 350ml",
          price: 5,
          imagePath: ""),
      Drink(
          id: "2",
          name: "Fanta",
          description: "Refrigerante 350ml",
          price: 4,
          imagePath: ""),
    ];

    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(title: const Text("App delivery")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Image.asset('assets/logo.png', width: 147),
                const SizedBox(height: 8),
                const Text('Boas vindas !'),
                const Text('Escolha por categoria'),
                const SizedBox(height: 8),

                // Scroll horizontal com categorias
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      CategoriesData.listCategories.length,
                      (index) {
                        String category = CategoriesData.listCategories[index];

                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CategoryWidget(
                            category: category,
                            onTap: () {
                              if (category.toLowerCase() == "bebidas") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DrinkScreen(drinks: drinks),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Image.asset('assets/banners/banner_promo.png'),
                const SizedBox(height: 16),
                const Text(
                  'Bem avaliados',
                  style: TextStyle(
                      color: AppColors.mainColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Column(
                  children: List.generate(
                    restaurantData.listRestaurant.length,
                    (index) {
                      final restaurant = restaurantData.listRestaurant[index];
                      return RestaurantWidget(restaurant: restaurant);
                    },
                  ),
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
