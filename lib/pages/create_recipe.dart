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
// Text controllers for the input
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _preptimeController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final _servingsController = TextEditingController();

  // User id
  final userId = FirebaseAuth.instance.currentUser?.uid;

  // Bools for the different tags
  bool? isVegetarianChecked = false;
  bool? isMealChecked = false;
  bool? isDesertChecked = false;
  bool? isGlutenfreeChecked = false;

  // variables for creating recipe
  String? mainImageUrl;

  // Firebase collection
  CollectionReference recipies =
      FirebaseFirestore.instance.collection('recipies');

// Create a storage reference from our app
  final storageRef = FirebaseStorage.instance.ref();

  // List for ingredients
  final ingredients = <String>[];

  // Function to save the recipe
  void saveNewRecipe() {
    final recipeName = _nameController.text;
    final recipeDescription = _descriptionController.text;
    final recipeIngredients = ingredients;
    final recipePreptime = _preptimeController.text;
    final recipeCooktime = _cookTimeController.text;
    final recipeServings = int.parse(_servingsController.text);
    // Lägg till bools och userID

    final newRecipe = Recipe(
        name: recipeName,
        ingredients: recipeIngredients,
        description: recipeDescription,
        mainImage: mainImageUrl!,
        prepTime: recipePreptime,
        cookTime: recipeCooktime,
        servings: recipeServings,
        isVegetarian: isVegetarianChecked!,
        isGlutenfree: isGlutenfreeChecked!,
        isMeal: isMealChecked!,
        isDesert: isDesertChecked!,
        userId: userId!);

    clearTextFields();
  }

  // Clear textfields
  void clearTextFields() {
    _nameController.clear();
    _descriptionController.clear();
    _ingredientsController.clear();
    _preptimeController.clear();
    _cookTimeController.clear();
    _servingsController.clear();
  }

  // Add ingredient to list
  void addIngredient() {
    final ingredient = _ingredientsController.text;
    if (ingredient != null) {
      ingredients.add(ingredient);
      _ingredientsController.clear();
      print("Ingredient added! $ingredient");
    }
    print("Funkar");
  }

// Handeling main image
  bool imageIsAlive = false;
  File? image;
  String? imageName;

  void pickImage() async {
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

  // function to save image to storage
  Future uploadImage() async {
    DateTime dateNow = DateTime.now();
    final mainImagesRef = storageRef.child("images/$userId$dateNow$imageName");

    if (imageIsAlive) {
      print("UPLOADING IMAGE");
      try {
        await mainImagesRef.putFile(image!);
        String url = await mainImagesRef.getDownloadURL();
        print("Upload SUCCESSFUL!");
        saveMainImageUrl(url);
      } on FirebaseException catch (e) {
        print("ERROR $e");
      }
    }
  }

  void saveMainImageUrl(String url) {
    mainImageUrl = url;
    print("MAIN IMAGE URL = $mainImageUrl");
  }

  Future<void> addRecipe() {
    return recipies
        .add({
          RECIPE_NAME: "Pasta",
          RECIPE_INGREDIENTS: ["pasta", "vattebn"],
          RECIPE_DESCRIPTION: "Koka pastan och ät den",
          RECIPE_MAIN_IMAGE:
              "gs://foodbible-c4c31.appspot.com/icons8-autism-100.png",
          RECIPE_PREPTIME: "2 minutes",
          RECIPE_COOKTIME: "7 minutes",
          RECIPE_SERVINGS: 2,
          RECIPE_VEGETARIAN: true,
          RECIPE_GLUTENFREE: false,
          RECIPE_MEAL: true,
          RECIPE_DESERT: false,
          RECIPE_USERID: "f9n9GfSifrRpzhr5I5WW" // Toni Fixar userID
        })
        .then((value) =>
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Recipe added successfully!"),
            )))
        .catchError((error) =>
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Failed to add recipe!"),
            )));
  }

  Future<void> updateRecipe() {
    return recipies
        .doc('docID')
        .update({'name': 'Changing Recipe Name'})
        .then((value) => print("Recipe Updated"))
        .catchError((error) => print("Failed to update recipe: $error"));
  }

  Future<void> updateUserAndImage() {
    // to update image
    return rootBundle
        .load('assets/images/sample.jpg')
        .then((bytes) => bytes.buffer.asUint8List())
        .then((avatar) {
          return recipies.doc('docID').update({'info.avatar': Blob(avatar)});
        })
        .then((value) => print("Recipe Updated"))
        .catchError((error) => print("Failed to update recipe: $error"));
  }

  Future<void> deleteRecipe() {
    return recipies
        .doc('docID')
        .delete()
        .then((value) => print("Recipe Deleted"))
        .catchError((error) => print("Failed to delete recipe: $error"));
  }

  Future<void> deleteField() {
    return recipies
        .doc('docID')
        .update({'servings': FieldValue.delete()})
        .then((value) => print("Recipe's Property Deleted"))
        .catchError(
            (error) => print("Failed to delete Recipe's property: $error"));
  }

  Future<void> getRecipies() {
    // ignore: deprecated_member_use
    final listan = <Recipe>[];

    return FirebaseFirestore.instance
        .collection('recipies')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc);
        listan.add(Recipe(
            name: doc[RECIPE_NAME],
            ingredients: doc[RECIPE_INGREDIENTS],
            description: doc[RECIPE_DESCRIPTION],
            mainImage: doc[RECIPE_MAIN_IMAGE],
            prepTime: doc[RECIPE_PREPTIME],
            cookTime: doc[RECIPE_COOKTIME],
            servings: doc[RECIPE_SERVINGS],
            isVegetarian: doc[RECIPE_VEGETARIAN],
            isGlutenfree: doc[RECIPE_GLUTENFREE],
            isMeal: doc[RECIPE_MEAL],
            isDesert: doc[RECIPE_DESERT],
            userId: doc[RECIPE_USERID]));
      });
    });
  }

  bool checkifLoggedin() {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return !checkifLoggedin()
        ? Column(
            children: const [
              Text("You need yto log in to create a recipe"),
            ],
          )
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.all(20.0)),

                  const Text("Create new recipe"),
                  const Padding(padding: EdgeInsets.only(bottom: 30)),

                  imageIsAlive
                      ? Image.file(
                          File(image!.path),
                          height: 100,
                          width: 100,
                        )
                      : const Text("Click button to upload image"),
                  MaterialButton(
                    onPressed: () => pickImage(),
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

                  const Text("Ingrediences"),

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
                  // Add list of added ingrediens here

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

                  MaterialButton(
                    onPressed: () => pickImage(),
                    color: Colors.amber,
                    child: const Text(
                      'Pick image',
                      style: TextStyle(color: Colors.black),
                    ),
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
                      MaterialButton(
                        onPressed: () {
                          // Navigera hem
                        },
                        color: Colors.red,
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),

                  const Padding(padding: EdgeInsets.only(bottom: 30))
                ],
              ),
            ),
          );
  }
}
