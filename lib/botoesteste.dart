import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SelectionScreen(),
    );
  }
}

class SelectionScreen extends StatefulWidget {
  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  List<String> selectedOptions = [];

  void _toggleSelection(String option) {
    setState(() {
      if (selectedOptions.contains(option)) {
        selectedOptions.remove(option);
      } else {
        selectedOptions.add(option);
      }
    });
  }

  void _sendToFirestore() {
    // Enviar a lista de seleções para o Firestore
    FirebaseFirestore.instance.collection('selecoes').doc('usuario_id').set({
      'selecoes': selectedOptions,
    }).then((value) {
      // Limpar as seleções após o envio
      setState(() {
        selectedOptions.clear();
      });
      // Feedback para o usuário, por exemplo, um SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Seleções enviadas para o Firestore com sucesso!'),
        ),
      );
    }).catchError((error) {
      // Tratar erros, se houver
      print('Erro ao enviar para o Firestore: $error');
    });
  }

  final List<List<int>> buttonGroups = [
    [0, 3],
    [3, 6],
    [6, 9],
    [9, 12],
    [12, 18],
    [18, 24],
    [24, 36],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleção de Opções'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _toggleSelection('P'),
              child: Text('Opção 1'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                selectedOptions.contains('P') ? Colors.green : Colors.blue,
              ),
            ),
            ElevatedButton(
              onPressed: () => _toggleSelection('M'),
              child: Text('Opção 2'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                selectedOptions.contains('M') ? Colors.green : Colors.blue,
              ),
            ),
            ElevatedButton(
              onPressed: () => _toggleSelection('G'),
              child: Text('Opção 3'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                selectedOptions.contains('G') ? Colors.green : Colors.blue,
              ),
            ),
            ElevatedButton(
              onPressed: _sendToFirestore,
              child: Text('Enviar Seleções para o Firestore'),
            ),
            Wrap(
              spacing: 9.0,
              runSpacing: 9.0,
              children: buttonGroups.asMap().entries.map((entry) {
                final groupNumbers = entry.value;
                final startIndex = groupNumbers.first;
                final endIndex = groupNumbers.last;
                final tamanho = groupNumbers.last;
                return RawMaterialButton(
                  onPressed: () {
                    _toggleSelection('$tamanho');
                  },
                  fillColor: selectedOptions.contains('$tamanho')
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
          ],
        ),
      ),
    );
  }
}
