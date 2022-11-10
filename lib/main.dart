import 'package:flutter/material.dart';
import 'package:foodbible/mainpage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            title: 'Food bible',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.amber,
              primaryColor: Colors.white,
            ),
            home: MainPage(),
          );
        } else if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  "An error ",
                  style: TextStyle(
                      color: Colors.cyan,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        }

        return MaterialApp(
          title: 'Food Bible',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.amber,
            primaryColor: Colors.white,
          ),
          home: MainPage(),
        );
      },
    );
  }
}
