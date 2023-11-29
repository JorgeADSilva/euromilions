import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreReader {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<Map<String, dynamic>> streamDataFromFirestore(String collection, String documentId) {
    return firestore.collection(collection).doc(documentId).snapshots().map(
          (DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          return snapshot.data() as Map<String, dynamic>;
        } else {
          if (kDebugMode) {
            print('Document $documentId does not exist');
          }
          return {};
        }
      },
    );
  }
}