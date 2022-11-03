import 'package:flutter/material.dart';

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
  

// Function to save the recipe
  void saveNewRecipe() {
    final recipeName = _nameController.text;
    final recipeDescription = _descriptionController.text;

    Navigator.of(context).pop();

  }
  @override
  Widget build(BuildContext context) {
    return Column( 
     children: [
      Padding(padding: EdgeInsets.all(40.0)),
      Text("Skapa nytt recept"),
      TextField(
        controller: _nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            onPressed: () {
              _nameController.clear();
          }, icon: Icon(Icons.clear)),
        hintText: "Namn på recept"),
      ),
      const Padding(padding: EdgeInsets.only(bottom: 30)),
      TextField(
        controller: _descriptionController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            onPressed: () {
              _nameController.clear();
          }, icon: Icon(Icons.clear)),
        hintText: "Beskrivning"),
      ),
      Padding(padding: EdgeInsets.all(20)),
      Row(children: [
        Checkbox(
        value: isVegetarianChecked, 
        onChanged: (newBool) {
        setState(() {
          isVegetarianChecked = newBool;
        });
      }),
      Text("Vegetarisk")
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
      Text("Glutenfritt")
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
      Text("Efterätt")
      ],),
      Row(children: [
        Checkbox(
        value: isMealChecked, 
        onChanged: (newBool) {
        setState(() {
          isMealChecked = newBool;
        });
      }),
      Text("Måltid")
      ],),
      Spacer(),
      MaterialButton(
        onPressed: () {},
        color: Colors.amber,
        child: const Text('Spara', style: TextStyle(color: Colors.black),),
        ),
        Padding(padding: EdgeInsets.only(bottom: 30))
    ],
   );
  }
}