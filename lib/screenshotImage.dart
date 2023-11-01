import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class screenshotScreen extends StatefulWidget {
  final List<dynamic> tamanho;
  final String imageUrl;
  final int preco;

  screenshotScreen(
      {required this.imageUrl, required this.tamanho, required this.preco});

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
        ByteData? byteData =
            await uiImage.toByteData(format: ui.ImageByteFormat.png);
        if (byteData != null) {
          Uint8List pngBytes = byteData.buffer.asUint8List();
          img.Image? capturedImage =
              img.decodeImage(Uint8List.fromList(pngBytes));
          setState(() {
            image = capturedImage;
          });

          // Salvar a imagem capturada como um arquivo temporário
          if (capturedImage != null) {
            // Obtenha o diretório temporário do sistema
            String tempPath = (await getTemporaryDirectory()).path;
            String imagePath = '$tempPath/captured_image.png';

            // Salvar a imagem capturada no arquivo temporário
            File(imagePath).writeAsBytesSync(
                Uint8List.fromList(img.encodePng(capturedImage)));

            // Compartilhar o arquivo temporário usando share_plus
            Share.shareFiles([imagePath],
                text: 'Compartilhando imagem capturada');
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
        title: Text('Create Edited Image'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RepaintBoundary(
                key: globalKey,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('${widget.imageUrl}'),
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
                          '${widget.tamanho}',
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
                            'R\$ ${widget.preco}',
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
                child: Text('Gerar Imagem'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
