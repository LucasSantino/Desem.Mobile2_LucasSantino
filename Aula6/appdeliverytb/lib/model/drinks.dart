// cria a classe Drink


class Drink {
  final String id;
  final String name;
  final String description;
  final int price;
  final String imagePath;

  Drink({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imagePath': imagePath,
    };
  }

  // Função para fazer a conversão para chave e valor

  factory Drink.fromMap(Map<String, dynamic> map) {
    return Drink(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        price: map['price'],
        imagePath: map['imagePath']);
  }

  @override
  String toString() {
    return 'Drink(id:$id,name: $name, description: $description, price: $price,imagePath: $imagePath)';
  }
}