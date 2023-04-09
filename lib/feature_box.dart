import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  const FeatureBox({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 10,
      ),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(15))),
    );
  }
}
