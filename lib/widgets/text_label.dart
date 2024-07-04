import 'package:flutter/material.dart';
import 'package:test_maimaid_app/widgets/colors.dart';

class TextLabel extends StatelessWidget {
  const TextLabel(
      {super.key,
      required this.text,
      this.color,
      this.font,
      this.size,
      this.weight,
      this.textAlign,
      this.height,
      this.overflow});
  final text;
  final color;
  final font;
  final size;
  final weight;
  final textAlign;
  final height;
  final overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toString(),
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
          color: color ?? ColorsApp.colorNeutralBgPrimary,
          fontSize: size,
          fontWeight: weight,
          height: height,
          overflow: overflow),
    );
  }
}
