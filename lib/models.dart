import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String payment;
  List<Number> numbers;
  String name;

  User({
    required this.payment,
    required this.numbers,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      payment: json['payment'],
      numbers: (json['numbers'] as List<dynamic>)
          .map((numberJson) => Number.fromJson(numberJson))
          .toList(),
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "payment": payment,
      "numbers": numbers.map((number) => number.toJson()).toList(),
    };
  }
}

class Number {
  int value;
  bool validated;

  Number({
    required this.value,
    this.validated = false,
  });

  factory Number.fromJson(Map<String, dynamic> json) {
    return Number(
      value: json['value'],
      validated: json['validated'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "value": value,
      "validated": validated,
    };
  }

  @override
  String toString() {
    return value.toString();
  }

  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Number && other.value ==value;
  }

  @override
  int get hashCode => value.hashCode;
}

class UserList {
  List<User> users;

  UserList({required this.users});

  factory UserList.fromJson(Map<String, dynamic> json) {
    return UserList(
      users: (json['users'] as List<dynamic>)
          .map((userJson) => User.fromJson(userJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "users": users.map((user) => user.toJson()).toList(),
    };
  }

  void validateUserNumbers(ExtractionsList extractionsList) {
    for (var user in users) {
      for (var extraction in extractionsList.extractions) {
        for (var element in user.numbers) {
          if (extraction.numbers.contains(element)) element.validated = true;
        }
      }
    }
  }
}

class Extraction {
  Timestamp date;
  List<Number> numbers;

  Extraction({
    required this.date,
    required this.numbers,
  });

  factory Extraction.fromJson(Map<String, dynamic> json) {
    return Extraction(
      date: json['date'] as Timestamp,
      numbers: (json['numbers'] as List<dynamic>)
          .map((numberJson) => Number.fromJson(numberJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "numbers": numbers.map((number) => number.toJson()).toList(),
    };
  }
}

class ExtractionsList {
  List<Extraction> extractions;

  ExtractionsList({required this.extractions});

  factory ExtractionsList.fromJson(Map<String, dynamic> json) {
    return ExtractionsList(
      extractions: (json['extractions'] as List<dynamic>)
          .map((extractionJson) => Extraction.fromJson(extractionJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "extractions":
          extractions.map((extraction) => extraction.toJson()).toList(),
    };
  }
}
