import 'dart:math';
import 'package:flutter/material.dart';
import 'registration_page.dart';

class StudentEnquiryPage extends StatefulWidget {
  const StudentEnquiryPage({super.key});

  @override
  State<StudentEnquiryPage> createState() => _StudentEnquiryPageState();
}

class _StudentEnquiryPageState extends State<StudentEnquiryPage> {
  final _formKey = GlobalKey<FormState>();

  String? gender;

  // ✅ Controllers Added
  final Map<String, TextEditingController> controllers = {
    "First Name": TextEditingController(),
    "Middle Name": TextEditingController(),
    "Last Name": TextEditingController(),
    "Contact Number": TextEditingController(),
    "Email": TextEditingController(),
    "Address": TextEditingController(),
    "Qualification": TextEditingController(),
    "Required Course": TextEditingController(),
    "Required Location": TextEditingController(),
    "Employee ID": TextEditingController(),
    "Test Score": TextEditingController(),
    "Reference": TextEditingController(),
    "Course Name": TextEditingController(),
  };

  // 🔹 Auto Generate Enquiry Number
  String generateEnquiryNumber() {
    final random = Random();
    int number = 1000 + random.nextInt(9000);
    return "ENQ-$number";
  }

  Widget buildTextField(
      String label,
      IconData icon, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controllers[label],
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please enter $label";
          }

          value = value.trim();

          if (label.contains("Name")) {
            if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
              return "Only letters allowed in $label";
            }
          }

          if (label == "Contact Number") {
            if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
              return "Enter valid 10-digit Contact Number";
            }
          }

          if (label == "Email") {
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                .hasMatch(value)) {
              return "Enter valid Email address";
            }
          }

          if (label == "Test Score") {
            int? score = int.tryParse(value);
            if (score == null) {
              return "Enter numeric score only";
            }
            if (score < 0 || score > 100) {
              return "Score must be between 0 and 100";
            }
          }

          if (label == "Employee ID") {
            if (value.length < 3) {
              return "Employee ID too short";
            }
          }

          return null;
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade100,
          labelText: label,
          labelStyle: const TextStyle(color: Colors.orange),
          prefixIcon: Icon(icon, color: Colors.orange),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
            const BorderSide(color: Colors.orange, width: 2),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [

          // 🔥 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 35, bottom: 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFF8C00),
                  Color(0xFFFFB74D),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Text(
                "Student Enquiry",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [

                    buildTextField("First Name", Icons.person),
                    buildTextField("Middle Name", Icons.person_outline),
                    buildTextField("Last Name", Icons.person),
                    buildTextField("Contact Number", Icons.phone,
                        keyboardType: TextInputType.phone),
                    buildTextField("Email", Icons.email,
                        keyboardType: TextInputType.emailAddress),
                    buildTextField("Address", Icons.location_on),
                    buildTextField("Qualification", Icons.school),
                    buildTextField("Required Course", Icons.menu_book),
                    buildTextField("Required Location", Icons.location_city),
                    buildTextField("Employee ID", Icons.badge),
                    buildTextField("Test Score", Icons.score,
                        keyboardType: TextInputType.number),
                    buildTextField("Reference", Icons.people),
                    buildTextField("Course Name", Icons.book),

                    // 🔥 Gender Dropdown
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: DropdownButtonFormField<String>(
                        value: gender,
                        hint: const Text("Select Gender"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select Gender";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          labelText: "Gender",
                          labelStyle:
                          const TextStyle(color: Colors.black),
                          prefixIcon:
                          const Icon(Icons.wc, color: Colors.orange),
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: ["Male", "Female", "Other"]
                            .map((g) => DropdownMenuItem(
                          value: g,
                          child: Text(g),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 25),

                    // 🔥 Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {

                            // ✅ Create Data Map
                            Map<String, dynamic> enquiryData = {};

                            controllers.forEach((key, controller) {
                              enquiryData[key] = controller.text.trim();
                            });

                            enquiryData["Gender"] = gender!;
                            enquiryData["Student ID"] =
                                generateEnquiryNumber();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    StudentRegistrationPage(
                                        enquiryData: enquiryData),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Go To Registration",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}