import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jujoy/product_add.dart';

class productList extends StatelessWidget {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Consulta no Firestore',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Consulta no Firestore'),
          // actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
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
                return const Text(
                    'Humane dado encontrado'); // Trata o caso em que não há dados na coleção
              } else {
                // Obtém a lista de documentos da coleção
                var documentos = snapshot.data?.docs ?? [];

                // Construa sua interface com base nos documentos
                return ListView.builder(
                  itemCount: documentos.length,
                  itemBuilder: (context, index) {
                    var document = documentos[index];
                    var name =
                    document['name']; // Obtém o campo 'name' do documento
                    return ListTile(
                      title: Text('Nome: $name'),
                    );
                  },
                );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => productAdd()));
          },
          icon: const Icon(Icons.add),
          label: const Text('Adicionar'),
        ),
      ),
    );
  }
}
