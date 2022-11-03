import 'package:flutter/material.dart';

class CreateRecipePage extends StatefulWidget {
  
  @override
  State<CreateRecipePage> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  

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
      MaterialButton(
        onPressed: () {},
        color: Colors.amber,
        child: const Text('Spara', style: TextStyle(color: Colors.black),),
        )
    ],
   );
  }
}