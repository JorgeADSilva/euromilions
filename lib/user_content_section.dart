import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euromilions/firebase/firestore_reader.dart';
import 'package:euromilions/models.dart';
import 'package:euromilions/number_card_grid_view.dart';
import 'package:euromilions/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UsersContent extends StatefulWidget {
  final UserList userList;
  const UsersContent({
    super.key,
    required this.firestoreReader,
    required this.userList,
  });

  final FirestoreReader firestoreReader;

  @override
  State<UsersContent> createState() => _UsersContentState();
}

class _UsersContentState extends State<UsersContent> {
  CollectionReference usersReference =
      FirebaseFirestore.instance.collection('euromilions');

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final List<Widget> usersWidgetList = [];
    widget.userList.users = [];

    return Column(
      children: [
        if (kDebugMode) 
          FloatingActionButton(
            onPressed: () async {
              await _showDialog(widget.userList, context);
            },
          ),
        Expanded(
          child: SingleChildScrollView(
            child: StreamBuilder<Map<String, dynamic>>(
              stream: widget.firestoreReader
                  .streamDataFromFirestore('euromilions', 'v1'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  widget.userList.users =
                      UserList.fromJson(snapshot.data as Map<String, dynamic>)
                          .users;
                  for (var user in widget.userList.users) {
                    usersWidgetList.add(
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.name),
                            Responsive(
                              mobile: NumberCardGridView(
                                crossAxisCount: 10,
                                childAspectRatio: 1,
                                numbers: user.numbers,
                              ),
                              tablet: NumberCardGridView(
                                crossAxisCount: 10,
                                childAspectRatio: 1,
                                numbers: user.numbers,
                              ),
                              desktop: NumberCardGridView(
                                childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
                                crossAxisCount: 10,
                                numbers: user.numbers,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Column(children: usersWidgetList);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  _showDialog(
    UserList userList,
    BuildContext context,
  ) async {
    final TextEditingController usernameTextFieldController =
        TextEditingController();
    final TextEditingController paymentTextFieldController =
        TextEditingController();
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
                      const Text("Nome:"),
                      TextField(
                        onChanged: (value) {},
                        controller: usernameTextFieldController,
                        decoration: const InputDecoration(
                            hintText: "Nome do participante"),
                      ),
                      const Text("Pagamento:"),
                      TextField(
                        onChanged: (value) {},
                        controller: paymentTextFieldController,
                        decoration: const InputDecoration(
                            hintText: "A quem é que pagou"),
                      ),
                      const Text("Números:"),
                      TextField(
                        onChanged: (value) {},
                        controller: numbersTextFieldController,
                        decoration: const InputDecoration(
                            hintText: "Números separados por vírgulas"),
                      ),
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
                  child: const Text('SAVE'),
                  onPressed: () async {
                    List<Number> numbers = [];
                    for (var number
                        in numbersTextFieldController.text.split(',')) {
                      numbers.add(Number(value: int.parse(number)));
                    }
                    userList.users.add(User(
                        payment: paymentTextFieldController.text,
                        numbers: numbers,
                        name: usernameTextFieldController.text));
                    setState(() {});
                    await addUser(userList);
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  Future<void> addUser(UserList userList) {
    return usersReference
        .doc("v1")
        .set(userList.toJson())
        // ignore: avoid_print
        .then((value) => print("saved"))
        // ignore: avoid_print
        .catchError((error) => print("Failed to add user: $error"));
  }
}
