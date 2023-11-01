import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      measurementId: "G-2WEN1KTB4F"
  );

  await Firebase.initializeApp(options: firebaseOptions); // Certifique-se de inicializar o Firebase primeiro
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consulta no Firestore',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Consulta no Firestore'),
        ),
        body: Center(
          child: StreamBuilder(
            // Substitua 'suaColecao' pelo nome da sua coleção no Firestore
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Mostra um indicador de carregamento enquanto a consulta está em andamento
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData) {
                return const Text('Humane dado encontrado'); // Trata o caso em que não há dados na coleção
              } else {
                // Obtém a lista de documentos da coleção
                var documentos = snapshot.data?.docs ?? [];

                // Construa sua interface com base nos documentos
                return ListView.builder(
                  itemCount: documentos.length,
                  itemBuilder: (context, index) {
                    var document = documentos[index];
                    var name = document['name']; // Obtém o campo 'name' do documento
                    return ListTile(
                      title: Text('Nome: $name'),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}