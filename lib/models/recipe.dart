class Recipe {

  String name;
  List ingredients;
  String method;
  List pictures;
  String prepTime;
  String cookTime;
  int servings;
  String category;
  
  Recipe(
      {required this.name,
      required this.ingredients,
      required this.method,
      required this.pictures,
      required this.prepTime,
      required this.cookTime,
      required this.servings,
      required this.category});

  Recipe.fromJson(Map<String, Object?> json)
      : this(
          name: json['name']! as String,
          ingredients: json['ingredients']! as List,
          method: json['method']! as String,
          pictures: json['pictures']! as List,
          prepTime: json['prepTime']! as String,
          cookTime: json['cookTime']! as String,
          servings: json['servings']! as int,
          category: json['category']! as String,
        );

  final String name;
  final List ingredients;
  final String method;
  final List pictures;
  final String prepTime;
  final String cookTime;
  final int servings;
  final String category;

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'ingredients': ingredients,
      'method': method,
      'pictures': pictures,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'servings': servings,
      'category': category,
    };
  }
}
