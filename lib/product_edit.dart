import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

import 'package:jujoy/product_list.dart';

class productEdit extends StatefulWidget {
  final String docId;
  final List<dynamic> tamanho;

  productEdit({required this.docId, required this.tamanho});

  @override
  _productEditState createState() => _productEditState();
}

class _productEditState extends State<productEdit> {
  TextEditingController _nomeController = TextEditingController();
  // final TextEditingController _tamanhoController = TextEditingController();
  TextEditingController _precoControllerVenda = TextEditingController();

  File? _imagem;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _escolherImagem() async {
    XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imagem = File(pickedFile.path);
      }
    });
  }

  Future<void> _editarProduto() async {
    String nome = _nomeController.text;
    // String tamanho = _tamanhoController.text;
    int precoVenda = int.parse(_precoControllerVenda.text);

    String imageUrl;

    // Verifique se _imagem não é nulo antes de usá-lo
    if (_imagem != null) {
      // Faz upload da imagem para o Firebase Storage
      Reference storageReference =
          _firebaseStorage.ref().child('uploads/${DateTime.now()}.png');
      UploadTask uploadTask = storageReference.putFile(
          _imagem!); // Use o operador de não nulo (!) para indicar que _imagem não é nulo

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      imageUrl = await taskSnapshot.ref.getDownloadURL();
    } else {
      // Lidar com a situação em que _imagem é nulo
      imageUrl =
          ''; // Ou qualquer outro valor padrão ou mensagem de erro que faça sentido para o seu aplicativo
    }

    // Adiciona os dados ao Firestore
    await _firestore.collection('produtos').doc(widget.docId).update({
      'nome': nome,
      // 'tamanho': tamanho,
      'precoVenda': precoVenda,
      if(imageUrl.isNotEmpty || imageUrl != '') 'imageUrl': imageUrl,
      // 'imageUrl': imageUrl,
      // if (selectedOptionsBebe.isNotEmpty) 'tamanho': selectedOptionsBebe,
      // if (selectedOptionsCrianca.isNotEmpty) 'tamanho': selectedOptionsCrianca,
      // if (selectedOptionsAdulto.isNotEmpty) 'tamanho': selectedOptionsAdulto,
    });

    // Limpa os controladores de texto e a imagem após o envio do formulário
    _nomeController.clear();
    // _tamanhoController.clear();
    _precoControllerVenda.clear();
    selectedOptionsBebe.clear();
    selectedOptionsCrianca.clear();
    selectedOptionsAdulto.clear();
    isSwitchedBebe = false;
    isSwitchedCrianca = false;
    isSwitchedAdulto = false;
    setState(() {
      _imagem = null;
    });

    // Mostra um snackbar para indicar que o produto foi registrado com sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Produto registrado com sucesso!')),
    );

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClothingSearch()));
  }

  final List<List<int>> buttonGroupsBebe = [
    [0, 3],
    [3, 6],
    [6, 9],
    [9, 12],
    [12, 18],
    [18, 24],
    [24, 36],
  ];

  final List buttonGroupsCrianca = [
    ['PP'],
    ['P'],
    ['M'],
    ['G'],
    ['GG'],
    [4],
    [5],
    [6],
    [7],
    [8],
    [9],
    [10],
    [11],
    [12],
    [13],
    [14],
    [15],
  ];

  final List buttonGroupsAdulto = [
    ['PP'],
    ['P'],
    ['M'],
    ['G'],
    ['GG'],
    [16],
    [17],
    [18],
    [19],
    [20],
    [21],
    [22],
    [23],
    [24],
    [25],
    [26],
    [27],
    [28],
    [29],
    [30],
    [31],
    [32],
    [33],
    [34],
    [35],
    [36],
    [37],
    [38],
    [39],
    [40],
    [41],
    [42],
    [43],
    [44],
    [45],
    [46],
  ];

  List<String> selectedOptionsBebe = [];
  List<String> selectedOptionsCrianca = [];
  List<String> selectedOptionsAdulto = [];

  void _toggleSelectionBebe(String option) {
    setState(() {
      if (selectedOptionsBebe.contains(option)) {
        selectedOptionsBebe.remove(option);
      } else {
        selectedOptionsBebe.add(option);
      }
    });
  }

  void _toggleSelectionCrianca(String option) {
    setState(() {
      if (selectedOptionsCrianca.contains(option)) {
        selectedOptionsCrianca.remove(option);
      } else {
        selectedOptionsCrianca.add(option);
      }
    });
  }

  void _toggleSelectionAdulto(String option) {
    setState(() {
      if (selectedOptionsAdulto.contains(option)) {
        selectedOptionsAdulto.remove(option);
      } else {
        selectedOptionsAdulto.add(option);
      }
    });
  }

  bool isSwitchedBebe = false;
  bool isSwitchedCrianca = false;
  bool isSwitchedAdulto = false;

  Future<DocumentSnapshot> fetchData() async {
    // Consulte os dados do Firestore e retorne o documento
    return _firestore.collection('produtos').doc(widget.docId).get();
  }

  late Future<DocumentSnapshot> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchData();
    _toggleSelectionBebe(widget.tamanho[0]);
  }

  @override
  Widget build(BuildContext context) {
    final screenSizeWidth = MediaQuery.of(context).size.width;
    final screenSizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de produto'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  SizedBox(
                    width: screenSizeWidth * 0.3,
                    child: ElevatedButton(
                      onPressed: _escolherImagem,
                      child: Text('Escolher Imagem'),
                    ),
                  ),
                  SizedBox(
                    height: screenSizeWidth * 0.3,
                    child: _imagem != null ? Image.file(_imagem!) : Container(),
                  ),
                ],
              ),
              FutureBuilder(
                future: _dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // Indicador de carregamento enquanto os dados estão sendo buscados
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text('Documento não encontrado'); // Caso o documento não exista
                  }

                  var data = snapshot.data as DocumentSnapshot;

                  TextEditingController _oldName = TextEditingController(text: data['nome']);

                  return Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenSizeWidth * 0.2,
                          child: Image.network(data['imageUrl']),
                        ),
                        TextField(
                          controller: _oldName,
                          onChanged: (text) {
                            // Atualize o _nomeController apenas quando o usuário terminar de editar o texto
                            _nomeController.text = text;
                          },
                          decoration: InputDecoration(labelText: 'Nome'),
                        ),
                        // TextField(
                        //   controller: _tamanhoController,
                        //   decoration: InputDecoration(labelText: 'Tamanho'),
                        // ),
                        TextField(
                          onChanged: (text) {
                            _precoControllerVenda.text = text;
                          },
                          controller: TextEditingController(
                              text: data['precoVenda'].toString()),
                          decoration:
                              InputDecoration(labelText: 'Preço Venda'),
                          // keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: TextEditingController(
                              text: 'Tamanho: ${widget.tamanho[0]}'),
                          enabled: false,
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              Text('Roupas de Bebes'),
              SizedBox(height: 20),
              Switch(
                value: isSwitchedBebe,
                onChanged: (value) {
                  setState(() {
                    isSwitchedBebe = value;
                    print(isSwitchedBebe);
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
              isSwitchedBebe != true
                  ? Container()
                  : Wrap(
                      spacing: 9.0,
                      runSpacing: 9.0,
                      children: buttonGroupsBebe.asMap().entries.map((entry) {
                        final groupNumbersBebe = entry.value;
                        final startIndex = groupNumbersBebe.first;
                        final endIndex = groupNumbersBebe.last;
                        final tamanho = groupNumbersBebe.last;
                        return RawMaterialButton(
                          onPressed: () {
                            _toggleSelectionBebe('B${tamanho.toString()}');
                          },
                          fillColor: selectedOptionsBebe.contains('B$tamanho')
                              ? Colors.green
                              : Colors.blue,
                          shape: const CircleBorder(),
                          elevation: 0,
                          constraints: BoxConstraints.tight(const Size(50, 50)),
                          child: Center(
                            child: Text(
                              '$startIndex - $endIndex',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
              SizedBox(height: 20),
              Text('Roupas de Crianças'),
              SizedBox(height: 20),
              Switch(
                value: isSwitchedCrianca,
                onChanged: (value) {
                  setState(() {
                    isSwitchedCrianca = value;
                    print(isSwitchedCrianca);
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
              isSwitchedCrianca != true
                  ? Container()
                  : Wrap(
                      spacing: 9.0,
                      runSpacing: 9.0,
                      children:
                          buttonGroupsCrianca.asMap().entries.map((entry) {
                        final groupNumbersCrianca = entry.value;
                        final startIndex = groupNumbersCrianca.first;
                        final tamanho = groupNumbersCrianca.first;
                        return RawMaterialButton(
                          onPressed: () {
                            _toggleSelectionCrianca('C${tamanho.toString()}');
                          },
                          fillColor:
                              selectedOptionsCrianca.contains('C$tamanho')
                                  ? Colors.green
                                  : Colors.blue,
                          shape: const CircleBorder(),
                          elevation: 0,
                          constraints: BoxConstraints.tight(const Size(50, 50)),
                          child: Center(
                            child: Text(
                              '$startIndex',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
              SizedBox(height: 20),
              Text('Roupas de Adultos'),
              SizedBox(height: 20),
              Switch(
                value: isSwitchedAdulto,
                onChanged: (value) {
                  setState(() {
                    isSwitchedAdulto = value;
                    print(isSwitchedAdulto);
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
              isSwitchedAdulto != true
                  ? Container()
                  : Wrap(
                      spacing: 9.0,
                      runSpacing: 9.0,
                      children: buttonGroupsAdulto.asMap().entries.map((entry) {
                        final groupNumbersAdulto = entry.value;
                        final startIndex = groupNumbersAdulto.first;
                        final tamanho = groupNumbersAdulto.first;
                        return RawMaterialButton(
                          onPressed: () {
                            _toggleSelectionAdulto('A${tamanho.toString()}');
                          },
                          fillColor: selectedOptionsAdulto.contains('A$tamanho')
                              ? Colors.green
                              : Colors.blue,
                          shape: const CircleBorder(),
                          elevation: 0,
                          constraints: BoxConstraints.tight(const Size(50, 50)),
                          child: Center(
                            child: Text(
                              '$startIndex',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
              ElevatedButton(
                onPressed: _editarProduto,
                child: Text('Registrar Produto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
