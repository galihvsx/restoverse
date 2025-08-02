import 'package:equatable/equatable.dart';

class Menu extends Equatable {
  final List<MenuItem> foods;
  final List<MenuItem> drinks;

  const Menu({required this.foods, required this.drinks});

  @override
  List<Object?> get props => [foods, drinks];

  @override
  String toString() {
    return 'Menu(foods: ${foods.length}, drinks: ${drinks.length})';
  }
}

class MenuItem extends Equatable {
  final String name;

  const MenuItem({required this.name});

  @override
  List<Object?> get props => [name];

  @override
  String toString() {
    return 'MenuItem(name: $name)';
  }
}
