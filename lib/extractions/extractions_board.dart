import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euromilions/models.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

// ignore: must_be_immutable
class RecentFiles extends StatelessWidget {
  final ExtractionsList extractionsList;
  RecentFiles({
    Key? key,
    required this.extractionsList,
  }) : super(key: key);

  List demoRecentExtractions = [
    Extraction(
      date: Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch),
      numbers: [
        Number(value: 1),
      ],
    ),
    Extraction(
      date: Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch),
      numbers: [
        Number(value: 1),
        Number(value: 2),
        Number(value: 3),
        Number(value: 4),
        Number(value: 5),
        Number(value: 6),
      ],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      decoration: const BoxDecoration(
        color: Constants.secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Últimos sorteios",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: Constants.defaultPadding,
              // minWidth: 600,
              columns: const [
                DataColumn(
                  label: Text("Números"),
                ),
                DataColumn(
                  label: Text("Data"),
                ),
              ],
              rows: List.generate(
                extractionsList.extractions.length,
                (index) =>
                    extractionDataRow(extractionsList.extractions[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow extractionDataRow(Extraction extraction) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            const Icon(Icons.receipt),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: FittedBox(
                  child: Text(extraction.numbers.join(' , ').toString())),
            ),
          ],
        ),
      ),
      DataCell(Text(
          "${extraction.date.toDate().day}-${extraction.date.toDate().month}-${extraction.date.toDate().year}")),
    ],
  );
}
