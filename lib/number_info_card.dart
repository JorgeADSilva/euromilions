import 'package:euromilions/models.dart';
import 'package:flutter/material.dart';

class NumberInfoCard extends StatelessWidget {
  final Number number;
  const NumberInfoCard({
    Key? key,
    required this.number,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: number.validated
            ? Colors.green.withOpacity(0.8)
            : Colors.red.withOpacity(0.3),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: Text(number.value.toString())),
    );
  }
}