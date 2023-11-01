import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class screenshotScreen extends StatefulWidget {
  @override
  _screenshotScreenState createState() => _screenshotScreenState();
}

class _screenshotScreenState extends State<screenshotScreen> {
  GlobalKey globalKey = GlobalKey();
  img.Image? image;

  Future<void> _captureAndConvertToImage() async {
    try {
      RenderRepaintBoundary boundary =
      globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image? uiImage = await boundary.toImage(pixelRatio: 3.0);
      if (uiImage != null) {
        ByteData? byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          Uint8List pngBytes = byteData.buffer.asUint8List();
          img.Image? capturedImage = img.decodeImage(Uint8List.fromList(pngBytes));
          setState(() {
            image = capturedImage;
          });

          // Salvar a imagem capturada como um arquivo temporário
          if (capturedImage != null) {
            // Obtenha o diretório temporário do sistema
            String tempPath = (await getTemporaryDirectory()).path;
            String imagePath = '$tempPath/captured_image.png';

            // Salvar a imagem capturada no arquivo temporário
            File(imagePath).writeAsBytesSync(Uint8List.fromList(img.encodePng(capturedImage)));

            // Compartilhar o arquivo temporário usando share_plus
            Share.shareFiles([imagePath], text: 'Compartilhando imagem capturada');
          } else {
            print('Erro ao decodificar a imagem capturada');
          }
        } else {
          print('Erro ao converter para ByteData');
        }
      } else {
        print('Erro ao capturar a imagem');
      }
    } catch (e) {
      print('Erro ao capturar e converter a imagem: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final alturaScreen = MediaQuery.of(context).size.height;
    final larguraScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Capture and Convert'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RepaintBoundary(
                key: globalKey,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        // 'https://firebasestorage.googleapis.com/v0/b/jujoy-2ac05.appspot.com/o/uploads%2Ftst.jpeg?alt=media&token=072c9da3-b63b-4c5a-9393-da4d77fbfd43&_gl=1*n5xt27*_ga*OTQzOTYwNDQ5LjE2OTcwNjY3NzI.*_ga_CW55HF8NVT*MTY5NzUwNjkyOS4xOC4xLjE2OTc1MDY5OTcuNTkuMC4w'),
                          'https://firebasestorage.googleapis.com/v0/b/jujoy-2ac05.appspot.com/o/uploads%2FWhatsApp%20Image%202023-10-16%20at%2016.25.23.jpeg?alt=media&token=c069dcc1-0158-4ae1-a638-1e7af3bc8fa0&_gl=1*mlmhw1*_ga*OTQzOTYwNDQ5LjE2OTcwNjY3NzI.*_ga_CW55HF8NVT*MTY5NzQ5NjM4NS4xNS4wLjE2OTc0OTYzODUuNjAuMC4w'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: 1600,
                  height: 720,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // Texto acima do Container
                      Opacity(
                        opacity: 0.3,
                        child: Padding(
                          padding: EdgeInsets.only(top: alturaScreen * 0.25),
                          child: Image.network(
                              'https://firebasestorage.googleapis.com/v0/b/jujoy-2ac05.appspot.com/o/uploads%2Fzyro-image.png?alt=media&token=23dd0c76-f4e1-477a-93ae-3c12de50a5e9&_gl=1*cdz3kt*_ga*OTQzOTYwNDQ5LjE2OTcwNjY3NzI.*_ga_CW55HF8NVT*MTY5NzUwNDk5Mi4xNy4xLjE2OTc1MDUwMDEuNTEuMC4w'),
                        ),
                      ),
                      const Spacer(),
                      // Spacer para empurrar o texto para o final da tela
                      // Conteúdo do Container
                      Container(
                        padding: EdgeInsets.only(
                            left: larguraScreen * 0.045,
                            right: larguraScreen * 0.045,
                            top: alturaScreen * 0.015,
                            bottom: alturaScreen * 0.015),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(0, 0, 0, 0.5),
                          border: Border.all(color: Colors.black54),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            topRight: Radius.circular(5.0),
                            bottomLeft: Radius.circular(5.0),
                            bottomRight: Radius.circular(5.0),
                          ),
                        ),
                        child: Text(
                          'Tamanho',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: alturaScreen * 0.025),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: larguraScreen * 0.045,
                              right: larguraScreen * 0.045,
                              top: alturaScreen * 0.015,
                              bottom: alturaScreen * 0.015),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(0, 0, 0, 0.5),
                            border: Border.all(color: Colors.black54),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                              bottomLeft: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0),
                            ),
                          ),
                          child: Text(
                            'R\$ 330',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _captureAndConvertToImage,
                child: Text('Capture and Convert to Image'),
              ),
              SizedBox(height: 20),
              if (image != null)
                Image.memory(Uint8List.fromList(img.encodePng(image!)))
            ],
          ),
        ),
      ),
    );
  }
}
