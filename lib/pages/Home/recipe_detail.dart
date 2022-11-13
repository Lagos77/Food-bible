import 'package:flutter/material.dart';

class RecipeDetail extends StatelessWidget {
  var documentId;

  RecipeDetail(this.documentId);

  @override
  Widget build(BuildContext context) {
    List<String> ingredientsList =
        List.castFrom(documentId['ingredients'] as List ?? []);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Recipe Details"),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                //Add function to save to favorite
              },
              child: const Icon(
                Icons.favorite_border_outlined,
                size: 26,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${documentId["name"]}',
                    style: const TextStyle(
                        fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  Ink.image(
                    image: NetworkImage('${documentId["mainImage"]}'),
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${documentId["cookTime"]}'),
                      Text("Description"),
                      Text('${documentId["prepTime"]}')
                    ],
                  ),
                  Text(
                    '${documentId["description"]}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Text("Ingredients"),
                  Text(
                    '$ingredientsList',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(documentId["desert"] ? "This is a desert" : ""),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
