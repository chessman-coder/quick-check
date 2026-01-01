import 'package:flutter/material.dart';
import 'package:flutter_project/ui/attendance_tracker/home/class_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  void _onTapItem(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/quickcheck1.png'),
        backgroundColor: Color(0xFF4976FF),
      ),
      body: IndexedStack(index: _currentIndex, children: [
        ClassList()
        ],
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
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFF4976FF),
        onTap: _onTapItem,
        backgroundColor: Color(0xFFEDEDED),
      ),
    );
  }
}