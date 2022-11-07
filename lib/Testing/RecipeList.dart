import 'dart:ui';
import 'package:flutter/material.dart';

class RecipeList {
  String firebaseTitle;
  String firebaseImage;

  RecipeList(this.firebaseTitle, this.firebaseImage);

  static List<RecipeList> album() {
    return [
      RecipeList("Test Recipe 1",
          "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg?quality=90&resize=768,574"),
      RecipeList("Test Recipe 2",
          "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/copycat-hamburger-helper1-1659463591.jpg?crop=0.668xw:1.00xh;0.176xw,0&resize=640:*")
    ];
  }
}
