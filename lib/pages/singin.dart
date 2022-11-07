import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodbible/models/recipe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodbible/models/user.dart';

class SignIn extends StatefulWidget {
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
// Text controllers for the input

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // final userRef =
  //     FirebaseFirestore.instance.collection('users').withConverter<User>(
  //           fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
  //           toFirestore: (user, _) => user.toJson(),
  //         );

  Future<void> signInEmailAndPAssword() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Fill in your email and password please!"),
      ));
    }

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text.trim());
      print("Successfully logged in ");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Email address not found!"),
        ));
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Wrong password provided for this email!"),
        ));
        print('Wrong password provided for that user.');
      }
    }
  }

  Future<void> resetPassword() async {
    if (_emailController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Fill in your email address!"),
      ));
    } else {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.toLowerCase().trim());

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("An email has been sent to you!"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(40.0)),
          Text("Sign In"),
          const Padding(padding: EdgeInsets.only(bottom: 30)),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                    onPressed: () {
                      _emailController.clear();
                    },
                    icon: const Icon(Icons.clear)),
                hintText: "Email"),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 30)),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                    onPressed: () {
                      _passwordController.clear();
                    },
                    icon: const Icon(Icons.clear)),
                hintText: "Password"),
          ),
          MaterialButton(
            onPressed: resetPassword,
            color: Colors.amber,
            child: const Text(
              'Forgot Password?',
              style: TextStyle(color: Colors.black),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: signInEmailAndPAssword,
                color: Colors.amber,
                child: const Text(
                  'Sign in',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const Padding(padding: EdgeInsets.only(right: 50)),
              MaterialButton(
                onPressed: () {
                  // Navigera hem
                },
                color: Colors.red,
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(bottom: 30))
        ],
      ),
    );
  }
}
