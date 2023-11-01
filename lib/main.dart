import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jujoy/postInsta.dart';
import 'package:jujoy/product_list.dart';
import 'package:jujoy/screenshotImage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configurações do Firebase
  FirebaseOptions firebaseOptions = const FirebaseOptions(
      apiKey: "AIzaSyAe9XqriflHRlev7Nf0WzggMsD5qyZfxYU",
      authDomain: "jujoy-2ac05.firebaseapp.com",
      projectId: "jujoy-2ac05",
      storageBucket: "jujoy-2ac05.appspot.com",
      messagingSenderId: "666626859725",
      appId: "1:666626859725:web:0f8eaf9dde6624120e3f84",
      measurementId: "G-2WEN1KTB4F");

  await Firebase.initializeApp(
      options:
      firebaseOptions); // Certifique-se de inicializar o Firebase primeiro
  runApp(MaterialApp(home: screenshotScreen()));
}