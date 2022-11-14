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

Future<void> signOutEmail() async {
  await FirebaseAuth.instance.signOut();
}

final listan = <Recipe>[];
FirebaseFirestore _firestore = FirebaseFirestore.instance;

CollectionReference merchRef = _firestore.collection('recipies');

Future<List<Recipe>> getDocs() async {
  List<Recipe> recipies = [];

  CollectionReference recipiehRef =
      FirebaseFirestore.instance.collection('recipies');

  await recipiehRef.get().then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      Recipe recipie = Recipe.fromJson({
        RECIPE_NAME: doc[RECIPE_NAME],
        RECIPE_INGREDIENTS: doc[RECIPE_INGREDIENTS],
        RECIPE_DESCRIPTION: doc[RECIPE_DESCRIPTION],
        RECIPE_MAIN_IMAGE: doc[RECIPE_MAIN_IMAGE],
        RECIPE_PREPTIME: doc[RECIPE_PREPTIME],
        RECIPE_COOKTIME: doc[RECIPE_COOKTIME],
        RECIPE_SERVINGS: doc[RECIPE_SERVINGS],
        RECIPE_VEGETARIAN: doc[RECIPE_VEGETARIAN],
        RECIPE_GLUTENFREE: doc[RECIPE_GLUTENFREE],
        RECIPE_MEAL: doc[RECIPE_MEAL],
        RECIPE_DESERT: doc[RECIPE_DESERT],
        // Ska den vara med?
        RECIPE_USERID: doc[RECIPE_USERID]
      });
      recipies.add(recipie);
    });
  });

  return recipies;
}

Future<List<Recipe>> getRecipies() async {
  await FirebaseFirestore.instance
      .collection('recipies')
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      print(doc);
      listan.add(Recipe(
          name: doc[RECIPE_NAME],
            ingredients: doc[RECIPE_INGREDIENTS],
            description: doc[RECIPE_DESCRIPTION],
            mainImage: doc[RECIPE_MAIN_IMAGE],
            prepTime: doc[RECIPE_PREPTIME],
            cookTime: doc[RECIPE_COOKTIME],
            servings: doc[RECIPE_SERVINGS],
            isVegetarian: doc[RECIPE_VEGETARIAN],
            isGlutenfree: doc[RECIPE_GLUTENFREE],
            isMeal: doc[RECIPE_MEAL],
            isDesert: doc[RECIPE_DESERT],
            userId: doc[RECIPE_USERID]));
    });
  });

  return listan;
}

class _HomePageState extends State<HomePage> {
  List<String> recipeList = [];
  String searchIndicator = "";

  Future getRecipeList() async {
    await FirebaseFirestore.instance.collection('recipies').get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              recipeList.add(document.reference.id);
            },
          ),
        );
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
            const SizedBox(height: 20.0),
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
              height: 20.0,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('recipies')
                    .snapshots(),
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
                              return RecipeCard(
                                  title: '${data['name']}',
                                  mainImage: '${data['mainImage']}');
                            }
                            if (data['name']
                                .toString()
                                .toLowerCase()
                                .startsWith(searchIndicator.toLowerCase())) {
                              return RecipeCard(
                                  title: '${data['name']}',
                                  mainImage: '${data['mainImage']}');
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
