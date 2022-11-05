import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodbible/models/recipe.dart';
import 'package:foodbible/views/widgets/recipe_card.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

Future<void> signOutEmail() async {
  await FirebaseAuth.instance.signOut();
}

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

  test();
  return recipies;
}

void test() {
  print("!!!!!!!");
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('recipies').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['name']),
              subtitle: Text(data['cookTime']),
            );
          }).toList(),
        );
      },
    );
  }
}
