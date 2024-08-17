import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeData {
  Future addEmployeeData(Map<String, dynamic> employeeInfo, String id) async {
    return await FirebaseFirestore.instance
        .collection("Employee")
        .doc(id)
        .set(employeeInfo);
  }

  Future<Stream<QuerySnapshot>> getallEmployeeData() async {
    return FirebaseFirestore.instance.collection("Employee").snapshots();
  }

  Future updateEmployeeDetail(
      String id, Map<String, dynamic> updateInfo) async {
    await FirebaseFirestore.instance
        .collection("Employee")
        .doc(id)
        .update(updateInfo);
  }

  Future deleteEmployeeDetail(String id) async {
    FirebaseFirestore.instance.collection("Employee").doc(id).delete();
  }
}
