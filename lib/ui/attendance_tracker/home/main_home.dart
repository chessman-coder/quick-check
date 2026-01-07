import 'package:flutter/material.dart';
import 'package:flutter_project/data/class_service.dart';
import 'package:flutter_project/ui/attendance_tracker/edit/edit_class.dart';
import 'package:flutter_project/ui/attendance_tracker/home/class_list.dart';
import 'package:flutter_project/ui/attendance_tracker/home/create_class.dart';
import 'package:flutter_project/ui/attendance_tracker/search%20screen/search_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  DateTime _selectedData = DateTime.now();

  Future<void> _selectData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedData) {
      setState(() {
        _selectedData = picked;
      });
    }
  }

  void _onTapItem(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onCreate() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateClass()),
    );
    // Refresh the UI after returning from CreateClass
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/quickcheck1.png'),
        backgroundColor: Color(0xFF4976FF),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ClassList(
            key: ValueKey('class_list_${ClassService.classes.length}'),
            selectedDate: _selectedData,
            onSelectDate: () => _selectData(context),
          ),
          SearchScreen(
            selectedDate: _selectedData,
            onSelectDate: () => _selectData(context),
          ),
          EditClassList(
            key: ValueKey('edit_list_${ClassService.classes.length}'),
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? Container(
              margin: const EdgeInsets.only(right: 20, bottom: 20),
              width: 60,
              height: 60,
              child: FloatingActionButton(
                onPressed: _onCreate,
                backgroundColor: Color(0xFF4976FF),
                child: const Icon(Icons.add, color: Colors.white, size: 42),
              ),
            )
          : null,
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
