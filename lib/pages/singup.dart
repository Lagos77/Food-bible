import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodbible/models/constants.dart';
import 'package:foodbible/models/recipe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodbible/models/user.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
// Text controllers for the input
  final _firstNameController = TextEditingController();
  final _LastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userNameController = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // final userRef =
  //     FirebaseFirestore.instance.collection('users').withConverter<User>(
  //           fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
  //           toFirestore: (user, _) => user.toJson(),
  //         );

  Future<void> createUserEmailAndPAssword() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.toLowerCase().trim(),
        password: _passwordController.text.trim(),
      );

      addUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Password is too weak!"),
        ));
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Email already exist!"),
        ));
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addUser() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return users
        .doc(userId)
        .set({
          'firstName': _firstNameController.text.trim(),
          'lastName': _LastNameController.text.trim(),
          'email': _emailController.text.toLowerCase().trim(),
          'userName': _userNameController.text.trim(),
          'favorites': []
        })
        .then((value) => Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        const Padding(padding: EdgeInsets.all(20.0)),
        const Text("Sign Up",
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.black,
              fontWeight: FontWeight.w700,
              //fontFamily:  ,
            )),
        const Padding(padding: EdgeInsets.only(bottom: 30)),
        TextField(
          controller: _firstNameController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            hintText: "First Name",
            suffixIcon: IconButton(
                onPressed: () {
                  _firstNameController.clear();
                },
                icon: const Icon(Icons.clear)),
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 30)),
        TextField(
          controller: _LastNameController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            hintText: "Last Name",
            suffixIcon: IconButton(
                onPressed: () {
                  _LastNameController.clear();
                },
                icon: const Icon(Icons.clear)),
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 30)),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            hintText: "Email",
            suffixIcon: IconButton(
                onPressed: () {
                  _emailController.clear();
                },
                icon: const Icon(Icons.clear)),
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 30)),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            hintText: "Password",
            suffixIcon: IconButton(
                onPressed: () {
                  _passwordController.clear();
                },
                icon: const Icon(Icons.clear)),
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 30)),
        TextField(
          controller: _userNameController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            hintText: "Username",
            suffixIcon: IconButton(
                onPressed: () {
                  _userNameController.clear();
                },
                icon: const Icon(Icons.clear)),
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 30)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              minWidth: 150.0,
              height: 50,
              onPressed: createUserEmailAndPAssword,
              color: Colors.amber,
              child: const Text('Register',
                  style: TextStyle(fontSize: 16.0, color: Colors.black)),
            ),
            const Padding(padding: EdgeInsets.only(right: 50)),
            MaterialButton(
              minWidth: 150.0,
              height: 50,
              onPressed: () {
                // Navigera hem
              },
              color: Colors.red,
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 16.0, color: Colors.black),
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(bottom: 30)),
      ]),
    ));
  }
}
