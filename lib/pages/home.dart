import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodbible/views/widgets/recipe_card.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> recipeList = [];
  String searchIndicator = "";

  bool meal = false;
  bool desert = false;
  bool vegetarian = false;
  bool glutenFree = false;

/*   Future getRecipeList() async {
    await FirebaseFirestore.instance.collection('recipies').get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              recipeList.add(document.reference.id);
            },
          ),
        );
  } */

  firebaseSorting() {
    if (vegetarian == true) {
      return FirebaseFirestore.instance
          .collection('recipies')
          .orderBy('vegetarian', descending: true)
          .snapshots();
    } else if (meal == true) {
      return FirebaseFirestore.instance
          .collection('recipies')
          .orderBy('meal', descending: true)
          .snapshots();
    } else if (desert == true) {
      return FirebaseFirestore.instance
          .collection('recipies')
          .orderBy('desert', descending: true)
          .snapshots();
    } else if (glutenFree == true) {
      return FirebaseFirestore.instance
          .collection('recipies')
          .orderBy('glutenfree', descending: true)
          .snapshots();
    } else {
      return FirebaseFirestore.instance.collection('recipies').snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Searchbar code
            const SizedBox(height: 10.0),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none),
                hintText: "Search for recipes...",
                suffixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchIndicator = value;
                });
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.amber,
                    ),
                    onPressed: () => {setState(() => meal = !meal)},
                    child: Text(meal ? 'Sorted' : 'Meal'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.amber,
                    ),
                    onPressed: () => {setState(() => desert = !desert)},
                    child: Text(desert ? "Sorted" : "Desert"),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.amber,
                    ),
                    onPressed: () => {setState(() => vegetarian = !vegetarian)},
                    child: Text(vegetarian ? 'Sorted' : 'Vegetarian'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.amber,
                    ),
                    onPressed: () => {setState(() => glutenFree = !glutenFree)},
                    child: Text(glutenFree ? "Sorted" : "Gluten"),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firebaseSorting(),
                builder: (context, snapshots) {
                  return (snapshots.connectionState == ConnectionState.waiting)
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: snapshots.data!.docs.length,
                          itemBuilder: (context, index) {
                            var data = snapshots.data!.docs[index].data()
                                as Map<String, dynamic>;

                            if (searchIndicator.isEmpty) {
                              return RecipeCard(snapshots.data!.docs[index]);
                            }
                            if (data['name']
                                .toString()
                                .toLowerCase()
                                .startsWith(searchIndicator.toLowerCase())) {
                              return RecipeCard(snapshots.data!.docs[index]);
                            }
                            return Container();
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
