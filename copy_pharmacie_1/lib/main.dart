import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pharmacie_1/login.dart';
import 'package:pharmacie_1/singup.dart';
// import 'package:pharmacie_1/singup.dart';

import 'homepage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(apiKey: "AIzaSyA3ATkowtMNZ6-EWaWjA-OlrVsdnc63HfM",
    appId: "1:105810306886:android:55b67e145bc9a04c212747", 
    messagingSenderId: "105810306886", 
    projectId: "flutter-pharmacie")
  );
  runApp(MyHomePage());
}
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      // title: 'Pharmacie de gard',
      // initialRoute: '/login',
      routes: {
        '/login': (context) => const Login(),
        '/singup': (context) => const Signup(),
        '/homepage': (context)=>HomePage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        
      ),
      home: (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.emailVerified) ? HomePage() : Login(),
    );
    
  }
}

