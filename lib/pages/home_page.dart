import 'package:flutter/material.dart';
import 'package:motoguard/pages/info_page.dart';
import 'package:motoguard/pages/settings_page.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final _pageOptions = [new InfoPage(), new SettingsPage()];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.motorcycle_outlined),
            label: 'Información',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes')
        ],
      ),
    );
  }
}
