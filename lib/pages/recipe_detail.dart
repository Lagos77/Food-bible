import 'package:flutter/material.dart';

class RecipeDetail extends StatelessWidget {
  var documentId;

  RecipeDetail(this.documentId);

  @override
  Widget build(BuildContext context) {
    var ingredientsList = documentId['ingredients'];
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
                children: [
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${documentId["name"]}',
                        style: const TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Created by",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${documentId['userId']}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 3),
                  Ink.image(
                    image: NetworkImage('${documentId["mainImage"]}'),
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            const Icon(Icons.takeout_dining),
                            Text(
                              '${documentId["cookTime"]} min cooktime',
                              style: TextStyle(fontSize: 11),
                            )
                          ],
                        ),
                      ),
                      Text("Servings: ${documentId['servings']}"),
                      Container(
                        child: Row(children: [
                          Text(
                            '${documentId["prepTime"]} min preparation',
                            style: TextStyle(fontSize: 11),
                          ),
                          const Icon(Icons.local_dining)
                        ]),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: const [
                      Text(
                        "Description",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        '${documentId["description"]}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Text(
                        "Ingredients",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: ingredientsList.length,
                    itemBuilder: (BuildContext context, index) {
                      return Row(children: [
                        const Icon(
                          Icons.circle,
                          size: 7.0,
                        ),
                        SizedBox(width: 5),
                        Text(ingredientsList[index].toString()),
                      ]);
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Text(
                        "Type of meal",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(documentId["meal"] ? "This is a meal" : ""),
                      Text(documentId["desert"] ? "This is a desert" : ""),
                      Text(documentId["glutenfree"]
                          ? "This is gluten free"
                          : ""),
                      Text(
                          documentId["vegetarian"] ? "This is vegetarian" : ""),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
