import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jujoy/filtrosProductList.dart';
import 'package:jujoy/product_add.dart';
import 'package:jujoy/product_view.dart';

class appFuncions {
  void _performSearch(TextEditingController controller) async {
    String tamanho = controller.text.toUpperCase();

    QuerySnapshot querySnapshot = await _firestore
        .collection('produtos')
        .where('tamanho', arrayContains: tamanho)
        .get();

    setState(() {
      _querySnapshot = querySnapshot;
    });
  }
}