import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  final bool isActive;

  DotIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
