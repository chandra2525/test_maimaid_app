import 'package:flutter/material.dart';
import 'package:test_maimaid_app/widgets/colors.dart';

class Button extends StatelessWidget {
  const Button(
      {super.key,
      required this.text,
      this.color,
      this.font,
      this.size,
      this.weight,
      this.onPressed,
      this.borderSide,
      this.colorFont});
  final text;
  final color;
  final font;
  final size;
  final weight;
  final onPressed;
  final borderSide;
  final colorFont;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        side: borderSide ?? null,
        // padding: const EdgeInsets.fromLTRB(20, 12, 20, 12)
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Text(
          text,
          style: TextStyle(
              fontWeight: weight,
              color: colorFont ?? ColorsApp.colorBrandOnPrimary,
              fontSize: size),
        ),
      ),
    );
  }
}

// class Button2 extends StatelessWidget {
//   const Button2(
//       {super.key,
//       required this.text,
//       this.color,
//       this.font,
//       this.size,
//       this.weight,
//       this.onPressed});
//   final text;
//   final color;
//   final font;
//   final size;
//   final weight;
//   final onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         Get.toNamed('/onBoard3');
//       },
//       style: ElevatedButton.styleFrom(
//           foregroundColor: Colors.white,
//           backgroundColor: color,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(50),
//           ),
//           padding: const EdgeInsets.fromLTRB(20, 12, 20, 12)),
//       child: Text(
//         text,
//         style: TextStyle(
//             fontFamily: font ?? FontsApp.interMedium,
//             fontWeight: weight,
//             fontSize: size),
//       ),
//     );
//   }
// }

// class Button3 extends StatelessWidget {
//   const Button3(
//       {super.key,
//       required this.text,
//       this.color,
//       this.font,
//       this.size,
//       this.weight,
//       this.onPressed});
//   final text;
//   final color;
//   final font;
//   final size;
//   final weight;
//   final onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
        
//       },
//       style: ElevatedButton.styleFrom(
//           foregroundColor: Colors.white,
//           backgroundColor: color,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(50),
//           ),
//           padding: const EdgeInsets.fromLTRB(20, 12, 20, 12)),
//       child: Row(
//         children: [
//           Text(
//             text,
//             style: TextStyle(
//                 fontFamily: font ?? FontsApp.interMedium,
//                 fontWeight: weight,
//                 fontSize: size),
//           ),
//           const SizedBox(width: 10),
//           Container(
//             padding: EdgeInsets.zero,
//             child: const Icon(
//               Icons.arrow_forward_outlined,
//               fill: 0.5,
//               size: 20.0,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
