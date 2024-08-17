// ignore_for_file: prefer_const_constructors

import 'package:employee_form/service/database.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class EmployeeForm extends StatelessWidget {
  EmployeeForm({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  bool validateFields() {
    return nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        ageController.text.isNotEmpty;
  }

  void clearFields() {
    nameController.clear();
    phoneController.clear();
    addressController.clear();
    ageController.clear();
  }

  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("Please fill in all fields"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void saveData(BuildContext context) async {
    if (!validateFields()) {
      showErrorDialog(context);
      return;
    }

    String id = randomAlphaNumeric(10);
    Map<String, dynamic> employeeInfo = {
      "name": nameController.text,
      "phone": phoneController.text,
      "address": addressController.text,
      "age": ageController.text,
      "id": id,
    };

    await EmployeeData().addEmployeeData(employeeInfo, id).then((onValue) {
      clearFields();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Data is saved successfully"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to save data"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text.rich(
          TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: "Employee ",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.amber,
                  fontStyle: FontStyle.italic,
                ),
              ),
              TextSpan(
                text: " Form",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              "Please enter all the details carefully",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 52),
            CustomTextField(controller: nameController, labelText: "Name"),
            SizedBox(height: 24),
            CustomTextField(
                controller: phoneController, labelText: "Phone number"),
            SizedBox(height: 24),
            CustomTextField(
                controller: addressController, labelText: "Address"),
            SizedBox(height: 24),
            CustomTextField(controller: ageController, labelText: "Age"),
            Spacer(),
            ElevatedButton(
              onPressed: () => saveData(context),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "Save",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final double borderRadius;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.borderRadius = 12.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
