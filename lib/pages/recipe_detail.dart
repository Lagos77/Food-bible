import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foodbible/models/recipe.dart';

class RecipeDetail extends StatelessWidget {
  var documentId;
  RecipeDetail(this.documentId);

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final toBeUsed = FirebaseAuth.instance.currentUser?.uid;

  bool checkIfLoggedIn() {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      return true;
    }
    return false;
  }

  Future<void> addFavorites() {
    var uid = "";
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      uid = currentUser.uid;
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc('${uid}')
        .update({
          'favorites': FieldValue.arrayUnion([documentId.reference.id])
        })
        .then((value) => Fluttertoast.showToast(
            msg: "Recipe added to favorites!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white))
        .catchError((error) => Fluttertoast.showToast(
            msg: "Recipe NOT added to favorites!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black,
            textColor: Colors.white));
  }

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
          child: const Icon(Icons.arrow_back),
        ),
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
                        '${documentId["userName"]}',
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
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.only(right: 13.0),
                          child: Text(
                            '${documentId["description"]}',
                            maxLines: 20,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      )
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
                        const SizedBox(width: 5),
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
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      checkIfLoggedIn()
                          ? Container(
                              width: 100,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor: Colors.red),
                                onPressed: addFavorites,
                                child: Row(
                                  children: const [
                                    Text("Favorite"),
                                    SizedBox(width: 5),
                                    Icon(Icons.favorite, size: 17),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
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
