// ignore_for_file: file_names
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompoundList extends StatefulWidget {
  const CompoundList({Key? key}) : super(key: key);

  @override
  State<CompoundList> createState() => _CompoundListState();
}

class _CompoundListState extends State<CompoundList> {
  final Stream<QuerySnapshot> myCalculations =
      FirebaseFirestore.instance.collection("compound").snapshots();

  @override
  Widget build(BuildContext context) {
    TextEditingController principalController = TextEditingController();
    TextEditingController interestController = TextEditingController();
    TextEditingController periodController = TextEditingController();
    TextEditingController typeController = TextEditingController();

    void _delete(docId) {
      FirebaseFirestore.instance
          .collection("compound")
          .doc(docId)
          .delete()
          .then((value) => {log("record deleted")});
    }

    void _update(data) {
      principalController.text = data["Principal"];
      interestController.text = data["Interest"];
      periodController.text = data["Periods"];
      typeController.text = data["Type"];

      var collection = FirebaseFirestore.instance.collection("compound");

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Update your calculation"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: principalController,
              ),
              TextField(
                controller: interestController,
              ),
              TextField(
                controller: periodController,
              ),
              TextField(
                controller: typeController,
              ),
              TextButton(
                onPressed: () {
                  collection.doc(data["ID"]).update({
                    "Principal": principalController.text,
                    "Interest": interestController.text,
                    "Periods": periodController.text,
                    "Type": typeController.text,
                    "Accrued": principalController.text
                  }).then((value) {
                    principalController.text = "";
                    interestController.text = "";
                    periodController.text = "";
                    typeController.text = "";
                  });
                  Navigator.pop(context);
                },
                child: const Text("Update"),
              ),
            ],
          ),
        ),
      );
    }

    return StreamBuilder(
      stream: myCalculations,
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong...");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          return Row(children: [
            Expanded(
              flex: 3,
              child: SizedBox(
                height: (MediaQuery.of(context).size.height),
                width: (MediaQuery.of(context).size.width),
                child: ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot snap) {
                    Map<String, dynamic> items =
                        snap.data()! as Map<String, dynamic>;
                    return Column(
                      children: [
                        Card(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(items['Accrued']),
                                subtitle: Text(items['Principal']),
                              ),
                              ButtonTheme(
                                child: ButtonBar(
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        _update(items);
                                      },
                                      icon: const Icon(Icons.edit),
                                      label: const Text("Edit"),
                                    ),
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        _delete(items["ID"]);
                                      },
                                      icon: const Icon(Icons.delete),
                                      label: const Text("Delete"),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ]);
        } else {
          return const Text("No Data");
        }
      },
    );
  }
}
