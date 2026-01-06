import 'package:flutter/material.dart';

class CreateClass extends StatefulWidget {
  const CreateClass({super.key});

  @override
  State<CreateClass> createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  // Controllers to manage input fields
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController totalStudentsController = TextEditingController();
  List<TextEditingController> studentController = [];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            color: const Color(0xFF4976FF),
            child: SafeArea(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset('assets/quickcheck1.png', height: 35),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                    padding: const EdgeInsets.all(20),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Create Class',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 55),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Class Name',
                              style: TextStyle(fontSize: 15),
                            ),
                            const SizedBox(height: 2),
                            TextField(
                              controller: classNameController,
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
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Students',
                              style: TextStyle(fontSize: 15),
                            ),
                            const SizedBox(height: 2),
                            TextField(
                              controller: totalStudentsController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                _generateStudentFields(int.tryParse(value) ?? 0);
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
                    ],
                  ),
                  const SizedBox(height: 25),

                  //gnr stu fields
                  ...List.generate(
                    studentController.length,
                    (index) => _buildStudentField('Student ${index + 1} Name', studentController[index]),
                  ),

                  const SizedBox(height: 25),

                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        String className = classNameController.text;
                        String totalStudents = totalStudentsController.text;

                        List<String> studentNames = [];
                        for (var controller in studentController) {
                          if (controller.text.isNotEmpty) {
                            studentNames.add(controller.text);
                          }
                        }

                        print('Class Name: $className');
                        print('Total Students: $totalStudents');
                        print('Student Names: $studentNames');
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4976FF),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
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
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFF4976FF),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Edit Class'),
        ],
      ),
    );
  }

  //gnr stu field base on total count
  void _generateStudentFields(int count) { 
    setState(() {
      //then dispose all controllers
      for (var controller in studentController){
        controller.dispose();
      }
      //create new controllers base on count
      studentController = List.generate(
        count, (index) => TextEditingController(),
      );
    });
  }

  Widget _buildStudentField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 2),
          TextField(
            controller: controller,
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
    );
  }

  @override
  void dispose() {
    classNameController.dispose();
    totalStudentsController.dispose();
   for (var controller in studentController) {
    controller.dispose();
   }
   super.dispose();
  }
}
