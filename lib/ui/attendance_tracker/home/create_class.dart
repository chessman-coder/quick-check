import 'package:flutter/material.dart';
import 'package:flutter_project/data/class_service.dart';

class CreateClass extends StatefulWidget {
  const CreateClass({super.key});

  @override
  State<CreateClass> createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  final _formKey = GlobalKey<FormState>();
  // default setting
  static const defaultClassName = 'New Class';

  final _classNameController = TextEditingController();
  List<TextEditingController> studentControllers = [TextEditingController()];

  void _addStudent() {
    setState(() {
      studentControllers.add(TextEditingController());
    });
  }

  void _removeStudent(int index) {
    if (studentControllers.length > 1) {
      setState(() {
        studentControllers[index].dispose();
        studentControllers.removeAt(index);
      });
    }
  }

  void _createClass() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String className = _classNameController.text.trim();
    List<String> studentNames = studentControllers
        .map((c) => c.text.trim())
        .where((name) => name.isNotEmpty)
        .toList();

    // Validate
    if (className.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a class name')),
      );
      return;
    }

    if (studentNames.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one student')),
      );
      return;
    }

    // Save to JSON file
    await ClassService.createClass(className, studentNames);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Class "$className" created with ${studentNames.length} students',
        ),
      ),
    );

    // Go back
    Navigator.pop(context);
  }

  void onReset() {
    _formKey.currentState!.reset();
  }

  @override
  void initState() {
    super.initState();

    _classNameController.text = defaultClassName;
  }

  @override
  void dispose() {
    _classNameController.dispose();
    for (var controller in studentControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, size: 32),
                ),
                Expanded(
                  child: Text(
                    'Create Class',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 55),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Class Name Field
                    const Text('Class Name', style: TextStyle(fontSize: 15)),
                    const SizedBox(height: 2),
                    TextFormField(
                      controller: _classNameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Class name is required';
                        }
                        if (value.trim().length < 4) {
                          return 'Class name must be more than 4 characters';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Students Section Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Students (${studentControllers.length})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _addStudent,
                          icon: const Icon(Icons.add, size: 20),
                          label: const Text('Add Student'),
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF4976FF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Student Fields
                    ...List.generate(
                      studentControllers.length,
                      (index) => _buildStudentField(index),
                    ),

                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: onReset,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4976FF),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Reset',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: _createClass,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4976FF),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Create Class',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentField(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Student ${index + 1} Name',
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 2),
                TextFormField(
                  controller: studentControllers[index],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Student name is required';
                    }
                    if (value.trim().length < 4) {
                      return 'Name must be more than 4 characters';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (studentControllers.length > 1)
            IconButton(
              onPressed: () => _removeStudent(index),
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            ),
        ],
      ),
    );
  }
}
