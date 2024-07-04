import 'package:flutter/material.dart';
import 'package:test_maimaid_app/constants/color.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessfullScreen extends StatelessWidget {
  final String tipe;

  SuccessfullScreen(this.tipe);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Icon(
                  Icons.check,
                  color: white,
                  size: 60,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28.0, bottom: 21.0),
              child: Text(
                tipe == 'create'
                    ? "Create Successful"
                    : tipe == 'delete'
                        ? "Delete Successful"
                        : "Update Successful",
                style: GoogleFonts.sen(
                    fontSize: 24, fontWeight: FontWeight.w500, color: black2),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 34.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: black,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12.0), // rounded corners
                    ),
                  ),
                  child: Text(
                    'OK',
                    style: GoogleFonts.sen(
                      textStyle: const TextStyle(
                          color: white,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
