import 'package:flutter/material.dart';
import 'package:flutter_project/data/class_data_testing.dart';
import 'package:flutter_project/models/class.dart';

class ClassList extends StatelessWidget {
  const ClassList({super.key});

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Opacity(opacity: 0.5, child: Image.asset('assets/logo2.png')),
          SizedBox(height: 10),
          Text(
            'No Classes',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFFA8A8A8),
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
    if (classDataList.isNotEmpty) {
      content = ListView.builder(
        itemCount: classDataList.length,
        itemBuilder: (context, index) =>
            ClassTile(classroom: classDataList[index]),
      );
    }

    return content;
  }
}

class ClassTile extends StatelessWidget {
  const ClassTile({super.key, required this.classroom});
  final Class classroom;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        classroom.name,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}