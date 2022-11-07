import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodbible/models/recipe.dart';
import 'package:foodbible/pages/singin.dart';
import 'package:foodbible/pages/test3.dart';
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
        'name': doc['name'],
        'ingredients': doc['ingredients'],
        'method': doc['method'],
        'pictures': doc['pictures'],
        'preprTime': doc['prepTime'],
        'cookTime': doc['cookTime'],
        'servings': doc['servings'],
        'category': doc['category']
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
          name: doc['name'],
          ingredients: doc['ingredients'],
          method: doc['method'],
          pictures: doc['pictures'],
          prepTime: doc['prepTime'],
          cookTime: doc['cookTime'],
          servings: doc['servings'],
          category: doc['category'],
          userId: doc['userId']));
    });
  });

  return listan;
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('recipies').snapshots();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<List<Recipe>>(
            stream: getAll(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Somthing wrong");
              } else if (snapshot.hasData) {
                final recioeiesss = snapshot.data!;
                return ListView(
                  children: recioeiesss.map(buildRecipe).toList(),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Test3(),
            ));
          },
        ),
      );

  Widget buildRecipe(Recipe recipe) => ListTile(
        leading: Image.network('${recipe.method}', fit: BoxFit.cover),

        //Text('${recipe.name}')),
        title: Text(recipe.name),
        subtitle: Row(
          children: [
            Text(recipe.category),
            Text(recipe.prepTime),
            Text(recipe.cookTime),
            Text(recipe.servings.toString())
          ],
        ),
      );
  Stream<List<Recipe>> getAll() => FirebaseFirestore.instance
      .collection('recipies')
      //.where('userId', isEqualTo: "f9n9GfSifrRpzhr5I5WW")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Recipe.fromJson(doc.data())).toList());
}



  // StreamBuilder<QuerySnapshot>(
  //   stream: _usersStream,
  //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //     if (snapshot.hasError) {
  //       return Text('Something went wrong');
  //     }

  //     if (snapshot.connectionState == ConnectionState.waiting) {
  //       return Text("Loading");
  //     }

  //     return ListView(
  //       children: snapshot.data!.docs.map((DocumentSnapshot document) {
  //         Map<String, dynamic> data =
  //             document.data()! as Map<String, dynamic>;
  //         return ListView.builder(
  //             itemCount: listan.length,
  //             itemBuilder: (context, index) {
  //               return Padding(
  //                 padding: EdgeInsets.only(bottom: 60),
  //                 child: Card(
  //                     elevation: 5,
  //                     child: Column(
  //                       children: [
  //                         Text(
  //                           listan[index].name,
  //                           style: const TextStyle(fontSize: 50),
  //                           textAlign: TextAlign.center,
  //                         ),
  //                       ],
  //                     )),
  //               );
  //             });
  //       }).toList(),
  //     );
  //   },
  // );

  // return
  // ListView.builder(
  //     itemCount: listan.length,
  //     itemBuilder: (context, index) {
  //       return Padding(
  //         padding: EdgeInsets.only(bottom: 60),
  //         child: Card(
  //             elevation: 5,
  //             child: Column(
  //               children: [
  //                 Text(
  //                   listan[index].name,
  //                   style: const TextStyle(fontSize: 50),
  //                   textAlign: TextAlign.center,
  //                 ),
  //               ],
  //             )),
  //       );
  //     });

