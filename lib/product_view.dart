import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jujoy/product_edit.dart';

class productView extends StatefulWidget {
  final String docId;

  productView({required this.docId});

  @override
  _productViewState createState() => _productViewState();
}

class _productViewState extends State<productView> {

  String docRefined = '';
  List<dynamic> tamanhoRefined = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final screenSizeWidth = MediaQuery.of(context).size.width;
    final screenSizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Visualização do produto'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              StreamBuilder(
                stream: _firestore
                    .collection('produtos')
                    .doc(widget.docId)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Indicador de carregamento enquanto os dados estão sendo buscados
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text(
                        'Documento não encontrado'); // Caso o documento não exista
                  }

                  var data = snapshot.data!;

                  docRefined = data.id;
                  tamanhoRefined = data['tamanho'];

                  return Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenSizeWidth * 0.5,
                          child: Image.network(data['imageUrl']),
                        ),
                        Text('Nome: ${data['nome']}'),
                        Text('Valor: ${data['precoVenda']}'),
                        Text('Tamanho: ${data['tamanho']}'),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print(docRefined);
          Navigator.push(
          context, MaterialPageRoute(builder: (context) => productEdit(docId: docRefined, tamanho: tamanhoRefined,)));
        },
        icon: const Icon(Icons.edit),
        label: const Text('Editar Produto'),
      ),
    );
  }
}
