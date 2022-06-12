import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance_calculators_app/simpleList.dart';
import 'package:flutter/material.dart';

class Simple extends StatelessWidget {
  const Simple({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController principalController = TextEditingController();
    TextEditingController interestController = TextEditingController();
    TextEditingController yearsController = TextEditingController();

    Future _accrued() {
      final principal = principalController.text;
      final interest = interestController.text;
      final years = yearsController.text;
      final ref = FirebaseFirestore.instance.collection("simple").doc();

      var p = double.tryParse(principal) ?? 0;
      var i = double.tryParse(interest) ?? 0;
      i = i / 100;
      var y = double.tryParse(years) ?? 0;
      var total = p * (1 + i * y);
      var totalString = total.toString();

      return ref
          .set({
            "Principal": principal,
            "Interest": interest,
            "Years": years,
            "Accrued": totalString,
            "ID": ref.id
          })
          .then((value) => log("Collection added!"))
          .catchError((onError) => log(onError));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Interest Calculator"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          children: [
            Image.asset("assets/images/simple.png"),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Explore the works of simple interest",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              controller: principalController,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.monetization_on_outlined,
                  size: 24,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Principal Amount (Rands)",
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: interestController,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.percent,
                  size: 24,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Interest (per year)",
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: yearsController,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.calendar_month_outlined,
                  size: 24,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Years",
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                _accrued();
              },
              child: const Text("Calculate"),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Previous calculations...",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SingleChildScrollView(
              child: SimpleList(),
            ),
          ],
        ),
      ),
    );
  }
}
