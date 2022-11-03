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
            }, icon: const Icon(Icons.clear)),
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
            }, icon: const Icon(Icons.clear)),
          hintText: "Beskrivning"),
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
        const Text("Vegetarisk")
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
        const Text("Glutenfritt")
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
        const Text("Efterätt")
        ],),
        Row(children: [
          Checkbox(
          value: isMealChecked, 
          onChanged: (newBool) {
          setState(() {
            isMealChecked = newBool;
          });
        }),
        const Text("Måltid")
        ],),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {},
              color: Colors.amber,
              child: const Text('Spara', style: TextStyle(color: Colors.black),),
              ),
              const Padding(padding: EdgeInsets.only(right: 50)),
              MaterialButton(
              onPressed: () {
                // Navigera hem
              },
              color: Colors.red,
              child: const Text('Avbryt', style: TextStyle(color: Colors.black),),
              ),
          ],
        ),
          const Padding(padding: EdgeInsets.only(bottom: 30))
      ],
   ),
    );
  }
}