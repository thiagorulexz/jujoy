import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class instaPost extends StatelessWidget {

  Future<void> _shareImageToInstagramStories(String imageUrl) async {
    try {
      var response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        File file = File('$tempPath/temp_instagram_story.jpg');

        await file.writeAsBytes(response.bodyBytes);

        final result = await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Legenda do seu post',
        );

        if (result.status == ShareResultStatus.success) {
          print('Obrigado por compartilhar a imagem!');
        }
      } else {
        throw Exception('Falha ao carregar a imagem');
      }
    } catch (e) {
      print('Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram Story Share'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                String imageUrl = 'https://firebasestorage.googleapis.com/v0/b/jujoy-2ac05.appspot.com/o/uploads%2FWhatsApp%20Image%202023-10-16%20at%2016.25.23.jpeg?alt=media&token=c069dcc1-0158-4ae1-a638-1e7af3bc8fa0&_gl=1*oe455*_ga*OTQzOTYwNDQ5LjE2OTcwNjY3NzI.*_ga_CW55HF8NVT*MTY5NzQ4MzkwNS4xNC4xLjE2OTc0ODQxNDkuNDMuMC4w';
                _shareImageToInstagramStories(imageUrl);
              },
              child: Text('Compartilhar no Instagram Story'),
            ),
          ],
        ),
      ),
    );
  }
}
