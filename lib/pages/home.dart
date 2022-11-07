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
  List<String> recipeList = []; // _allResultsList
  TextEditingController searchController = TextEditingController();

  //Future? resultsLoaded;
  List searchResults = [];

  List resultsList = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
  }

  //Removes the listener when page is changed
  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  //@override
  //void didChangeDependencies() {
  //  super.didChangeDependencies();
  //  resultsLoaded = getRecipeList();
  //}

  onSearchChanged() {
    searchResultsList();
    print(searchController.text);
  }

  searchResultsList() {
    var showResults = [];
    if (searchController.text != "") {
      // Search
    } else {
      showResults = List.from(recipeList);
    }
    resultsList = showResults;
  }

  Future getRecipeList() async {
    await FirebaseFirestore.instance.collection('recipies').get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              recipeList.add(document.reference.id);
            },
          ),
        );
    searchResultsList();
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
              controller: searchController,
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
                child: FutureBuilder(
              future: getRecipeList(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: resultsList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: RecipeCard(
                        documentId: recipeList[index],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetail(),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
