// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_form/service/database.dart';
import 'package:employee_form/ui/employe_form.dart';
import 'package:flutter/material.dart';

class EmployeeDetails extends StatefulWidget {
  const EmployeeDetails({super.key});

  @override
  State<EmployeeDetails> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  Stream<QuerySnapshot>? employeeStream;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  Future<void> getOnTheLoad() async {
    employeeStream = await EmployeeData().getallEmployeeData();
    setState(() {});
  }

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  Widget allEmployeeDetails() {
    return StreamBuilder(
        stream: employeeStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot document = snapshot.data!.docs[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person, color: Colors.purple),
                                SizedBox(width: 8),
                                Text(
                                  document["name"].toString().toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                IconButton(
                                    onPressed: () {
                                      nameController.text = document["name"];
                                      phoneController.text = document["phone"];
                                      addressController.text =
                                          document["address"];
                                      ageController.text = document["age"];
                                      editEmployeeDeatails(document["id"]);
                                    },
                                    icon: Icon(Icons.edit)),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.phone, color: Colors.blueAccent),
                                SizedBox(width: 8),
                                Text(
                                  document["phone"],
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.calendar_month,
                                    color: Colors.orangeAccent),
                                SizedBox(width: 8),
                                Text(
                                  "Age: ${document["age"]}",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.home, color: Colors.greenAccent),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    document["address"],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () async {
                                    await EmployeeData()
                                        .deleteEmployeeDetail(document["id"]);
                                  },
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text.rich(
            TextSpan(children: <TextSpan>[
              TextSpan(
                text: "Employee ",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.amber,
                    fontStyle: FontStyle.italic),
              ),
              TextSpan(
                text: " Details",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontStyle: FontStyle.italic),
              )
            ]),
          ),
        ),
        body: Column(
          children: [
            Expanded(child: allEmployeeDetails()),
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EmployeeForm()));
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: Text(
                        "Add New Employee",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                )),
          ],
        ));
  }

  Future editEmployeeDeatails(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.cancel),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text.rich(
                        TextSpan(children: <TextSpan>[
                          TextSpan(
                            text: "Update ",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.amber,
                                fontStyle: FontStyle.italic),
                          ),
                          TextSpan(
                            text: " Details",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                                fontStyle: FontStyle.italic),
                          )
                        ]),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  CustomTextField(
                      controller: nameController, labelText: "Name"),
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
                    onPressed: () async {
                      Map<String, dynamic> updateInfo = {
                        "name": nameController.text,
                        "phone": phoneController.text,
                        "address": addressController.text,
                        "age": ageController.text,
                        "id": id,
                      };
                      await EmployeeData()
                          .updateEmployeeDetail(id, updateInfo)
                          .then((value) {});
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "update",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
}
