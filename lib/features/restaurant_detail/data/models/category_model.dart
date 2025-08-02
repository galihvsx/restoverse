import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  Category toEntity() {
    return Category(
      name: name,
    );
  }

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      name: category.name,
    );
  }
}