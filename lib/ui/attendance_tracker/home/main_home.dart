import 'package:flutter/material.dart';
import 'package:flutter_project/data/class_data_testing.dart';
import 'package:flutter_project/models/class.dart';
import 'package:flutter_project/ui/attendance_tracker/home/class_list.dart';

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
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
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

  void _onCreate() {
    _showCreateClassDialog(context);
  }

  void _showCreateClassDialog(BuildContext context) {
    final TextEditingController classNameController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Class'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: classNameController,
              decoration: const InputDecoration(
                labelText: 'Class Name',
                hintText: 'Enter class name',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a class name';
                }
                if (value.trim().length < 2) {
                  return 'Class name must be at least 2 characters';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final String className = classNameController.text.trim();
                  _createClass(className);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Class "$className" created successfully!'),
                      backgroundColor: const Color(0xFF4CAF50),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4976FF),
              ),
              child: const Text('Create', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _createClass(String className) {
    // Generate a unique ID for the new class using timestamp
    final String newId = 'a${DateTime.now().millisecondsSinceEpoch}';
    final Class newClass = Class(id: newId, name: className);
    
    setState(() {
      classDataList.add(newClass);
    });
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
            selectedDate: _selectedData,
            onSelectDate: () => _selectData(context),
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
