import 'package:foodbible/models/constants.dart';

class Recipe {
  final String name;
  final List ingredients;
  final String description;
  final String mainImage;
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
      required this.description,
      required this.mainImage,
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
      name: json[RECIPE_NAME]! as String,
      ingredients: json[RECIPE_INGREDIENTS]! as List,
      description: json[RECIPE_DESCRIPTION]! as String,
      mainImage: json[RECIPE_MAIN_IMAGE]! as String,
      prepTime: json[RECIPE_PREPTIME]! as String,
      cookTime: json[RECIPE_COOKTIME]! as String,
      servings: json[RECIPE_SERVINGS]! as int,
      isVegetarian: json[RECIPE_VEGETARIAN]! as bool,
      isGlutenfree: json[RECIPE_GLUTENFREE]! as bool,
      isMeal: json[RECIPE_MEAL]! as bool,
      isDesert: json[RECIPE_DESERT]! as bool,
      userId: json[RECIPE_USERID]! as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      RECIPE_NAME: name,
      RECIPE_INGREDIENTS: ingredients,
      RECIPE_DESCRIPTION: description,
      RECIPE_MAIN_IMAGE: mainImage,
      RECIPE_PREPTIME: prepTime,
      RECIPE_COOKTIME: cookTime,
      RECIPE_SERVINGS: servings,
      RECIPE_VEGETARIAN : isVegetarian,
      RECIPE_GLUTENFREE : isGlutenfree,
      RECIPE_MEAL : isMeal,
      RECIPE_DESERT : isDesert,
      RECIPE_USERID: userId,
    };
  }
}
