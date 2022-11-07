import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodbible/views/widgets/recipe_card.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Object> recipeList = [];

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
  void initState() {
    getRecipeList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: FutureBuilder(future: getRecipeList(), builder: (context, snapshot) {
                return ListView.builder(itemCount: recipeList.length, itemBuilder: (context, index) {
                    return RecipeCard(title: title, image: image)
                },);
              },)
            ),
          ],
        ),
      ),
    );
  }
}
