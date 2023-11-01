import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

// class appFuncions {
//
// }

class appFunctions extends StatefulWidget {
  @override
  _appFunctionsState createState() => _appFunctionsState();
}

class _appFunctionsState extends State<appFunctions> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

class tamanhosRoupas {

  static List<List<int>> buttonGroupsBebe = [
    [0, 3],
    [3, 6],
    [6, 9],
    [9, 12],
    [12, 18],
    [18, 24],
    [24, 36],
  ];

  static List buttonGroupsCrianca = [
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

  static List buttonGroupsAdulto = [
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

}

class categoriasRoupas{
  static List categoriaRoupas = [
    ['body'],
    ['blusa'],
    ['vestido'],
    ['calcaJean'],
    ['saia'],
    ['short'],
    ['calcado'],
  ];
}

class drawerApp {

}