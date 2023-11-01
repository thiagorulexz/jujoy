import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jujoy/filtrosProductList.dart';
import 'package:jujoy/product_add.dart';
import 'package:jujoy/product_view.dart';

class ClothingSearch extends StatefulWidget {
  @override
  _ClothingSearchState createState() => _ClothingSearchState();
}

class _ClothingSearchState extends State<ClothingSearch> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _textEditingController = TextEditingController();

  QuerySnapshot? _querySnapshot;

  void _performSearch() async {
    String tamanho = _textEditingController.text.toUpperCase();

    QuerySnapshot querySnapshot = await _firestore
        .collection('produtos')
        .where('tamanho', arrayContains: tamanho)
        .get();

    setState(() {
      _querySnapshot = querySnapshot;
    });
  }

  void _fetchAll() async {
    QuerySnapshot querySnapshot = await _firestore.collection('produtos').get();

    setState(() {
      _querySnapshot = querySnapshot;
    });
  }

  void _fetchSearch(String tamanho) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('produtos')
        .where('tamanho', arrayContains: tamanho)
        .get();

    setState(() {
      _querySnapshot = querySnapshot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(
        onFilterSelected: (tamanho) {
          // Aqui você pode chamar a função _fetchAll com o tamanho selecionado
          _fetchSearch(tamanho);
        },
      ),
      appBar: AppBar(
        title: const Text('Lista de Produtos'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _fetchAll();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: EdgeInsets.all(16.0),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: TextField(
          //           controller: _textEditingController,
          //           decoration: InputDecoration(
          //             labelText: 'Digite o tamanho da roupa',
          //             prefixIcon: Icon(Icons.search),
          //           ),
          //           onChanged: (text) {
          //             _performSearch();
          //           },
          //         ),
          //       ),
          //       ElevatedButton(
          //         onPressed: () {
          //           _fetchSearch("1A");
          //         },
          //         child: Text('Filtrar 1A'),
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            child: _querySnapshot != null
                ? ListView.builder(
                    itemCount: _querySnapshot!.docs.length,
                    itemBuilder: (context, index) {
                      var clothing = _querySnapshot!.docs[index];
                      return GestureDetector(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      productView(docId: clothing.id))),
                        },
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                height: 125,
                                child: Image.network(clothing['imageUrl'])),
                            Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Nome: ${clothing['nome']}'),
                                Text('Preço: ${clothing['precoVenda']}'),
                                Text('Tamanho: ${clothing['tamanho']}'),
                              ],
                            ),
                          ],
                        ),
                      );
                      // return ListTile(
                      //   title: Text(clothing['nome']),
                      //   subtitle: Text(clothing['tamanho'].join(', ')),
                      // );
                    },
                  )
                : Container(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => productAdd()));
        },
        icon: const Icon(Icons.add),
        label: const Text('Adicionar'),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchAll();
  }
}
