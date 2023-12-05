import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euromilions/firebase/firestore_reader.dart';
import 'package:euromilions/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'extractions/extractions_board.dart';

class ExtractionsContent extends StatefulWidget {
  final UserList userList;
  const ExtractionsContent({
    super.key,
    required this.firestoreReader,
    required this.userList,
  });

  final FirestoreReader firestoreReader;

  @override
  State<ExtractionsContent> createState() => _ExtractionsContentState();
}

class _ExtractionsContentState extends State<ExtractionsContent> {
  @override
  Widget build(BuildContext context) {
    final ExtractionsList extractionsList = ExtractionsList(extractions: []);

    return Column(
      children: [
        if (kDebugMode)
          TextButton(
              onPressed: () {
                widget.userList.validateUserNumbers(extractionsList);
                FirebaseFirestore.instance
                    .collection('euromilions')
                    .doc("v1")
                    .set(widget.userList.toJson())
                    // ignore: avoid_print
                    .then((value) => print("Users saved"))
                    // ignore: avoid_print
                    .catchError((error) => print("Failed to add user: $error"));
              },
              child: const Text("Validate users")),
        if (kDebugMode)
          TextButton(
              onPressed: () async {
                await _showDialog(extractionsList);
              },
              child: const Text("Add extraction")),
        StreamBuilder<Map<String, dynamic>>(
          stream: widget.firestoreReader
              .streamDataFromFirestore('euromilions', 'extractions'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              extractionsList.extractions.addAll(ExtractionsList.fromJson(
                      snapshot.data as Map<String, dynamic>)
                  .extractions);

              return RecentFiles(extractionsList: extractionsList);
            }
          },
        ),
      ],
    );
  }

  _showDialog(ExtractionsList extractionsList) async {
    final TextEditingController numbersTextFieldController =
        TextEditingController();

    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: [
                      const Text("Números:"),
                      TextField(
                        onChanged: (value) {},
                        controller: numbersTextFieldController,
                      ),
                      const Text("Pagamento:"),
                    ],
                  ),
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: const Text('Save'),
                  onPressed: () async {
                    List<Number> numbers = [];
                    for (var number
                        in numbersTextFieldController.text.split(',')) {
                      numbers.add(Number(value: int.parse(number)));
                    }
                    extractionsList.extractions.add(Extraction(
                      date: Timestamp.now(),
                      numbers: numbers,
                    ));
                    await FirebaseFirestore.instance
                        .collection('euromilions')
                        .doc("extractions")
                        .set(extractionsList.toJson())
                        // ignore: avoid_print
                        .then((value) => widget.userList
                            .validateUserNumbers(extractionsList))
                        // ignore: avoid_print
                        .catchError((error) => kDebugMode
                            ? print("Failed to add user: $error")
                            : {});
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }
}
