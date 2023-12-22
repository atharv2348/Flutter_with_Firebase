import 'dart:async';
import 'package:assignment/Model/student.dart';
// import 'package:assignment/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController rollnoController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  final db = FirebaseFirestore.instance;

  addStudent({name, roll_no, location}) async {
    final docRef = db.collection("student").doc(roll_no.toString());
    Student stu = Student(name: name, roll_no: roll_no, location: location);
    await docRef.set(stu.toJson()).then((value) => null);
  }

  deleteStudent({required final id}) async {
    // await db.collection("student").id.delete();
    await db
        .collection("student")
        .doc(id)
        .delete()
        .then((value) => print("Student deleted Sccuessfully!!"));
  }

  updateStudent(
      {required final id,
      required final updatedName,
      required final updatedLocation}) async {
    await db
        .collection("student")
        .doc(id)
        .update({"name": updatedName, "location": updatedLocation});
  }

  Widget readWidget = Text("Specfic data");

  Future<Widget> readSpecificData({required final id}) async {
    final docRef = await db.collection("student").doc(id.toString());

    await docRef.get().then((DocumentSnapshot doc) {
      if (doc.exists) {
        final data = doc.data();

        print(data);
      }
    });

    return SizedBox(
      width: 300,
      height: 200,
      child: StreamBuilder(
        stream: db
            .collection("student")
            .where("roll_no", isEqualTo: id)
            .snapshots(),
        builder: (context, snapshots) {
          if (!snapshots.hasData) {
            return CircularProgressIndicator();
          }

          final data = snapshots.data!.docs;
          List<Row> datalist = [];

          for (var i in data) {
            print(i.data()["name"].toString());
            print(i.data()["roll_no"].toString());
            print(i.data()["location"].toString());

            datalist.add(Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(i.data()["name"].toString()),
                Text(i.data()["roll_no"].toString()),
                Text(i.data()["location"].toString()),
              ],
            ));
          }
          return ListView(children: datalist);
        },
      ),
    );
  }

  static const kBoxDecoration = InputDecoration(
      hintText: 'Event name',
      hintStyle: TextStyle(color: Colors.grey),
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      border: OutlineInputBorder(),
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
      focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)));

  Widget getTextFields(
      {required TextEditingController controller, required String hintText}) {
    return TextField(
        controller: controller,
        onChanged: (value) {
          controller.text = value;
        },
        style: const TextStyle(color: Colors.black),
        decoration: kBoxDecoration.copyWith(hintText: hintText));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            getTextFields(controller: nameController, hintText: "name"),
            getTextFields(controller: rollnoController, hintText: "Roll No"),
            getTextFields(controller: locationController, hintText: "Location"),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  try {
                    await addStudent(
                        name: nameController.text,
                        location: locationController.text,
                        roll_no: int.parse(rollnoController.text));
                    print("Student added Successfully!!");
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text("Add")),
            SizedBox(height: 5),
            ElevatedButton(
                onPressed: () {
                  deleteStudent(id: rollnoController.text);
                },
                child: Text("delete")),
            SizedBox(height: 5),
            ElevatedButton(onPressed: () {}, child: Text("Read All")),
            SizedBox(height: 5),
            ElevatedButton(
                onPressed: () {
                  updateStudent(
                      id: rollnoController.text,
                      updatedName: nameController.text,
                      updatedLocation: locationController.text);
                },
                child: Text("Update")),
            SizedBox(height: 5),
            ElevatedButton(
                onPressed: () {
                  readSpecificData(id: rollnoController.text);
                },
                child: Text("Read specific")),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: Text("SignOut"),
            ),
            SizedBox(
              width: 300,
              height: 500,
              child: StreamBuilder(
                stream: db
                    .collection("student")
                    // .where("location", isEqualTo: "Kolhapur")
                    // .orderBy("roll_no")
                    .snapshots(),
                builder: (context, snapshots) {
                  if (!snapshots.hasData) {
                    return CircularProgressIndicator();
                  }

                  final data = snapshots.data!.docs;
                  List<Row> datalist = [];

                  for (var i in data) {
                    // datalist.add(Text(i.data()["name"].toString()));
                    datalist.add(Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(i.data()["name"].toString()),
                        Text(i.data()["roll_no"].toString()),
                        Text(i.data()["location"].toString()),
                      ],
                    ));
                  }
                  return ListView(children: datalist);
                },
              ),
            ),
            readWidget
          ]),
        ),
      ),
    );
  }
}
