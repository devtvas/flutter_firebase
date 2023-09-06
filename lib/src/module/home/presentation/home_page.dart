import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? studentName, studentID, studyProgramID;
  double? studentGPA;

  getStudentName(name) {
    studentName = name;
  }

  getStudentID(id) {
    studentID = id;
  }

  getStudyProgramID(programID) {
    studyProgramID = programID;
  }

  getStudentGPA(gpa) {
    studentGPA = double.parse(gpa);
  }

  createData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Students').doc('$studentName');
    //
    Map<String, dynamic> students = {
      'studentName': studentName,
      'studentID': studentID,
      'studyProgramID': studyProgramID,
      'studentGPA': studentGPA,
    };
    //
    documentReference
        .set(students)
        .whenComplete(() => {log("$studentName created")});
  }

  readData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Students').doc('$studentName');
    //
    documentReference.get().then(
      (datasnapshot) {
        if (datasnapshot.id.contains('$studentName')) {
          Map<String, dynamic> data =
              datasnapshot.data() as Map<String, dynamic>;
          // log("Full Name: ${data.values}");
          log("${data['studentName']}");
          log("${data['studentID']}");
          log("${data['studyProgramID']}");
          log("${data['studentGPA']}");
        }
      },
    );
  }

  updateData() {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Students').doc('$studentName');
    //
    Map<String, dynamic> students = {
      'studentName': studentName,
      'studentID': studentID,
      'studyProgramID': studyProgramID,
      'studentGPA': studentGPA,
    };
    //
    documentReference
        .update(students)
        .whenComplete(() => {log("$studentName updated")});
  }

  deleteData() {
    CollectionReference documentReference =
        FirebaseFirestore.instance.collection('Students');

    documentReference
        .doc('$studentName')
        .delete()
        .whenComplete(() => {log("$studentName deleted")});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  onChanged: (String name) {
                    getStudentName(name);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Student ID',
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  onChanged: (String id) {
                    getStudentID(id);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Study Program ID',
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  onChanged: (String programID) {
                    getStudyProgramID(programID);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'GPA',
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  onChanged: (String gpa) {
                    getStudentGPA(gpa);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        createData();
                      },
                      child: Text('Create'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        readData();
                      },
                      child: Text('Read'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        updateData();
                      },
                      child: Text('Update'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.amber),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        deleteData();
                      },
                      child: Text('Delete'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  textDirection: TextDirection.ltr,
                  children: const [
                    Expanded(child: Text('Name')),
                    Expanded(child: Text('ID')),
                    Expanded(child: Text('ProgramID')),
                    Expanded(
                      child: Text('GPA'),
                    ),
                  ],
                ),
              ),
              StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('Students').snapshots(),
                builder: (context, snapshot) {
                  return Container(
                    child: snapshot.hasData
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot documentSnapshot =
                                  snapshot.data!.docs[index];
                              return Row(
                                children: [
                                  Expanded(
                                      child:
                                          Text(documentSnapshot['studentName'])),
                                  Expanded(
                                      child: Text(documentSnapshot['studentID'])),
                                  Expanded(
                                      child: Text(
                                          documentSnapshot['studyProgramID'])),
                                  Expanded(
                                      child: Text(documentSnapshot['studentGPA']
                                          .toString())),
                                ],
                              );
                            },
                          )
                        : const CircularProgressIndicator(),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
