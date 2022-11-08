import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodbible/pages/recipe_detail.dart';
import 'package:foodbible/views/widgets/recipe_card.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
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
                                  image: '${data['method']}');
                            }
                            if (data['name']
                                .toString()
                                .toLowerCase()
                                .startsWith(searchIndicator.toLowerCase())) {
                              return RecipeCard(
                                  title: '${data['name']}',
                                  image: '${data['method']}');
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
