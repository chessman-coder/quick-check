import 'package:flutter/material.dart';

enum Tab { home, search, editClass }

class BottomNavigationbar extends StatefulWidget {
  const BottomNavigationbar({super.key});

  @override
  State<BottomNavigationbar> createState() => _BottomNavigationbarState();
}

class _BottomNavigationbarState extends State<BottomNavigationbar> {
  int _selectedIndex = 0;

  void _onTapItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/quickcheck1.png'),
        backgroundColor: Color(0xFF4976FF),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_square),
            label: 'Edit Class',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF4976FF),
        onTap: _onTapItem,
        backgroundColor: Color(0xFFEDEDED),
        
      ),
    );
  }
}