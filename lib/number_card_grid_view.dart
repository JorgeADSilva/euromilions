import 'package:euromilions/number_info_card.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class NumberCardGridView extends StatelessWidget {
  final int crossAxisCount;
  final double childAspectRatio;
  final List<dynamic>? numbers;

  const NumberCardGridView({
    Key? key,
    this.crossAxisCount = 6,
    this.childAspectRatio = 1,
    this.numbers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: numbers!.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: Constants.defaultPadding / 2,
        mainAxisSpacing: Constants.defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => NumberInfoCard(number: numbers![index]),
    );
  }
}
