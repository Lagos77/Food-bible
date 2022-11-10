import 'package:flutter/material.dart';

class RecipeDetail extends StatelessWidget {
  final String title;

  RecipeDetail({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Recipe Detail"),
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
              child: Icon(
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
                    title,
                    style: const TextStyle(
                        fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  Ink.image(
                    image: NetworkImage(
                        "https://media.istockphoto.com/id/1166171010/photo/spicy-grilled-jerk-chicken-on-a-plate.jpg?s=612x612&w=0&k=20&c=AEY55ma7yVvL4YUb4HPxaD7MJ7YcJ2g2sYWHnMXTJDk="),
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Cooktime 7 min"),
                      Text("Description"),
                      Text("Preptime 5 min")
                    ],
                  ),
                  Text(
                    "Description, description, description, description, description, description, description, description, description, description, description, description, description",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text("Ingredients"),
                  Text(
                    "Show",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
