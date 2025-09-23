import 'package:flutter/foundation.dart';
import 'destino_item.dart';

class CartModel extends ChangeNotifier {
  final List<DestinoItem> _items = [];

  List<DestinoItem> get items => List.unmodifiable(_items);

  void addItem(DestinoItem item) {
    _items.add(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  double get total {
    double sum = 0.0;
    for (var i in _items) {
      sum += i.total;
    }
    return sum;
  }

  void removeAt(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
}
