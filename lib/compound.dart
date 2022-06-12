import 'dart:math';
import 'package:finance_calculators_app/compoundList.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Compound extends StatelessWidget {
  const Compound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController principalController = TextEditingController();
    TextEditingController interestController = TextEditingController();
    TextEditingController periodController = TextEditingController();
    TextEditingController typeController = TextEditingController();

    Future _accrued() {
      final principal = principalController.text;
      final interest = interestController.text;
      final period = periodController.text;
      final type = typeController.text;

      var compounding = 1;
      if (type.toLowerCase().startsWith('d')) {
        compounding = 365;
      } else if (type.toLowerCase().startsWith('w')) {
        compounding = 52;
      } else if (type.toLowerCase().startsWith('m')) {
        compounding = 12;
      } else if (type.toLowerCase().startsWith('q')) {
        compounding = 4;
      } else if (type.toLowerCase().startsWith('s')) {
        compounding = 2;
      } else if (type.toLowerCase().startsWith('a') ||
          type.toLowerCase().startsWith('y')) {
        compounding = 1;
      }

      var p = double.tryParse(principal) ?? 0;
      var i = double.tryParse(interest) ?? 0;
      i = i / 100;
      var y = double.tryParse(period) ?? 1;
      var total = p * pow((1 + i / compounding), y * compounding);
      var totalString = total.toStringAsFixed(2);

      final ref = FirebaseFirestore.instance.collection("compound").doc();

      return ref
          .set({
            "Principal": principal,
            "Interest": interest,
            "Periods": period,
            "Type": type,
            "Accrued": totalString,
            "ID": ref.id
          })
          // ignore: avoid_print
          .then((value) => print("Collection added!"))
          // ignore: avoid_print
          .catchError((onError) => print(onError));
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Compound Interest Calculator"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          children: [
            Image.asset("assets/images/compound.png"),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Use the magic of compound interest",
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
                hintText: "Interest (per period)",
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: typeController,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.calendar_month_outlined,
                  size: 24,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Compounding Type",
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: periodController,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.numbers,
                  size: 24,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Compounding Periods",
              ),
            ),
            const SizedBox(
              height: 12,
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
              child: CompoundList(),
            )
          ],
        ),
      ),
    );
  }
}
