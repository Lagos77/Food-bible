class Recipe {
  final String name;
  final List ingredients;
  final String method;
  final List pictures;
  final String prepTime;
  final String cookTime;
  final int servings;
  final bool isVegetarian;
  final bool isGlutenfree;
  final bool isMeal;
  final bool isDesert;
  final String userId;

  Recipe(
      {required this.name,
      required this.ingredients,
      required this.method,
      required this.pictures,
      required this.prepTime,
      required this.cookTime,
      required this.servings,
      required this.isVegetarian,
      required this.isGlutenfree,
      required this.isMeal,
      required this.isDesert,
      required this.userId});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name']! as String,
      ingredients: json['ingredients']! as List,
      method: json['method']! as String,
      pictures: json['pictures']! as List,
      prepTime: json['prepTime']! as String,
      cookTime: json['cookTime']! as String,
      servings: json['servings']! as int,
      isVegetarian: json['vegetarian']! as bool,
      isGlutenfree: json['glutenfree']! as bool,
      isMeal: json['meal']! as bool,
      isDesert: json['desert']! as bool,
      userId: json['userId']! as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ingredients': ingredients,
      'method': method,
      'pictures': pictures,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'servings': servings,
      'vegetarian' : isVegetarian,
      'glutenfree' : isGlutenfree,
      'meal' : isMeal,
      'desert' : isDesert,
      'userId': userId,
    };
  }
}
