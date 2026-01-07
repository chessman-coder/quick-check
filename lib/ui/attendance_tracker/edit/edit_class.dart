import 'package:flutter/material.dart';
import 'package:flutter_project/data/class_service.dart';
import 'package:flutter_project/models/class.dart';
import 'package:flutter_project/models/student.dart';

class EditClassList extends StatefulWidget {
  const EditClassList({super.key});

  @override
  State<EditClassList> createState() => _EditClassListState();
}

class _EditClassListState extends State<EditClassList> {
  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Opacity(opacity: 0.5, child: Image.asset('assets/logo2.png')),
          const SizedBox(height: 10),
          const Text(
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

    if (ClassService.classes.isNotEmpty) {
      content = ListView.builder(
        itemCount: ClassService.classes.length,
        itemBuilder: (context, index) {
          final classroom = ClassService.classes[index];
          return _EditClassTile(
            classroom: classroom,
            onEditComplete: () {
              setState(() {});
            },
          );
        },
      );
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Select a class to edit',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xFF858585),
            ),
          ),
        ),
        Expanded(child: content),
      ],
    );
  }
}

class _EditClassTile extends StatelessWidget {
  const _EditClassTile({required this.classroom, required this.onEditComplete});

  final Class classroom;
  final VoidCallback onEditComplete;

  @override
  Widget build(BuildContext context) {
    final int studentCount = ClassService.getStudentsByClassId(
      classroom.id,
    ).length;

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EditClassForm(classId: classroom.id, className: classroom.name),
          ),
        );
        onEditComplete();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF5597FF), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Row(
            children: [
              const Icon(Icons.edit, color: Color(0xFF5597FF)),
              const SizedBox(width: 12),
              Text(
                classroom.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                'Students: $studentCount',
                style: const TextStyle(fontSize: 12, color: Color(0xFF858585)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditClassForm extends StatefulWidget {
  final String classId;
  final String className;

  const EditClassForm({
    super.key,
    required this.classId,
    required this.className,
  });

  @override
  State<EditClassForm> createState() => _EditClassFormState();
}

class _EditClassFormState extends State<EditClassForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _classNameController;
  List<_StudentController> _studentControllers = [];

  @override
  void initState() {
    super.initState();
    _classNameController = TextEditingController(text: widget.className);
    _loadStudents();
  }

  void _loadStudents() {
    final students = ClassService.getStudentsByClassId(widget.classId);
    _studentControllers = students
        .map(
          (s) => _StudentController(
            id: s.id,
            controller: TextEditingController(text: s.name),
          ),
        )
        .toList();

    // Add at least one empty field if no students
    if (_studentControllers.isEmpty) {
      _studentControllers.add(
        _StudentController(id: null, controller: TextEditingController()),
      );
    }
  }

  void _addStudent() {
    setState(() {
      _studentControllers.add(
        _StudentController(id: null, controller: TextEditingController()),
      );
    });
  }

  void _removeStudent(int index) {
    if (_studentControllers.length > 1) {
      setState(() {
        _studentControllers[index].controller.dispose();
        _studentControllers.removeAt(index);
      });
    }
  }

  Future<void> _saveChanges() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String className = _classNameController.text.trim();

    if (className.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a class name')),
      );
      return;
    }

    // Build updated student list
    List<Student> updatedStudents = [];
    for (var sc in _studentControllers) {
      final name = sc.controller.text.trim();
      if (name.isNotEmpty) {
        updatedStudents.add(
          Student(
            id: sc.id ?? ClassService.generateId(),
            name: name,
            classId: widget.classId,
          ),
        );
      }
    }

    if (updatedStudents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one student')),
      );
      return;
    }

    await ClassService.updateClass(widget.classId, className, updatedStudents);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Class "$className" updated successfully')),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _classNameController.dispose();
    for (var sc in _studentControllers) {
      sc.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, size: 32),
                  ),
                  const Expanded(
                    child: Text(
                      'Edit Class',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Class Name Field
                      const Text('Class Name', style: TextStyle(fontSize: 15)),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _classNameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Class name is required';
                          }
                          if (value.trim().length <= 4) {
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
                            'Students (${_studentControllers.length})',
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
                        _studentControllers.length,
                        (index) => _buildStudentField(index),
                      ),

                      const SizedBox(height: 30),

                      // Save Button
                      Center(
                        child: ElevatedButton(
                          onPressed: _saveChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4976FF),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Save Changes',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
                const SizedBox(height: 5),
                TextFormField(
                  controller: _studentControllers[index].controller,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Student name is required';
                    }
                    if (value.trim().length <= 4) {
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
          if (_studentControllers.length > 1)
            IconButton(
              onPressed: () => _removeStudent(index),
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            ),
        ],
      ),
    );
  }
}

class _StudentController {
  final String? id;
  final TextEditingController controller;

  _StudentController({required this.id, required this.controller});
}
