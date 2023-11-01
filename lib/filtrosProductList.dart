import 'package:flutter/material.dart';
import 'package:jujoy/functions.dart';

class NavDrawer extends StatefulWidget {
  final Function(String) onFilterSelected;

  const NavDrawer({super.key, required this.onFilterSelected});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> with TickerProviderStateMixin {
  bool _isExpandedBebe = false;
  bool _isExpandedCrianca = false;
  bool _isExpandedAdulto = false;
  late AnimationController _animationControllerBebe;
  late Animation<double> _slideAnimationBebe;
  late Animation<double> _fadeAnimationBebe;
  late AnimationController _animationControllerCrianca;
  late Animation<double> _slideAnimationCrianca;
  late Animation<double> _fadeAnimationCrianca;
  late AnimationController _animationControllerAdulto;
  late Animation<double> _slideAnimationAdulto;
  late Animation<double> _fadeAnimationAdulto;

  @override
  void initState() {
    super.initState();

    _animationControllerBebe = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimationBebe = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationControllerBebe,
        curve: Curves.easeInOut,
      ),
    );

    _fadeAnimationBebe = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationControllerBebe,
        curve: Curves.easeInOut,
      ),
    );

    _animationControllerCrianca = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimationCrianca = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationControllerCrianca,
        curve: Curves.easeInOut,
      ),
    );
    _fadeAnimationCrianca = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationControllerCrianca,
        curve: Curves.easeInOut,
      ),
    );

    _animationControllerAdulto = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimationAdulto = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationControllerAdulto,
        curve: Curves.easeInOut,
      ),
    );
    _fadeAnimationAdulto = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationControllerAdulto,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _toggleExpandedBebe() {
    setState(() {
      _isExpandedBebe = !_isExpandedBebe;
      if (_isExpandedBebe) {
        _animationControllerBebe.forward();
      } else {
        _animationControllerBebe.reverse();
      }
    });
  }

  void _toggleExpandedCrianca() {
    setState(() {
      _isExpandedCrianca = !_isExpandedCrianca;
      if (_isExpandedCrianca) {
        _animationControllerCrianca.forward();
      } else {
        _animationControllerCrianca.reverse();
      }
    });
  }

  void _toggleExpandedAdulto() {
    setState(() {
      _isExpandedAdulto = !_isExpandedAdulto;
      if (_isExpandedAdulto) {
        _animationControllerAdulto.forward();
      } else {
        _animationControllerAdulto.reverse();
      }
    });
  }

  List<List<int>> buttonGroupsBebe = tamanhosRoupas.buttonGroupsBebe;
  List buttonGroupsCrianca = tamanhosRoupas.buttonGroupsCrianca;
  List buttonGroupsAdulto = tamanhosRoupas.buttonGroupsAdulto;

  @override
  Widget build(BuildContext context) {
    // final screenSizeWidth = MediaQuery.of(context).size.width;
    // final screenSizeHeight = MediaQuery.of(context).size.height;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/jujoy-2ac05.appspot.com/o/uploads%2F351c581b-6868-4adc-b74a-7258adac2208.jpeg?alt=media&token=4ca0bf09-75f6-4e91-a0b8-c7167d85c552&_gl=1'),
                fit: BoxFit
                    .cover, // Especifica como a imagem deve ser ajustada dentro do contêiner
              ),
              color: Colors.blue,
            ),
            child: Text(
              'Filtros',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          GestureDetector(
            onTap: () {
              _toggleExpandedBebe();
            },
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              width: 200,
              height: _isExpandedBebe ? 200 : 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
              ),
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationControllerBebe,
                  builder: (context, child) {
                    if (_isExpandedBebe) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Roupas de Bebes',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_drop_up),
                                      // Ícone de adição
                                      onPressed: () {
                                        // Lógica quando o ícone for pressionado
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 9.0,
                              runSpacing: 9.0,
                              children:
                                  buttonGroupsBebe.asMap().entries.map((entry) {
                                final groupIndex = entry.key;
                                final groupNumbers = entry.value;
                                final startIndex = groupNumbers.first;
                                final endIndex = groupNumbers.last;
                                final tamanho = 'B${endIndex}';
                                return FadeTransition(
                                  opacity: _fadeAnimationBebe,
                                  child: Transform.translate(
                                    offset:
                                        Offset(0.0, _slideAnimationBebe.value),
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        widget.onFilterSelected(tamanho);
                                        Navigator.pop(
                                          context,
                                        ); // Fecha o menu lateral após a seleção
                                      },
                                      fillColor: Colors.blue,
                                      shape: const CircleBorder(),
                                      elevation: 0,
                                      constraints: BoxConstraints.tight(
                                          const Size(50, 50)),
                                      child: Center(
                                        child: Text(
                                          '$startIndex - $endIndex',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Roupas de Bebes',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(Icons.arrow_drop_down),
                                // Ícone de adição
                                onPressed: () {
                                  // Lógica quando o ícone for pressionado
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _toggleExpandedCrianca();
            },
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              width: 200,
              height: _isExpandedCrianca ? 300 : 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
              ),
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationControllerCrianca,
                  builder: (context, child) {
                    if (_isExpandedCrianca) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Roupas de Crianças',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_drop_up),
                                      // Ícone de adição
                                      onPressed: () {
                                        // Lógica quando o ícone for pressionado
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 9.0,
                              runSpacing: 9.0,
                              children: buttonGroupsCrianca
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final groupIndex = entry.key;
                                final groupNumbers = entry.value;
                                final startIndex = groupNumbers.first;
                                final tamanho = 'C${startIndex}';
                                return FadeTransition(
                                  opacity: _fadeAnimationCrianca,
                                  child: Transform.translate(
                                    offset: Offset(
                                        0.0, _slideAnimationCrianca.value),
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        widget.onFilterSelected(tamanho);
                                        Navigator.pop(
                                          context,
                                        ); // Fecha o menu lateral após a seleção
                                      },
                                      fillColor: Colors.blue,
                                      shape: const CircleBorder(),
                                      elevation: 0,
                                      constraints: BoxConstraints.tight(
                                          const Size(50, 50)),
                                      child: Center(
                                        child: Text(
                                          '$startIndex',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Roupas de Crianças',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(Icons.arrow_drop_down),
                                // Ícone de adição
                                onPressed: () {
                                  // Lógica quando o ícone for pressionado
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _toggleExpandedAdulto();
            },
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOut,
              width: 200,
              height: _isExpandedAdulto ? 480 : 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
              ),
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationControllerAdulto,
                  builder: (context, child) {
                    if (_isExpandedAdulto) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Roupas de Adultos',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_drop_up),
                                      // Ícone de adição
                                      onPressed: () {
                                        // Lógica quando o ícone for pressionado
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 9.0,
                              runSpacing: 9.0,
                              children: buttonGroupsAdulto
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final groupIndex = entry.key;
                                final groupNumbers = entry.value;
                                final startIndex = groupNumbers.first;
                                final tamanho = 'A${startIndex}';
                                return FadeTransition(
                                  opacity: _fadeAnimationAdulto,
                                  child: Transform.translate(
                                    offset: Offset(
                                        0.0, _slideAnimationAdulto.value),
                                    child: RawMaterialButton(
                                      onPressed: () {
                                        widget.onFilterSelected(tamanho);
                                        Navigator.pop(
                                          context,
                                        ); // Fecha o menu lateral após a seleção
                                      },
                                      fillColor: Colors.blue,
                                      shape: const CircleBorder(),
                                      elevation: 0,
                                      constraints: BoxConstraints.tight(
                                          const Size(50, 50)),
                                      child: Center(
                                        child: Text(
                                          '$startIndex',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Roupas de Adultos',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(Icons.arrow_drop_down),
                                // Ícone de adição
                                onPressed: () {
                                  // Lógica quando o ícone for pressionado
                                },
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text('Teste'),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
