import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodbible/models/recipe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateRecipePage extends StatefulWidget {
  @override
  State<CreateRecipePage> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
// Text controllers for the input
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Bools for the different tags
  bool? isVegetarianChecked = false;
  bool? isMealChecked = false;
  bool? isDesertChecked = false;
  bool? isGlutenfreeChecked = false;
  CollectionReference recipies =
      FirebaseFirestore.instance.collection('recipies');

  final recipeRef =
      FirebaseFirestore.instance.collection('recipies').withConverter<Recipe>(
            fromFirestore: (snapshot, _) => Recipe.fromJson(snapshot.data()!),
            toFirestore: (recipe, _) => recipe.toJson(),
          );

  Future<void> addRecipe() {
    // Call the user's CollectionReference to add a new user
    return recipies
        .add({
          "name": "Test",
          "ingredients": ["dd", "dd"],
          "method": "test",
          "pictures": [" ", " "],
          "prepTime": "20 minutes",
          "cookTime": "20 minutes",
          "servings": 7,
          "category": "20 minutes"
        })
        .then((value) => print("Recipe Added"))
        .catchError((error) => print("Failed to add Recipe: $error"));
  }

  Future<void> updateRecipe() {
    return recipies
        .doc('docID')
        .update({'name': 'Changing Recipe Name'})
        .then((value) => print("Recipe Updated"))
        .catchError((error) => print("Failed to update recipe: $error"));
  }

  Future<void> updateUserAndImage() {
    // to ipdate image
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
    return FirebaseFirestore.instance
        .collection('recipies')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["name"]);
      });
    });
  }

// Function to save the recipe

  void saveNewRecipe() {
    final recipeName = _nameController.text;
    final recipeDescription = _descriptionController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(40.0)),
          Text("Skapa nytt recept"),
          const Padding(padding: EdgeInsets.only(bottom: 30)),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                    onPressed: () {
                      _nameController.clear();
                    },
                    icon: const Icon(Icons.clear)),
                hintText: "Namn på recept"),
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
                hintText: "Beskrivning"),
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
              const Text("Vegetarisk")
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
              const Text("Glutenfritt")
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
              const Text("Efterätt")
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
              const Text("Måltid")
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: addRecipe,
                color: Colors.amber,
                child: const Text(
                  'Spara',
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
                  'Avbryt',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(bottom: 30))
        ],
      ),
    );
  }
}
