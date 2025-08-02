import '../../domain/entities/menu.dart';

class MenuModel extends Menu {
  const MenuModel({required super.foods, required super.drinks});

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      foods: (json['foods'] as List<dynamic>)
          .map((food) => MenuItemModel.fromJson(food as Map<String, dynamic>))
          .toList(),
      drinks: (json['drinks'] as List<dynamic>)
          .map((drink) => MenuItemModel.fromJson(drink as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foods': foods.map((food) => (food as MenuItemModel).toJson()).toList(),
      'drinks': drinks
          .map((drink) => (drink as MenuItemModel).toJson())
          .toList(),
    };
  }

  Menu toEntity() {
    return Menu(foods: foods, drinks: drinks);
  }

  factory MenuModel.fromEntity(Menu menu) {
    return MenuModel(foods: menu.foods, drinks: menu.drinks);
  }
}

class MenuItemModel extends MenuItem {
  const MenuItemModel({required super.name});

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }

  MenuItem toEntity() {
    return MenuItem(name: name);
  }

  factory MenuItemModel.fromEntity(MenuItem menuItem) {
    return MenuItemModel(name: menuItem.name);
  }
}
