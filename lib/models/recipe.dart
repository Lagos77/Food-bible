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
}
