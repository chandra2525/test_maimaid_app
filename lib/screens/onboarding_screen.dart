import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_maimaid_app/blocs/onboarding/onboarding_bloc.dart';
import 'package:test_maimaid_app/blocs/onboarding/onboarding_event.dart';
import 'package:test_maimaid_app/blocs/onboarding/onboarding_state.dart';
import 'package:test_maimaid_app/constants/color.dart';
import 'package:test_maimaid_app/models/slide_data.dart';
import 'package:test_maimaid_app/screens/user_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: BlocBuilder<SlideBloc, SlideState>(
        builder: (context, state) {
          final slide = slides[state.currentIndex];

          return SafeArea(
            child: Column(
              children: [
                Container(
                  // margin: EdgeInsets.only(top: 114),
                  height: 330,
                  width: 240,
                  child: Image.asset(slide.imagePath),
                ),
                Text(
                  slide.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.sen(
                    textStyle: const TextStyle(
                        color: black,
                        fontSize: 24,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0, bottom: 32.0),
                  child: Text(
                    slide.description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sen(
                      textStyle: const TextStyle(
                          color: grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    slides.length,
                    (index) => Container(
                      margin: EdgeInsets.all(4.0),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color:
                            index == state.currentIndex ? primary : orangeLight,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24.0, right: 24.0, bottom: 12.0, top: 70.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 62,
                    child: ElevatedButton(
                      onPressed: () {
                        if (state.currentIndex != 3) {
                          context.read<SlideBloc>().add(NextSlide());
                        } else {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => UserScreen()),
                          );
                        }
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
                        state.currentIndex == 3 ? 'GET STARTED' : 'NEXT',
                        style: GoogleFonts.sen(
                          textStyle: const TextStyle(
                              color: white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ),
                if (state.currentIndex != 3)
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24.0, right: 24.0, bottom: 12.0),
                    child: Container(
                      width: double.infinity,
                      height: 62,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<SlideBloc>().add(PrevSlide());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: white,
                          foregroundColor: black,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12.0), // rounded corners
                          ),
                        ),
                        child: Text(
                          'PREV',
                          style: GoogleFonts.sen(
                            textStyle: const TextStyle(
                                color: grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (state.currentIndex != 3)
                  Container(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    width: double.infinity,
                    height: 62,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => UserScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: white,
                        foregroundColor: black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12.0), // rounded corners
                        ),
                      ),
                      child: Text(
                        'SKIP',
                        style: GoogleFonts.sen(
                          textStyle: const TextStyle(
                              color: grey,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
