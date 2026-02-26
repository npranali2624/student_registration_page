import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StudentRegistrationPage extends StatefulWidget {
  final Map<String, dynamic> enquiryData;

  const StudentRegistrationPage({
    super.key,
    required this.enquiryData,
  });

  @override
  State<StudentRegistrationPage> createState() =>
      _StudentRegistrationPageState();
}

class _StudentRegistrationPageState
    extends State<StudentRegistrationPage> {

  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> controllers = {};

  Uint8List? photoBytes;
  Uint8List? signatureBytes;

  @override
  void initState() {
    super.initState();

    List<String> fields = [
      "Student ID",
      "First Name",
      "Middle Name",
      "Last Name",
      "Contact",
      "Email",
      "Address",
      "Qualification",
      "Required Course",
      "Required Location",
      "Employee ID",
      "Course ID",
      "Parent Name",
      "Parent Contact",
      "Parent Occupation",
      "Grade/Percentage",
    ];

    for (var field in fields) {
      controllers[field] =
          TextEditingController(text: widget.enquiryData[field] ?? "");
    }
  }

  // ✅ IMAGE PICKER
  Future<void> pickImage(bool isPhoto) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image =
    await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        if (isPhoto) {
          photoBytes = bytes;
        } else {
          signatureBytes = bytes;
        }
      });
    }
  }

  // ✅ TEXT FIELD BUILDER
  Widget buildTextField(
      String label,
      IconData icon, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    bool isAutoFilled = widget.enquiryData.containsKey(label);

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controllers[label],
        readOnly: isAutoFilled,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please enter $label";
          }

          value = value.trim();

          // Name validation
          if (label.contains("Name")) {
            if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
              return "Only letters allowed";
            }
          }

          // Email validation
          if (label == "Email") {
            if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                .hasMatch(value)) {
              return "Enter valid email";
            }
          }

          // Contact validation
          if (label.contains("Contact")) {
            if (!RegExp(r'^[0-9]{10}$')
                .hasMatch(value)) {
              return "Enter valid 10-digit number";
            }
          }

          // Grade OR Percentage validation
          if (label == "Grade/Percentage") {
            String input = value.trim();

            double? number = double.tryParse(input);

            if (number != null) {
              if (number < 0 || number > 100) {
                return "Enter valid percentage (0-100)";
              }
            } else {
              if (!RegExp(r'^[A-Za-z+ ]+$')
                  .hasMatch(input)) {
                return "Enter valid Grade (A, B+, Distinction)";
              }
            }
          }

          return null;
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: isAutoFilled
              ? Colors.grey.shade300
              : Colors.grey.shade100,
          labelText: label,
          labelStyle:
          const TextStyle(color: Colors.orange),
          prefixIcon:
          Icon(icon, color: Colors.orange),
          border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(12),
            borderSide: const BorderSide(
                color: Colors.orange, width: 2),
          ),
        ),
      ),
    );
  }

  // ✅ IMAGE UI
  Widget buildImagePicker({
    required String title,
    required Uint8List? imageBytes,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius:
              BorderRadius.circular(12),
              border:
              Border.all(color: Colors.orange),
            ),
            child: imageBytes == null
                ? const Center(
              child: Text(
                  "Tap to Select Image"),
            )
                : Image.memory(
              imageBytes,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
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

          // HEADER
          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.only(top: 35, bottom: 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFF8C00),
                  Color(0xFFFFB74D),
                ],
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.white),
                  onPressed: () =>
                      Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Student Registration",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [

                    buildTextField("Student ID", Icons.badge),
                    buildTextField("First Name", Icons.person),
                    buildTextField("Middle Name", Icons.person_outline),
                    buildTextField("Last Name", Icons.person),
                    buildTextField("Contact", Icons.phone,
                        keyboardType: TextInputType.phone),
                    buildTextField("Email", Icons.email,
                        keyboardType: TextInputType.emailAddress),
                    buildTextField("Address", Icons.location_on),
                    buildTextField("Qualification", Icons.school),
                    buildTextField("Required Course", Icons.menu_book),
                    buildTextField("Required Location", Icons.location_city),
                    buildTextField("Employee ID", Icons.badge),
                    buildTextField("Course ID", Icons.book),
                    buildTextField("Parent Name", Icons.person),
                    buildTextField("Parent Contact", Icons.phone,
                        keyboardType: TextInputType.phone),
                    buildTextField("Parent Occupation", Icons.work),
                    buildTextField("Grade/Percentage", Icons.score),

                    const SizedBox(height: 10),

                    buildImagePicker(
                      title: "Student Photo",
                      imageBytes: photoBytes,
                      onTap: () => pickImage(true),
                    ),

                    buildImagePicker(
                      title: "Signature",
                      imageBytes: signatureBytes,
                      onTap: () => pickImage(false),
                    ),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          Colors.orange,
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!
                              .validate() &&
                              photoBytes != null &&
                              signatureBytes != null) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Registration Submitted Successfully"),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Please select Photo & Signature"),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Register",
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