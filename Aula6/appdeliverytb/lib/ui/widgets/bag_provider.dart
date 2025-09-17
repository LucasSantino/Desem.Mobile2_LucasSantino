import 'package:flutter/material.dart';
import 'package:appdeliverytb/model/dish.dart';
import 'package:appdeliverytb/model/drinks.dart';

class BagProvider extends ChangeNotifier {
  List<Dish> dishesOnBag = [];
  List<Drink> drinksOnBag = [];

  // métodos para pratos
  addAllDishes(List<Dish> dishes) {
    dishesOnBag.addAll(dishes);
    notifyListeners();
  }

  removeDish(Dish dish) {
    dishesOnBag.remove(dish);
    notifyListeners();
  }

  // métodos para bebidas
  addDrink(Drink drink) {
    drinksOnBag.add(drink);
    notifyListeners();
  }

  removeDrink(Drink drink) {
    drinksOnBag.remove(drink);
    notifyListeners();
  }

  // Limpa tudo
  clearBag() {
    dishesOnBag.clear();
    drinksOnBag.clear();
    notifyListeners();
  }

  // ✅ Adicione o método getMapByAmount para pratos
  Map<Dish, int> getMapByAmount() {
    Map<Dish, int> mapResult = {};
    for (Dish dish in dishesOnBag) {
      if (mapResult[dish] == null) {
        mapResult[dish] = 1;
      } else {
        mapResult[dish] = mapResult[dish]! + 1;
      }
    }
    return mapResult;
  }

  // Opcional: método semelhante para bebidas
  Map<Drink, int> getDrinksMapByAmount() {
    Map<Drink, int> mapResult = {};
    for (Drink drink in drinksOnBag) {
      if (mapResult[drink] == null) {
        mapResult[drink] = 1;
      } else {
        mapResult[drink] = mapResult[drink]! + 1;
      }
    }
    return mapResult;
  }
}
