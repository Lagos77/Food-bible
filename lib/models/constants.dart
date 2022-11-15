// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbible/models/recipe.dart';

const String RECIPE_NAME = "name";
const String RECIPE_INGREDIENTS = "ingredients";
const String RECIPE_DESCRIPTION = "description";
const String RECIPE_PICTURES = "pictures";
const String RECIPE_MAIN_IMAGE = "mainImage";
const String RECIPE_PREPTIME = "prepTime";
const String RECIPE_COOKTIME = "cookTime";
const String RECIPE_SERVINGS = "servings";
const String RECIPE_VEGETARIAN = "vegetarian";
const String RECIPE_GLUTENFREE = "glutenfree";
const String RECIPE_MEAL = "meal";
const String RECIPE_DESERT = "desert";
const String RECIPE_USERID = "userId";
const String RECIPE_USERNAME = "userName";
final String? userId = FirebaseAuth.instance.currentUser?.uid;
