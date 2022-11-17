import 'dart:ffi';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodbible/models/constants.dart';
import 'package:foodbible/models/recipe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodbible/models/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateRecipePage extends StatefulWidget {
  @override
  State<CreateRecipePage> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _preptimeController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final _servingsController = TextEditingController();

  bool? isVegetarianChecked = false;
  bool? isMealChecked = false;
  bool? isDesertChecked = false;
  bool? isGlutenfreeChecked = false;

  String? mainImageUrl;
  final userId = FirebaseAuth.instance.currentUser?.uid;
  List<String> ingredients = [];
  CollectionReference recipies =
      FirebaseFirestore.instance.collection('recipies');
  final storageRef = FirebaseStorage.instance.ref();
  bool imageIsAlive = false;
  File? image;
  String? imageName;

  final user = "";

  void clearTextFields() {
    _nameController.clear();
    _descriptionController.clear();
    _ingredientsController.clear();
    _preptimeController.clear();
    _cookTimeController.clear();
    _servingsController.clear();
  }

  void addIngredient() {
    final ingredient = _ingredientsController.text;
    if (ingredient.isNotEmpty) {
      setState(() {
        ingredients.add(ingredient);
      });
      _ingredientsController.clear();
    }
  }

  void pickMainImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      imageName = image.toString();
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
    print("image: $image");
    imageIsAlive = true;

    uploadImage();
  }

  Future uploadImage() async {
    DateTime dateNow = DateTime.now();
    final mainImagesRef = storageRef.child("images/$userId$dateNow$imageName");

    if (imageIsAlive) {
      print("UPLOADING IMAGE");
      try {
        await mainImagesRef.putFile(image!);
        String url = await mainImagesRef.getDownloadURL();
        saveMainImageUrl(url);
        image = null;
        imageIsAlive = false;
      } on FirebaseException catch (e) {
        print("ERROR $e");
      }
    }
  }

  void saveMainImageUrl(String url) {
    mainImageUrl = url;
  }

  Future<String> showDisplayName() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(userId).get();

    Map<String, dynamic>? data = docSnapshot.data();

    var user = data!['userName'].toString();
    return user;
  }

  Future<void> addRecipe() {
    showDisplayName();

    final recipeName = _nameController.text;
    final recipeDescription = _descriptionController.text;
    final recipeIngredients = ingredients;
    final recipePreptime = _preptimeController.text;
    final recipeCooktime = _cookTimeController.text;
    final recipeServings = int.parse(_servingsController.text);
    final vegetarian = isVegetarianChecked;
    final glutenFree = isGlutenfreeChecked;
    final meal = isMealChecked;
    final desert = isDesertChecked;
    final userName = user;

    clearTextFields();

    return recipies
        .add({
          RECIPE_NAME: recipeName,
          RECIPE_INGREDIENTS: ingredients,
          RECIPE_DESCRIPTION: recipeDescription,
          RECIPE_MAIN_IMAGE: mainImageUrl,
          RECIPE_PREPTIME: recipePreptime,
          RECIPE_COOKTIME: recipeCooktime,
          RECIPE_SERVINGS: recipeServings,
          RECIPE_VEGETARIAN: vegetarian,
          RECIPE_GLUTENFREE: glutenFree,
          RECIPE_MEAL: meal,
          RECIPE_DESERT: desert,
          RECIPE_USERID: userId,
          RECIPE_USERNAME: userName,
        })
        /*
         .then((value) => Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false))
        .catchError((error) => print("Failed to add user: $error"));
        */
        .then((value) =>
            Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false))
        .catchError((error) =>
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Failed to add recipe!"),
            )));
  }

  void clearInputFields() {
    _nameController.clear();
    _descriptionController.clear();
    _ingredientsController.clear();
    _preptimeController.clear();
    _cookTimeController.clear();
    _servingsController.clear();
    isVegetarianChecked = false;
    isGlutenfreeChecked = false;
    isMealChecked = false;
    isDesertChecked = false;
    mainImageUrl = "";
    image = null;
  }

  bool checkifLoggedin() {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      return true;
    }
    return false;
  }

  Future<void> deleteRecipe() {
    return recipies
        .doc('docID')
        .delete()
        .then((value) => print("Recipe Deleted"))
        .catchError((error) => print("Failed to delete recipe: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return !checkifLoggedin()
        ? Column(
            children: const [
              Text("You need to log in to create a recipe"),
            ],
          )
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.all(20.0)),
                  const Text("Create new recipe",
                      style: TextStyle(fontSize: 20.0)),
                  const Padding(padding: EdgeInsets.only(bottom: 30)),
                  imageIsAlive
                      ? Image.file(
                          File(image!.path),
                          height: 100,
                          width: 100,
                        )
                      : const Text("Click button to upload image"),
                  MaterialButton(
                    onPressed: () => pickMainImage(),
                    color: Colors.amber,
                    child: const Text(
                      'pick Image',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _nameController.clear();
                            },
                            icon: const Icon(Icons.clear)),
                        hintText: "Recipe name"),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 30)),
                  Text("Ingrediences"),
                  TextField(
                    controller: _ingredientsController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _ingredientsController.clear();
                            },
                            icon: const Icon(Icons.clear)),
                        hintText: "Example: one red onion"),
                  ),
                  MaterialButton(
                    onPressed: () => addIngredient(),
                    color: Colors.amber,
                    child: const Text("Add ingredient"),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: ingredients.length,
                      itemBuilder: (_, i) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            ingredients[i],
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Color.fromARGB(255, 41, 41, 41),
                            ),
                          ),
                        );
                      }),
                  const Padding(padding: EdgeInsets.only(bottom: 30)),
                  TextField(
                    controller: _preptimeController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _preptimeController.clear();
                            },
                            icon: const Icon(Icons.clear)),
                        hintText: "Preperation time"),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 30)),
                  TextField(
                    controller: _cookTimeController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _cookTimeController.clear();
                            },
                            icon: const Icon(Icons.clear)),
                        hintText: "Cooking time"),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 30)),
                  TextField(
                    controller: _servingsController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _servingsController.clear();
                            },
                            icon: const Icon(Icons.clear)),
                        hintText: "Servings"),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 30)),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                            onPressed: () {
                              _descriptionController.clear();
                            },
                            icon: const Icon(Icons.clear)),
                        hintText: "Description"),
                  ),
                  const Padding(padding: EdgeInsets.all(20)),
                  Row(
                    children: [
                      Checkbox(
                          value: isVegetarianChecked,
                          onChanged: (newBool) {
                            setState(() {
                              isVegetarianChecked = newBool;
                            });
                          }),
                      const Text("Vegetarian")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: isGlutenfreeChecked,
                          onChanged: (newBool) {
                            setState(() {
                              isGlutenfreeChecked = newBool;
                            });
                          }),
                      const Text("Glutenfree")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: isDesertChecked,
                          onChanged: (newBool) {
                            setState(() {
                              isDesertChecked = newBool;
                            });
                          }),
                      const Text("Desert")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: isMealChecked,
                          onChanged: (newBool) {
                            setState(() {
                              isMealChecked = newBool;
                            });
                          }),
                      const Text("Meal")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        onPressed: () => addRecipe(),
                        color: Colors.amber,
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(right: 50)),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 30))
                ],
              ),
            ),
          );
  }
}
