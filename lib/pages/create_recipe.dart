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
  final _ingredientsController = TextEditingController();
  final _preptimeController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final _servingsController = TextEditingController();
 // final _picturesController = TextEditingController();

  // Bools for the different tags
  bool? isVegetarianChecked = false;
  bool? isMealChecked = false;
  bool? isDesertChecked = false;
  bool? isGlutenfreeChecked = false;
  CollectionReference recipies =
      FirebaseFirestore.instance.collection('recipies');

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
 
   final newRecipe = Recipe(name: recipeName, ingredients: recipeIngredients, description: recipeDescription, prepTime: recipePreptime, cookTime: recipeCooktime, servings: recipeServings);
 
   clearTextFields();
 
   print(newRecipe.name);
   print(newRecipe.ingredients);
   print(newRecipe.prepTime);
   print(newRecipe.servings);
   print(newRecipe.isDesert);
 
 }
 // Clear textfields
 void clearTextFields(){
   _nameController.clear();
   _descriptionController.clear();
   _ingredientsController.clear();
   _preptimeController.clear();
   _cookTimeController.clear();
   _servingsController.clear();
 }

  // Add ingredient to list
 void addIngredient(){
   final ingredient = _ingredientsController.text;
   if(ingredient != null){
     ingredients.add(ingredient);
     _ingredientsController.clear();
   }
 
 }



  // final recipeRef =
  //     FirebaseFirestore.instance.collection('recipies').withConverter<Recipe>(
  //           fromFirestore: (snapshot, _) => Recipe.fromJson(snapshot.data()!),
  //           toFirestore: (recipe, _) => recipe.toJson(),
  //         );

  Future<void> addRecipe() {
    return recipies
        .add({
          "name": "Test",
          "ingredients": ["dd", "dd"],
          "method": "test",
          "pictures": [" ", " "],
          "prepTime": "20 minutes",
          "cookTime": "20 minutes",
          "servings": 7,
          "category": "20 minutes",
          "userId": "TempUserID" // Toni Fixar userID
        })
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Recipe added successfully!"),
            )))
        .catchError(
            (error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
            name: doc['name'],
            ingredients: doc['ingredients'],
            method: doc['method'],
            pictures: doc['pictures'],
            prepTime: doc['prepTime'],
            cookTime: doc['cookTime'],
            servings: doc['servings'],
            category: doc['category'],
            userId: doc['userId']));
      });
    });
  }


  @override
 Widget build(BuildContext context) {
   return SingleChildScrollView(
     child: Padding(
       padding: const EdgeInsets.all(8.0),
       child: Column(
        children: [
        const Padding(padding: EdgeInsets.all(20.0)),
 
         Text("Create new recipe"),
         const Padding(padding: EdgeInsets.only(bottom: 30)),
 
         TextField(
           controller: _nameController,
           decoration: InputDecoration(
             border: const OutlineInputBorder(),
             suffixIcon: IconButton(
               onPressed: () {
                 _nameController.clear();
             }, icon: const Icon(Icons.clear)),
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
             }, icon: const Icon(Icons.clear)),
           hintText: "Example: one red onion"),
         ),
         MaterialButton(onPressed: ()=> addIngredient(),
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
             }, icon: const Icon(Icons.clear)),
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
             }, icon: const Icon(Icons.clear)),
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
             }, icon: const Icon(Icons.clear)),
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
             }, icon: const Icon(Icons.clear)),
           hintText: "Description"),
         ),
 
         const Padding(padding: EdgeInsets.all(20)),
 
         Row(children: [
           Checkbox(
           value: isVegetarianChecked,
           onChanged: (newBool) {
           setState(() {
             isVegetarianChecked = newBool;
           });
         }),
 
         const Text("Vegetarian")
         ],),
 
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
 
         Row(children: [
           Checkbox(
           value: isDesertChecked,
           onChanged: (newBool) {
           setState(() {
             isDesertChecked = newBool;
           });
         }),
 
         const Text("Desert")
         ],),
 
         Row(children: [
           Checkbox(
           value: isMealChecked,
           onChanged: (newBool) {
           setState(() {
             isMealChecked = newBool;
           });
         }),
 
         const Text("Meal")
         ],),
 
         Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             MaterialButton(
               onPressed: () => saveNewRecipe(),
               color: Colors.amber,
               child: const Text('Save', style: TextStyle(color: Colors.black),),
               ),
               const Padding(padding: EdgeInsets.only(right: 50)),
               MaterialButton(
               onPressed: () {
                 // Navigera hem
               },
               color: Colors.red,
               child: const Text('Cancel', style: TextStyle(color: Colors.black),),
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


