import 'package:flutter/material.dart';

class CreateRecipePage extends StatefulWidget {
  
  @override
  State<CreateRecipePage> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column( 
     children: [
      Padding(padding: EdgeInsets.all(40.0)),
      Text("Skapa nytt recept"),
      TextField(
        controller: _textController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            onPressed: () {
              _textController.clear();
          }, icon: Icon(Icons.clear)),
        hintText: "Namn på recept"),
      ),
      MaterialButton(
        onPressed: () {},
        color: Colors.amber,
        child: const Text('Spara', style: TextStyle(color: Colors.white),),
        )
    ],
   );
  }
}