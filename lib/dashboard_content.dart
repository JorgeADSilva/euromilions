import 'package:euromilions/extractions_content.dart';
import 'package:euromilions/firebase/firestore_reader.dart';
import 'package:euromilions/models.dart';
import 'package:euromilions/user_content_section.dart';
import 'package:flutter/material.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  final FirestoreReader firestoreReader = FirestoreReader();
  late UserList userList = UserList(users: []);
  late ExtractionsList extractionsList = ExtractionsList(extractions: []);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image(image: AssetImage('images/logo.png'))),
                  ),
                  Text("Euromilhões Arrifanenses"),
                ],
              ),
            ],
          ),
          Expanded(
            flex: 3,
            child: UsersContent(
                firestoreReader: firestoreReader, userList: userList),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
                child: ExtractionsContent(
                    firestoreReader: firestoreReader, userList: userList)),
          ),
        ],
      ),
    );
  }
}
